;;; -*- lexical-binding: t -*-

(defun file-in-emacs-directory (relative-path)
  "Get the path of a file inside of the `user-emacs-directory'."
  (interactive (list (read-file-name "File: " user-emacs-directory nil nil nil)))

  (when (called-interactively-p 'any)
    (message "%s" relative-path))
  
  (concat user-emacs-directory relative-path))

(defun add-directory-to-exec-path (path)
  "Add a directory to the PATH environment variable."
  (interactive "DDirectory: ")
  (add-to-list 'exec-path path)
  (setenv "PATH" (concat path ":" (getenv "PATH"))))

(cl-defmacro os-switch (&key darwin windows linux)
  "Perform a different operation depending on the host OS."
  `(cond ((eq system-type 'darwin) (progn ,darwin))
	((eq system-type 'windows-nt) (progn ,windows))
	((eq system-type 'gnu/linux) (progn ,linux))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; custom functions
(load (file-in-emacs-directory "functions.el"))

;; internal emacs changes
(add-to-list 'load-path (file-in-emacs-directory "modules"))

(setq custom-file (file-in-emacs-directory "custom.el")
      make-backup-files nil
      auto-save-default nil
      use-package-always-ensure t
      warning-suppress-log-types '((files missing-lexbind-cookie)))
(load custom-file)

(add-hook
 'org-mode-hook
 (lambda ()
   (setq org-latex-create-formula-image-program 'imagemagick)))

(when (eq system-type 'darwin)
  (add-directory-to-exec-path "/Library/TeX/texbin"))
(xterm-mouse-mode 1)

(use-package proced
  :ensure nil
  :config (setq proced-auto-update-interval 1)
  :hook ((proced-mode . proced-toggle-auto-update)))

(use-package company
  :init
  (setq company-files-exclusions '(".git/" ".DS_Store"))
  (global-company-mode))

(use-package git-gutter
  :init (global-git-gutter-mode))

;; (use-package telephone-line
;;   :commands (telephone-line-mode)
;;   :init ((setq telephone-line-lhs
;; 	       '((accent . (telephone-line-vc-segment
;; 			    telephone-line-erc-modified-channels-segment
;; 			    telephone-line-process-segment))))
;;   :config (telephone-line-mode 1))

;; dired git
(use-package dired
  :ensure nil
  :commands (dired-git-info-mode)
  :bind (:map dired-mode-map
	      (")" . dired-git-info-mode))
  :config
  (setq dgi-auto-hide-details-p nil)
  (when (eq system-type 'darwin)
    (setq dired-use-ls-dired t
	  insert-directory-program "/opt/homebrew/bin/gls")))

(use-package simpc-mode
  :ensure nil
  :load-path "modes/simpc-mode/"
  :mode "\\.[hc]\\(pp\\)?\\'")

(use-package company-quickhelp
  :init (company-quickhelp-mode 1))

(use-package ido
  :ensure nil
  :init
  (ido-mode 1)
  (setq ido-everywhere t)
  (setq ido-ignore-extensions t)
  (setq ido-ignore-files '(".DS_Store" ".git"))
  (dolist (extension '(".pyc" ".elc"))
    (add-to-list 'completion-ignored-extensions extension)))

(use-package smex
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)
	 ("C-c C-c M-x" . execute-extended-command)))

(dolist (hook '(c-mode-hook
		lua-mode-hook
		python-mode-hook
		java-mode-hook))
  (add-hook hook 'eglot-ensure))

(use-package maxima
  :mode ("\\.mac\\'" . maxima-mode)
  :interpreter ("maxima" . maxima-mode))

(use-package imaxima
  :ensure nil
  :if (locate-library "imaxima.el"))

(use-package intercal-mode
  :ensure nil
  :load-path "modes/intercal/"
  :mode "\\.i[0-9]*\\'")

(use-package my-present
  :ensure nil
  :load-path "modules/")

;; load theme settings
(load (concat user-emacs-directory "theme.el"))

