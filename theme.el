;;; -*- lexical-binding: t -*-

(defvar theme--load-file-name (file-in-emacs-directory "theme.el"))

(add-hook
 'window-setup-hook
 (lambda ()
   ;; load theme on startup
   (load-theme 'deeper-blue)
   (set-background-color "black")
   (unless (display-graphic-p (selected-frame))
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

(defun open-theme-file ()
  "Open the theme file."
  (interactive)
  (find-file theme--load-file-name))

(defun open-theme-file-other-window ()
  "Open the theme file in another window."
  (interactive)
  (find-file-other-window theme--load-file-name))

(global-set-key (kbd "C-c o t") #'open-theme-file)
(global-set-key (kbd "C-c C-o t") #'open-theme-file-other-window)

(add-hook #'org-mode-hook #'visual-line-mode)

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-height 30)
  (setq doom-modeline-position-line-format nil)
  (setq doom-modeline-minor-modes t)
  (setq nerd-icons-scale-factor 1.2)
  
  (doom-modeline-mode 1))
