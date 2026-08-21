;;; -*- lexical-binding: t -*-

(xterm-mouse-mode 1)
(mouse-wheel-mode 1)

(setq inhibit-startup-screen t)

;;; transparent window
(set-frame-parameter (selected-frame) 'alpha-background 60)
;;(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(alpha-background . 60))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(add-to-list 'load-path "~/.emacs.d/modules")

(defun --remove-background (&optional frame)
  (or frame (setq frame (selected-frame)))
  (unless (display-graphic-p frame)
    (set-face-attribute 'default frame :background "#00000000")))

(defun --load-theme ()
  (load-theme 'even-deeper-blue t)
  (--remove-background (selected-frame)))

(--load-theme)

(add-hook
 'after-init-hook
 (lambda ()
   (when (display-graphic-p)
     (tool-bar-mode -1))))
			     
(add-hook 'window-setup-hook #'--remove-background)
