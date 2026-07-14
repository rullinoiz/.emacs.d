;;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; must be above all org definitions
(use-package org-mode
  :ensure t
  :defer t
  :no-require t
  :vc (:url "https://code.tecosaur.net/tec/org-mode" :branch "dev"))

(use-package org
  :load-path "~/.emacs.d/elpa/org-mode/lisp/"
  :hook ((org-mode . visual-line-mode)
         (org-mode . display-line-numbers-mode))
  :init (setq org-list-allow-alphabetical t
	      org-highlight-latex-and-related '(latex script entities)
	      org-latex-preview-preamble "\\documentclass{article}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{xcolor}
\\usepackage{amssymb}"))

;;; Functions
(defun get-environment-variables ()
  "Get a list of all defined environment variables."
  (mapcar #'(lambda (str)
	      (string-match "\\([a-zA-Z0-9_]+\\)=." str)
	      (match-string 1 str)) process-environment))

(defun --prompt-env ()
  "Prompt the user for an environment variable."
  (completing-read "Environment variable: " (get-environment-variables) nil nil))

(defun prepend-env (variable value)
  "Prepend some value to an environment variable."
  (interactive (list (--prompt-env)
		     (read-string "Value to prepend: ")))
  (let ((newenv (concat value ":" (getenv variable))))
    (setenv variable newenv)
    (when (called-interactively-p 'any)
      (message "%s" newenv))))

(defun append-env (variable value)
  "Append some value to an environment variable."
  (interactive (list (--prompt-env)
		     (read-string "Value to append: ")))
  (let ((newenv (concat (getenv variable) ":" value)))
    (setenv variable newenv)
    (when (called-interactively-p 'any)
      (message "%s" newenv))))

(defun file-in-emacs-directory (relative-path)
  "Get the path of a file inside of the `user-emacs-directory'."
  (interactive (list (read-file-name "File: " user-emacs-directory nil nil nil)))

  (when (called-interactively-p 'any)
    (message "%s" relative-path))
  
  (expand-file-name relative-path user-emacs-directory))

(defun add-directory-to-exec-path (path)
  "Add a directory to the PATH environment variable."
  (interactive "DDirectory: ")
  (add-to-list 'exec-path path)
  (prepend-env "PATH" path))

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
  (interactive (eval (nth 1 (interactive-form #'file-in-emacs-directory))))
  (find-file file-path))

(defun open-college-directory ()
  "Opens college directory with dired."
  (interactive)
  (dired "~/Documents/school/College"))

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
		("C-c o s" . open-college-directory)
		("<escape>" . keyboard-escape-quit)
		("M-RET" . toggle-frame-fullscreen)))
  (global-set-key (kbd (car bind)) (cdr bind)))

(with-eval-after-load
 'lisp-mode
 (define-key lisp-mode-shared-map (kbd "C-c e k") #'eval-region-and-kill))

;;; Theme
(add-hook
 'window-size-change-functions
 #'(lambda (frame)
   (let ((fullscreen-state (frame-parameter frame 'fullscreen)))
     (cond ((memq fullscreen-state '(fullboth fullscreen))
	    (set-frame-parameter frame 'alpha-background 100))
	   (t (set-frame-parameter frame 'alpha-background (os-switch :darwin 60 :linux 80 :windows 80)))))))

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(defun display-line-numbers-mode-off () (display-line-numbers-mode 0))

(dolist (hook '(help-mode-hook
		dired-mode-hook
		compilation-mode-hook
		ghostel-mode-hook
		shell-mode-hook))
  (add-hook hook #'display-line-numbers-mode-off))

(defun --modeline-icons (&optional frame)
  (let ((graphic (display-graphic-p frame)))
    (setq doom-modeline-major-mode-icon graphic
	  doom-modeline-vcs-icon graphic)))

(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-buffer-file-name-style 'file-name-with-project
	doom-modeline-height 20
	doom-modeline-minor-modes t
	nerd-icons-scale-factor 1.2)

  (add-hook 'after-init-hook #'--modeline-icons)
  (add-to-list 'after-make-frame-functions #'--modeline-icons)
  
  (doom-modeline-mode 1))

(doom-modeline-def-modeline 'main
  '(bar workspace-name window-number modals matches buffer-info vcs remote-host parrot selection-info)
  '(objed-state misc-info persp-name grip irc mu4e gnus github repl lsp minor-modes process major-mode))

(add-to-list
 'after-make-frame-functions
 (lambda (frame)
   (--remove-background frame)
   (when (display-graphic-p frame)
     (scroll-bar-mode -1)
     (tool-bar-mode -1))))

(add-hook
 'after-init-hook
 (lambda ()
   (when (display-graphic-p (selected-frame))
     (scroll-bar-mode -1)
     (tool-bar-mode -1))))

;; internal emacs changes
(add-to-list 'load-path (file-in-emacs-directory "modules"))

(setq custom-file (file-in-emacs-directory "custom.el")
      make-backup-files nil
      auto-save-default nil
      use-package-always-ensure t
      warning-suppress-log-types '((files missing-lexbind-cookie))
      compilation-auto-jump-to-first-error t
      compilation-max-output-line-length nil
      compilation-scroll-output t
      load-prefer-newer t
      ring-bell-function 'ignore
      use-short-answers t
      mouse-autoselect-window t)
(load custom-file 'noerror 'nomessage)

(when (eq system-type 'darwin)
  (add-hook
   'Info-mode-hook
   #'(lambda () (setq Info-additional-directory-list "/opt/homebrew/share/info/emacs"))))

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
(use-package dired-git-info
  :bind (:map dired-mode-map
	      (")" . dired-git-info-mode))
  :config (setq dgi-auto-hide-details-p nil))

(use-package dired
  :ensure nil
  :config
  (when (eq system-type 'darwin)
    (setq dired-use-ls-dired t
	  insert-directory-program "/opt/homebrew/bin/gls")))

(use-package dired-omit
  :ensure nil
  :hook (dired-mode . dired-omit-mode)
  :init
  (setq-default dired-omit-files-p t)
  (setq dired-omit-files "^\\.DS_Store\\|\\.tex$"))

(use-package simpc-mode
  :ensure nil
  :load-path "modes/simpc-mode/"
  :mode "\\.[hc]\\(pp\\)?\\'")

(use-package company-quickhelp
  :init (company-quickhelp-mode 1))

(use-package calc
  :ensure nil
  :config
  (require 'calc-rref))

(dolist (hook '(c-mode-hook
		lua-mode-hook
		python-mode-hook
		java-mode-hook))
  (add-hook hook #'eglot-ensure))

(use-package casual)

(use-package cobol-mode
  :mode (("\\.cbl\\'" . cobol-mode)
	 ("\\.cob\\'" . cobol-mode)))

(use-package intercal-mode
  :ensure nil
  :load-path "modes/intercal/"
  :mode "\\.i[0-9]*\\'")

(use-package conf-mode)

(use-package nginx-mode)

(use-package systemd)

(use-package cmake-mode)

(use-package kotlin-mode)

(use-package lua-mode
  :defer t
  :config (setq lua-default-application (os-switch :darwin "/opt/homebrew/bin/lua")
		lua-indent-level 4))

(use-package php-mode)			 

(use-package transpose-frame
  :defer t
  :bind (("C-x 4 t" . transpose-frame)))

(use-package sudo-edit
  :bind (("C-c C-r" . sudo-edit)))

(use-package my-present
  :ensure nil
  :defer t
  :load-path "modules/")

(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package vertico
  :init (vertico-mode))

(use-package vertico-buffer
  :ensure nil
  :after vertico
  :config (setq vertico-buffer-display-action '(display-buffer-in-side-window
						(side . nil)
						(window-parameters (no-other-window . t)))))

(use-package vertico-posframe
  :after vertico
  :custom (vertico-posframe-parameters
	   '((left-fringe . 8)
	     (right-fringe . 8)))
  :init (vertico-posframe-mode 1))

(use-package vertico-mouse
  :ensure nil
  :init (vertico-mouse-mode 1))

(use-package multiple-cursors
  :init (multiple-cursors-mode))

(use-package ghostel
  :defer t)

(use-package auctex
  :defer t)

(use-package org-latex-preview
  :ensure nil
  :defer t
  :hook (org-mode . org-latex-preview-mode)
  :config
  (plist-put org-latex-preview-appearance-options
	     :page-width 0.8)

  (setq org-latex-preview-mode-display-live t
	org-latex-preview-mode-update-delay 0
	org-latex-preview-cache 'temp))

(use-package cdlatex
  :hook (org-mode . turn-on-org-cdlatex)
  :config
  (add-to-list 'cdlatex-env-alist
	       '("equation"
		 "\\begin{equation}\n?\n\\end{equation}"
		 nil)))
