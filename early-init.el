;;; -*- lexical-binding: t -*-

(xterm-mouse-mode 1)

(when (display-graphic-p)
  (scroll-bar-mode -1))

(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      use-short-answers t)

;;; transparent window
(set-frame-parameter (selected-frame) 'alpha-background 60)
;;(add-to-list 'default-frame-alist '(undecorated-round . t))
(add-to-list 'default-frame-alist '(alpha-background . 60))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

(add-hook
 'window-setup-hook
 (lambda ()
   ;; load theme on startup
   (load-theme 'deeper-blue)
   (set-background-color "black")
   (unless (display-graphic-p (selected-frame))
     (set-face-background 'default nil (selected-frame))
     (set-background-color "unspecified-bg"))))
