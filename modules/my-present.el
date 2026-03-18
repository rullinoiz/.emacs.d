;; -*- lexical-binding: t; -*-

(use-package hide-mode-line)
(use-package olivetti)

(defun my/presentation-setup ()
  "Main presentation start hook handler for setting fonts, disabling line numbers, and other improvements"
  (interactive)
  (display-line-numbers-mode 0)
  (hide-mode-line-mode 1)
  (text-scale-mode 1)
  (olivetti-mode 1)
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq text-scale-mode-amount 4)
  (setq org-hide-emphasis-markers t)
  (setq cursor-type nil)
  (set-face-attribute 'org-meta-line nil :foreground (face-attribute 'default :background))
  (font-lock-flush))

(defun my/presentation-end ()
  "Main presentation end hook handler for resetting fonts to make editing great again"
  (interactive)
  (display-line-numbers-mode 1)
  (hide-mode-line-mode 0)
  (olivetti-mode 0)
  (setq-local face-remapping-alist '())
  (setq org-hide-emphasis-markers nil)
  (setq cursor-type 'box)
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

(use-package org
  :bind (:map org-mode-map
	      ("<f9>" . org-tree-slide-mode))
  :custom
  (org-image-actual-width nil)
  (org-display-inline-images))

(use-package org-tree-slide
  :hook ((org-tree-slide-play . my/presentation-setup)
         (org-tree-slide-stop . my/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect nil)
  (org-tree-slide-activate-message "Begin presentation")
  (org-tree-slide-deactivate-message "End presentation")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > "))

(provide 'my-present)
