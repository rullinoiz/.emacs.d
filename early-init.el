;;; -*- lexical-binding: t -*-

;;(benchmark-init/activate)
;;(add-hook 'after-init-hook #'benchmark-init/deactivate)

(setq inhibit-startup-screen t)

;; supa speed
(setq gc-cons-threshold most-positive-fixnum)
(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 50 1024 1024))))

;;; transparent window
;;(set-frame-parameter (selected-frame) 'alpha-background 60)
;;(add-to-list 'default-frame-alist '(alpha-background . 60))

(push '(vertical-scroll-bars . nil) default-frame-alist)
(push (expand-file-name "themes" user-emacs-directory) custom-theme-load-path)
(push (expand-file-name "modules" user-emacs-directory) load-path)
(push (expand-file-name "lisp" user-emacs-directory) load-path)
(push (expand-file-name "icons" user-emacs-directory) load-path)

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
   (xterm-mouse-mode 1)
   (mouse-wheel-mode 1)))

(when (display-graphic-p)
  (tool-bar-mode -1))
			     
(add-hook 'window-setup-hook #'--remove-background)
