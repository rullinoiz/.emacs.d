;;; oiz-segments.el --- my doom modeline segments

(defmacro oiz-segments-define (name reqs &rest body)
  "Define a doom-modeline segment NAME that uses REQS with BODY."
  (declare (indent defun))
  (if (all #'featurep reqs)
      `(progn ,@(mapcar (lambda (sym) `(require (quote ,sym))) reqs)
	      (doom-modeline-def-segment ,name ,@body))
    `(doom-modeline-def-segment ,name "")))

(oiz-segments-define popper-status (popper)
  (if popper-popup-status
      '(:eval (propertize "POP" 'face 'mode-line-emphasis))))

(oiz-segments-define popper-buried-popups (popper popper-echo)
  (if popper-popup-status
      '(:eval (let ((buried (popper-echo--popup-info)))
		(if (length> buried 1)
		    (mapcar (lambda (buf)
			      (concat
			       "/"
			       (propertize (buffer-name buf) 'face 'popper-echo-area-buried)))
			    (cdr buried)))))))

(provide 'oiz-segments)
