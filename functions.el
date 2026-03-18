;;; -*- lexical-binding: t -*-

(defvar --functions-load-file-name (file-in-emacs-directory "functions.el"))

;; custom functions

;; quickly open user-init-file
;; https://emacs.stackexchange.com/a/3172
(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(defun open-init-file-other-window ()
  "Open the init file in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defun open-func-file ()
  "Open the functions file."
  (interactive)
  (find-file --functions-load-file-name))

(defun open-func-file-other-window ()
  "Open the functions file in another window."
  (interactive)
  (find-file-other-window --functions-load-file-name))

(dolist (bind #'(("C-c o i" . open-init-file)
		("C-c C-o i" . open-init-file-other-window)
		("C-c o f" . open-func-file)
		("C-c C-o f" . open-func-file-other-window)
		("C-c o l" . find-library)
		("<escape>" . keyboard-escape-quit)
		("M-RET" . toggle-frame-fullscreen)))
  (global-set-key (kbd (car bind)) (cdr bind)))

;; custom hooks
(add-hook
 #'before-save-hook
 (lambda ()
   (if (string= user-init-file buffer-file-name)
       (eval-buffer))))

(add-hook
 #'before-save-hook
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
 #'lisp-mode
   (define-key lisp-mode-shared-map (kbd "C-c e k") #'eval-region-and-kill))

