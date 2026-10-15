;;; -*- lexical-binding: t -*-

(defmacro os-switch! (&rest plist)
  "Emit the code block based on the current host OS."
  (declare (indent 0))
  (let ((clauses nil)
	(remaining plist))
    (while remaining
      (let ((current-keys nil))
	(while (and remaining (keywordp (car remaining)))
	  (push (pop remaining) current-keys))

	(let ((body nil))
	  (while (and remaining (not (keywordp (car remaining))))
	    (push (pop remaining) body))

	  (let ((sys-symbols nil))
	    (dolist (os current-keys)
	      (let ((sym (pcase os
			   (:darwin 'darwin)
			   (:linux 'gnu/linux)
			   (:windows 'windows-nt)
			   (:bsd 'gnu/kfreebsd)
			   (:ms-dos 'ms-dos)
			   (:hurd 'gnu)
			   (:haiku 'haiku)
			   (:android 'android)
			   (:default 'default))))
		(push sym sys-symbols)))

	    (let ((cond-expr (if (memq 'default sys-symbols)
				 't
			       `(memq system-type ',sys-symbols))))
	      (push `(,cond-expr ,@(nreverse body)) clauses))))))
    
    `(cond ,@(nreverse clauses))))

(provide 'macros)
