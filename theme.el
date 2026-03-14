;;; -*- lexical-binding: t -*-

(setq --theme-load-file-name load-file-name)

;; load theme on startup
(load-theme 'deeper-blue)
(set-background-color "black")

(add-hook
 'window-setup-hook
 (lambda () (set-background-color "black")))

(add-hook
 'window-setup-hook
 (lambda () (unless (display-graphic-p (selected-frame))
	      (set-face-background 'default "unspecified-bg" (selected-frame)))))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(global-display-line-numbers-mode)
(setq inhibit-startup-screen t)

;; transparent window
(set-frame-parameter (selected-frame) 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

(add-hook
 'before-save-hook
 (lambda ()
   (if (string= --theme-load-file-name load-file-name)
       (eval-buffer))))
