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

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; custom functions
(load-file (concat user-emacs-directory "functions.el"))

;; internal emacs changes
(add-to-list 'load-path (concat user-emacs-directory "modules"))

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)
(setq make-backup-files nil)
(setq auto-save-default nil)

(add-hook
 'org-mode-hook
 (lambda ()
   (setq org-latex-create-formula-image-program 'imagemagick)))

(add-directory-to-exec-path "/Library/TeX/texbin")
(setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/zulu-23.jdk/Contents/Home")
(xterm-mouse-mode 1)

(use-package proced
  :ensure nil
  :config (setq proced-auto-update-interval 1)
  :hook ((proced-mode . proced-toggle-auto-update)))

(use-package company
  :ensure t
  :init (global-company-mode))

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
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired t
	  insert-directory-program "/opt/homebrew/bin/gls")))

(use-package simpc-mode
  :ensure nil
  :load-path "modes/simpc-mode/"
  :mode "\\.[hc]\\(pp\\)?\\'")

(use-package company-quickhelp
  :init (company-quickhelp-mode 1))

(use-package smex
  :init
  (ido-mode 1)
  (setq ido-everywhere t)
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)
	 ("C-c C-c M-x" . execute-extended-command)))

(use-package poke)


(dolist (hook '(c-mode
		 kotlin-mode
		 lua-mode))
  (add-hook hook 'eglot-ensure))

(use-package intercal-mode
  :ensure nil
  :load-path "modes/intercal/")

(use-package my-present)

;; load theme settings
(load-file (concat user-emacs-directory "theme.el"))

