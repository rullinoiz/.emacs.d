;;; -*- lexical-binding: t -*-

(require 'map)

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

(defvar-local variable-stack nil
  "alist in the form (VARIABLE . STACK), where STACK is previous states of VARIABLE.
Use the function `setq-push' to modify VARIABLE and push its previous state, and the
function `setq-pop' to revert VARIABLE to a previous state.")

(defmacro setq-push (&rest pairs)
  (let (forms)
    (while pairs
      (let ((var (pop pairs))
	    (val (pop pairs)))
	(push `(push ,var (map-elt variable-stack (quote ,var))) forms)
	(push `(setq-local ,var ,val) forms)))
    `(progn ,@(nreverse forms))))

(defmacro setq-pop (&rest variables)
  (let (forms)
    (while-let ((var (pop variables)))
      (push `(if (map-elt variable-stack (quote ,var))
		 (setq-local ,var (pop (map-elt variable-stack (quote ,var)))))
	    forms))
    `(progn ,@(nreverse forms))))


(provide 'macros)
