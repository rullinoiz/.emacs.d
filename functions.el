;;; -*- lexical-binding: t -*-

(setq --functions-load-file-name load-file-name)

;; custom functions

;; quickly open user-init-file
;; https://emacs.stackexchange.com/a/3172
(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(defun open-func-file ()
  "Open the functions file."
  (interactive)
  (find-file --functions-load-file-name))

;; custom hooks
(add-hook
 'before-save-hook
 (lambda ()
   (if (string= user-init-file buffer-file-name)
       (eval-buffer))))

(add-hook
 'before-save-hook
 (lambda ()
   (if (string= --functions-load-file-name buffer-file-name)
       (eval-buffer))))

(defun eval-region-and-kill ()
  "Evaluate the region and kill the result."
  (interactive)
  (let ((result (eval-last-sexp nil)))
    (kill-new result)
    (message result)))

(with-eval-after-load
 'lisp-mode
   (define-key lisp-mode-shared-map (kbd "C-c e k") 'eval-region-and-kill))

