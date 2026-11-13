;; -*- lexical-binding: t; -*-

(require 'macros)

(use-package hide-mode-line
  :defer t)
(use-package olivetti
  :defer t)

(defun my/presentation-setup ()
  "Main presentation start hook handler for setting fonts, disabling line numbers, and other improvements"
  (interactive)
  (display-line-numbers-mode 0)
  (hide-mode-line-mode 1)
  (text-scale-mode 1)
  (olivetti-mode 1)
  (page-break-lines-mode 1)
  
  (setq-push face-remapping-alist '((default variable-pitch default))
	     text-scale-mode-amount 4
	     org-hide-emphasis-markers t
	     cursor-type nil
	     olivetti-minimum-body-width 100)
  
  (set-face-attribute 'org-meta-line nil :foreground (face-attribute 'default :background))
  (font-lock-flush))

(defun my/presentation-end ()
  "Main presentation end hook handler for resetting fonts to make editing great again"
  (interactive)
  (display-line-numbers-mode 1)
  (hide-mode-line-mode 0)
  (olivetti-mode 0)
  (page-break-lines-mode 0)
  
  (setq-pop face-remapping-alist
	    org-hide-emphasis-markers
	    cursor-type
	    text-scale-mode-amount
	    olivetti-minimum-body-width)
  
  (org-show-all)
  (set-face-attribute 'org-meta-line nil :foreground nil)
  (font-lock-flush))

(add-hook
 'org-mode-hook
 (lambda ()
   (dolist (face '((org-level-1 . 1.5)
		   (org-level-2 . 1.35)
		   (org-level-3 . 1.25)
		   (org-level-4 . 1.15)
		   (org-level-5 . 1.1)
		   (org-level-6 . 1.1)
		   (org-level-7 . 1.1)
		   (org-level-8 . 1.1)))
     (set-face-attribute (car face) nil :height (cdr face)))
   (dolist (face '(org-block-begin-line
		   org-block-end-line 
		   org-verbatim))
     (set-face-attribute face nil :inherit '(shadow fixed-pitch)))
   (set-face-attribute 'org-block nil :inherit '(fixed-pitch) :background "gray10")))

(with-eval-after-load 'org-mode
  (keymap-set org-mode-map "<f9>" '("Begin Presentation" . org-tree-slide-mode)))

(use-package org-tree-slide
  :defer t
  :after org
  :hook ((org-tree-slide-play . my/presentation-setup)
         (org-tree-slide-stop . my/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect nil)
  (org-tree-slide-activate-message "Swag mode ON")
  (org-tree-slide-deactivate-message "Swag mode OFF")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > "))

(provide 'my-present)
