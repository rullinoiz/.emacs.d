;;; -*- lexical-binding: t -*-

(setq inhibit-startup-screen t)

(setq gc-cons-threshold most-positive-fixnum)
(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 50 1024 1024))))

;;; transparent window
;;(set-frame-parameter (selected-frame) 'alpha-background 60)
;;(add-to-list 'default-frame-alist '(alpha-background . 60))

(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "icons" user-emacs-directory))

(defun --remove-background (&optional frame)
  (or frame (setq frame (selected-frame)))
  (unless (display-graphic-p frame)
    (set-face-attribute 'default frame :background "#00000000")))

(defun --load-theme ()
  (load-theme 'gradianto-midnight-blue t)
  (--remove-background (selected-frame)))

(--load-theme)

(add-hook
 'after-init-hook
 (lambda ()
   (mouse-wheel-mode 1)))

(when (display-graphic-p)
  (tool-bar-mode -1))
			     
(add-hook 'window-setup-hook #'--remove-background)
