;;; -*- lexical-binding: t -*-

;; (benchmark-init/activate)
;; (add-hook 'after-init-hook #'benchmark-init/deactivate)

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
  :defer t
  :hook ((org-mode . visual-line-mode)
         (org-mode . display-line-numbers-mode)
	 (org-mode . org-latex-preview))
  :init (setq org-list-allow-alphabetical t
	      org-highlight-latex-and-related '(latex script entities)
	      org-latex-preview-preamble "\\documentclass{article}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{xcolor}
\\usepackage{amssymb}"))

;;; Functions
(require 'functions)

;;; Keymap
(dolist (bind #'(("C-c o i" . open-init-file)
		 ("C-c C-o i" . open-init-file-other-window)
		 ("C-c o e" . open-early-init-file)
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
		 ("C-c o p" . use-package-configure)
		 ("C-x C-b" . electric-buffer-list)
		 ("<escape>" . keyboard-escape-quit)
		 ("M-RET" . toggle-frame-fullscreen)))
  (bind-key (car bind) (cdr bind)))

(with-eval-after-load 'lisp-mode
  (keymap-set lisp-mode-shared-map "C-c e k" '("Eval Region and Kill Result" . eval-region-and-kill)))

(with-eval-after-load 'prog-mode
  (keymap-set prog-mode-map "C-c C-c" '("Compile" . compile)))

(with-eval-after-load 'cc-mode
  (keymap-set c-mode-map "C-c C-c" '("Compile" . compile))
  (keymap-set c++-mode-map "C-c C-c" '("Compile" . compile)))

(with-eval-after-load 'c-ts-mode
  (keymap-set c-ts-base-mode-map "C-c C-c" '("Compile" . compile)))

(with-eval-after-load 'sh-script
  (keymap-set sh-mode-map "C-c C-r" '("Sudo-edit" . sudo-edit)))

;;; Theme
(setq-default cursor-type 'bar)

;;(add-hook
;; 'window-size-change-functions
;; #'(lambda (frame)

;;   (let ((fullscreen-state (frame-parameter frame 'fullscreen)))
;;     (cond ((memq fullscreen-state '(fullboth fullscreen))
;;	    (set-frame-parameter frame 'alpha-background 100))
;;	   (t (set-frame-parameter frame 'alpha-background (os-switch :darwin 60 :else 80)))))))

(defun display-line-numbers-mode-on () (display-line-numbers-mode 1))
(defun display-line-numbers-mode-off () (display-line-numbers-mode 0))

(add-hook 'prog-mode-hook #'display-line-numbers-mode-on)

(dolist (hook '(help-mode-hook
		dired-mode-hook
		compilation-mode-hook
		ghostel-mode-hook
		shell-mode-hook))
  (add-hook hook #'display-line-numbers-mode-off))

(use-package hl-line
  :ensure nil
  :init
  (global-hl-line-mode 1))

(use-package nerd-icons
  :config
  (add-to-list 'nerd-icons-mode-icon-alist
	       '(v-mode nerd-icons-sucicon "nf-custom-v_lang" :face nerd-icons-cyan))
  (add-to-list 'nerd-icons-extension-icon-alist
	       '("v" nerd-icons-sucicon "nf-custom-v_lang" :face nerd-icons-cyan)))

(use-package doom-modeline
  :preface
  (defun my/doom-modeline-icons (&optional frame)
    (let ((graphic (display-graphic-p frame)))
      (setq doom-modeline-major-mode-icon graphic
	    doom-modeline-vcs-icon graphic)))
  :init
  (setq doom-modeline-buffer-file-name-style 'file-name-with-project
	doom-modeline-height 20
	doom-modeline-minor-modes t
	doom-modeline-major-mode-icon t
	doom-modeline-major-mode-color-icon t
	nerd-icons-scale-factor 1.2)

  (add-hook 'after-init-hook #'my/doom-modeline-icons)
  (add-to-list 'after-make-frame-functions #'my/doom-modeline-icons)
  
  (doom-modeline-mode 1)
  :config
  (doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches buffer-info vcs remote-host parrot selection-info)
    '(objed-state misc-info persp-name grip irc mu4e gnus github repl lsp minor-modes process major-mode)))

(add-to-list
 'after-make-frame-functions
 (lambda (frame)
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
(use-package async
  :diminish dired-async-mode
  :init
  (async-bytecomp-package-mode 1)
  (dired-async-mode 1)
  :config
  (setq async-bytecomp-allowed-packages '(all)))

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
      mouse-autoselect-window t
      enable-recursive-minibuffers t)

(load custom-file 'noerror 'nomessage)

(when (eq system-type 'darwin)
  (add-hook
   'Info-mode-hook
   #'(lambda () (setq Info-additional-directory-list '("/opt/homebrew/share/info/emacs")))))

(dolist (extension '(".DS_Store"))
  (add-to-list 'completion-ignored-extensions extension))

(add-to-list 'auto-mode-alist '("\\.log" . auto-revert-mode))

;;; Package configuration
(use-package diminish)

(use-package proced
  :ensure nil
  :config (setq proced-auto-update-interval 1)
  :hook ((proced-mode . proced-toggle-auto-update)))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-frontends '(company-box-frontend)
	company-idle-delay 0
	company-files-exclusions '(".git/" ".DS_Store")))

;; (use-package company-quickhelp
;;   :after (company pos-tip)
;;   :config
;;   (setq company-quickhelp-delay 0.1)
;;   (company-quickhelp-mode 1))

(defun my/better-elisp-icon-provider (candidate)
  "Return an icon symbol for CANDIDATE if applicable."
  (when (derived-mode-p 'emacs-lisp-mode)
    (let ((sym (intern candidate)))
      (cond ((major-mode-p sym) 'Constructor)
	    ((minor-mode-p sym) 'Constructor)
	    ((string-match-p ":" candidate) 'Field)
	    ((fboundp sym) 'Function)
	    ((featurep sym) 'Module)
	    ((facep sym) 'Color)
	    ((string-match-p "-hook$" candidate) 'Event)
	    ((boundp sym) 'Variable)
	    (t 'Unknown)))))

(use-package company-box
  :preface
  (require 'intellij-icons)
  :diminish company-box-mode
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-doc-delay 0
	company-box-doc-no-wrap t
	company-box-icons-functions (remq 'company-box-icons--elisp company-box-icons-functions))
  (add-to-list 'company-box-icons-functions 'my/better-elisp-icon-provider))

;; (use-package org-transclusion
;;   :hook (prog-mode . org-transclusion))

(use-package git-gutter
  :diminish git-gutter-mode
  :init (global-git-gutter-mode))

;; dired git
(use-package dired-git-info
  :defer t
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
  :hook dired-mode
  :init
  (setq-default dired-omit-files-p t)
  (setq dired-omit-files "^\\.DS_Store\\|\\.tex$\\|\\.#"))

;; (use-package simpc-mode
;;   :vc (:url "https://github.com/rullinoiz/simpc-mode.git" :rev :newest)
;;   :init (major-mode-remap-add 'c-mode 'simpc-mode))

(use-package calc
  :ensure nil
  :config
  (require 'calc-rref))

(use-package eglot
  :defer t
  :hook ((c-ts-mode . eglot-ensure)
	 (c++-ts-mode . eglot-ensure)
	 (lua-mode . eglot-ensure)
	 (python-mode . eglot-ensure)
	 (java-ts-mode . eglot-ensure)
	 (kotlin-mode . eglot-ensure)
	 (v-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs '(kotlin-mode . ("kotlin-lsp" "--stdio")))
  ;; (add-to-list 'eglot-server-programs '(java-mode . ("kotlin-lsp" "--stdio")))
  (add-to-list 'eglot-server-programs '(v-mode . ("vls")))
  (setq eglot-connect-timeout 120
	eglot-report-progress nil))

(use-package c-ts-mode
  :ensure nil
  :defer t
  :custom
  (c-ts-indent-offset 4)
  :init
  (major-mode-remap-add 'c-mode 'c-ts-mode))

(use-package c++-ts-mode
  :ensure nil
  :defer t
  :init
  (major-mode-remap-add 'c++-mode 'c++-ts-mode))

(use-package java-ts-mode
  :ensure nil
  :defer t
  :init
  (major-mode-remap-add 'java-mode 'java-ts-mode))

(use-package casual)

(use-package cobol-mode
  :defer t
  :mode (("\\.cbl\\'" . cobol-mode)
	 ("\\.cob\\'" . cobol-mode)))

(use-package intercal-mode
  :ensure nil
  :defer t
  :load-path "modes/intercal/"
  :mode "\\.i[0-9]*\\'")

(use-package conf-mode
  :defer t
  :hook ((conf-mode . display-line-numbers-mode)))

(use-package nginx-mode
  :defer t)

(use-package systemd
  :defer t)

(use-package cmake-mode
  :defer t)

(use-package kotlin-mode
  :defer t)

(use-package lua-mode
  :defer t
  :config (setq lua-default-application (os-switch :darwin "/opt/homebrew/bin/lua")
		lua-indent-level 4))

(use-package php-ts-mode
  :ensure nil
  :defer t
  :init
  (major-mode-remap-add 'php-mode 'php-ts-mode))

(use-package v-mode
  :defer t
  :vc (:url "https://github.com/rullinoiz/v-mode.git" :rev :newest))

(use-package odin-mode
  :defer t
  :vc (:url "https://github.com/rullinoiz/odin-mode.git" :rev :newest))

(use-package javap-mode
  :defer t)

(use-package dape
  :defer t)

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

(use-package orderless
  :config
  (setq orderless-matching-styles '(orderless-flex))
  :custom
  (completion-styles '(basic flex))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package vertico
  :preface
  (defun vertico-describe-candidate ()
    "Describes the current minibuffer selection in the M-x menu."
    (interactive)
    (let ((selection (and (bound-and-true-p vertico--input)
			  (vertico--candidate))))
      (if (not selection)
	  (message "No candidate selected")
	(let ((symbol (intern selection)))
	  (cond
	   ;; M-x
	   ((fboundp symbol)
	    (describe-function symbol))
	   (t (message "Cannot describe: %s" selection)))))))
  :bind (:map vertico-map
	      ("C-h" . vertico-describe-candidate))
  :init
  (vertico-mode)
  (vertico-mouse-mode 1)
  (vertico-indexed-mode 1))

;; (use-package vertico-buffer
;;   :ensure nil
;;   :after vertico
;;   :config (setq vertico-buffer-display-action '(display-buffer-in-side-window
;; 						(side . nil)
;; 						(window-parameters (no-other-window . t)))))

(use-package marginalia
  :init (marginalia-mode)
  :config
  (setq ;;marginalia-align 'right
	marginalia-align-offset 0
	marginalia-max-relative-age 0))

(use-package treemacs
  :bind ("<f5>" . treemacs)
  :hook (treemacs-mode . treemacs-project-follow-mode))

;; (use-package vertico-posframe
;;   :after vertico
;;   :custom (vertico-posframe-parameters
;; 	   '((left-fringe . 8)
;; 	     (right-fringe . 8)))
;;   :init (vertico-posframe-mode 1))

(use-package multiple-cursors
  :init (multiple-cursors-mode))

(use-package ghostel
  :defer t
  :init
  (ghostel-compile-global-mode 1))

(use-package auctex
  :defer t)

(use-package org-latex-preview
  :ensure nil
  :hook org-mode
  :config
  (plist-put org-latex-preview-appearance-options
	     :page-width 0.8)

  (setq org-latex-preview-mode-display-live t
	org-latex-preview-mode-update-delay 0
	org-latex-preview-cache 'temp))

(use-package cdlatex
  :defer t
  :preface
  (defun my/cdlatex-insert-dollar-pair (&optional p)
    (interactive "P")
    (if p
	(insert-char ?$)
      (atomic-change-group
	(insert "\\(  \\)")
	(backward-char 3))))
  :bind* (:map org-mode-map
	       ("$" . my/cdlatex-insert-dollar-pair))
  :hook (org-mode . turn-on-org-cdlatex)
  :config
  (add-to-list 'cdlatex-env-alist
	       '("equation*"
		 "\\begin{equation*}
?
\\end{equation*}"
		 nil)))

(use-package smartparens
  :defer t
  :preface
  (defun my/smartparens-mode-setup ()
    (smartparens-mode)
    (dolist (pair '(("\\(" . "\\)")
		    ("\\[" . "\\]")))
      (sp-local-pair 'org-mode (car pair) (cdr pair) :actions '(insert))))
  :hook (org-mode . my/smartparens-mode-setup))

(use-package popper
  :bind (("C-`" . popper-toggle)
	 ("M-`" . popper-cycle)
	 ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
	'("\\*Messages\\*"
	  "Output\\*$"
	  "\\*Async Shell Command\\*"
	  help-mode
	  compilation-mode
	  Man-mode))
  (popper-mode +1)
  (popper-echo-mode +1))

(use-package gptel
  :defer t
  :hook (gptel-mode . display-line-numbers-mode-off)
  :custom
  (gptel-directives
   '((default . "You are a helpful assistant living in Emacs. Provide concise answers and explain everything. Rely on the documentation tools provided rather than your knowledge.")))
  :config
  (setq gptel-model 'gemma4:granite4.1:8b
	gptel-backend (gptel-make-ollama "Ollama (remote)"
			:host "10.0.0.31:11434"
			:stream t
			:models '("gemma4:26b-agent"
				  "gemma4:12b"
				  "granite4.1:8b"
				  "mathstral:7b"))
	gptel-default-mode 'org-mode
	gptel-stream t)
  
  (gptel-make-ollama "Ollama (local)"
    :stream t
    :models '("gemma4:12b-mlx"
	      "deepseek-r1:latest"
	      "granite4.1:8b"
	      "mathstral:7b"))

  (gptel-make-preset 'latex
    :system "You are an AI assistant inside of Emacs helping with mathematics written mainly inline LaTeX in Org mode. If given a single problem, simply provide the answer and nothing else unless the problem asks for it. If given multiple questions, number your answers for each problem answered, and simply provide the answers and nothing else unless the problems ask for it. Be aware of any surrounding or open LaTeX formatting. Do not repeat the prompt or question.

*Example prompt*: If \\(U=\\left\\{1,2,3,\\dots,10\\right\\}\\), \\(U \\cup \\left\\{11,12\\right\\} =

*Your response*: \\left\\{1,2,3,4,5,6,7,8,9,10,11,12\\right\\}\\)"
    :models '("gemma4:12b-mlx" "granite4.1:8b")))

(use-package ragmacs
  :vc (:url "https://github.com/positron-solutions/ragmacs.git")
  :after gptel)

(use-package crontab-mode
  :defer t)

(use-package with-editor
  :defer t)

