;;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; Functions
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

(defun eval-region-and-kill ()
  "Evaluate the region and kill the result."
  (interactive)
  (let ((result (eval-last-sexp nil)))
    (kill-new result)
    (message result)))

(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(defun open-init-file-other-window ()
  "Open the init file in another window."
  (interactive)
  (find-file-other-window user-init-file))

(defun open-early-init-file ()
  "Open the early-init file."
  (interactive)
  (find-file (file-in-emacs-directory "early-init.el")))

(defun open-early-init-file-other-window ()
  "Open the early-init file in another window."
  (interactive)
  (find-file-other-window (file-in-emacs-directory "early-init.el")))

(defun my/goto-functions ()
  "Internal function to jump to the function header in the init file."
  (interactive)
  (goto-line 1)
  (re-search-forward "^;;; Functions"))

(defun open-func-file ()
  "Open the functions file."
  (interactive)
  (open-init-file)
  (my/goto-functions))

(defun open-func-file-other-window ()
  "Open the functions file in another window."
  (interactive)
  (open-init-file-other-window)
  (my/goto-functions))

(defun my/goto-theme ()
  "Internal function to jump to the theme header in the init file."
  (interactive)
  (goto-line 1)
  (re-search-forward "^;;; Theme"))

(defun open-theme-file ()
  "Open the theme file."
  (interactive)
  (open-init-file)
  (my/goto-theme))

(defun open-theme-file-other-window ()
  "Open the theme file in another window."
  (interactive)
  (open-init-file-other-window)
  (my/goto-theme))

(defun my/goto-keymap ()
  "Internal function to jump to the keymap header in the init file."
  (interactive)
  (goto-line 1)
  (re-search-forward "^;;; Keymap"))

(defun open-keymap-file ()
  "Open the keymap file."
  (interactive)
  (open-init-file)
  (my/goto-keymap))

(defun open-keymap-file-other-window ()
  "Open the keympa file in another window."
  (interactive)
  (open-init-file-other-window)
  (my/goto-keymap))

(defun open-file-in-emacs-directory (file-path)
  "Open a file inside of the `user-emacs-directory'."
  (interactive (eval (nth 1 (interactive-form 'file-in-emacs-directory))))
  (find-file file-path))

;;; Keymap
(dolist (bind #'(("C-c o i" . open-init-file)
		("C-c C-o i" . open-init-file-other-window)
		("C-c o f" . open-func-file)
		("C-c C-o f" . open-func-file-other-window)
		("C-c o t" . open-theme-file)
		("C-c C-o t" . open-theme-file-other-window)
		("C-c o k" . open-keymap-file)
		("C-c C-o k" . open-keymap-file-other-window)
		("C-c o l" . find-library)
		("C-c C-o l" . find-library-other-window)
		("C-c o C-f" . open-file-in-emacs-directory)
		("<escape>" . keyboard-escape-quit)
		("M-RET" . toggle-frame-fullscreen)))
  (global-set-key (kbd (car bind)) (cdr bind)))

(with-eval-after-load
 #'lisp-mode
 (define-key lisp-mode-shared-map (kbd "C-c e k") #'eval-region-and-kill))

;;; Theme
(add-hook 'org-mode-hook 'visual-line-mode)

(add-hook
 'window-size-change-functions
 (lambda (frame)
   (let ((fullscreen-state (frame-parameter frame 'fullscreen)))
     (cond ((memq fullscreen-state '(fullboth fullscreen))
	    (set-frame-parameter frame 'alpha-background 100))
	   (t
	    (set-frame-parameter frame 'alpha-background 60))))))

(add-hook
 'prog-mode-hook
 'display-line-numbers-mode)

(when (display-graphic-p)
  (tool-bar-mode -1))

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

;;; Package configuration
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

