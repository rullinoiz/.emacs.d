;;; -*- lexical-binding: t -*-

(defvar theme--load-file-name (file-in-emacs-directory "theme.el"))

(add-hook
 'window-size-change-functions
 (lambda (frame)
   (let ((fullscreen-state (frame-parameter frame 'fullscreen)))
     (cond ((memq fullscreen-state '(fullboth fullscreen)) (set-frame-parameter frame 'alpha-background 100))
	    (t (set-frame-parameter frame 'alpha-background 60))))))

(add-hook
 'prog-mode-hook
 'display-line-numbers-mode)

(when (display-graphic-p)
  (tool-bar-mode -1))

;;(setq-default header-line-format "Emacs 31")

(add-hook
 'before-save-hook
 (lambda ()
   (if (string= theme--load-file-name load-file-name)
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

(add-hook 'org-mode-hook 'visual-line-mode)

(use-package doom-modeline
  :init
  (setq doom-modeline-buffer-file-name-style 'file-name-with-project)
  (setq doom-modeline-height 25)
  (setq doom-modeline-position-line-format nil)
  (setq doom-modeline-minor-modes t)
  (setq nerd-icons-scale-factor 1.2)
  
  (unless (display-graphic-p (selected-frame))
    (setq doom-modeline-major-mode-icon nil)
    (setq doom-modeline-vcs-icon nil))
  
  (doom-modeline-mode 1))

;; (use-package spacious-padding
;;   :ensure t
;;   :init (spacious-padding-mode 1)
;;   :config
;;   (setq spacious-padding-widths
;; 	'( :internal-border-width 15
;; 	   :header-line-width 0
;; 	   :mode-line-width 0
;; 	   :right-divider-width 0
;; 	   :fringe-width 0)))
