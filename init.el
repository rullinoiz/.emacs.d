;;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; custom functions
(load-file (concat user-emacs-directory "functions.el"))

;; internal emacs changes
(xterm-mouse-mode 1)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; lsp support
(use-package lsp-mode
  :ensure t
  :hook (
	 (lua-mode . lsp-mode)
	 (python-mode . lsp-mode)
	 (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-enable-semantic-highlighting t)
  (add-to-list 'lsp-file-watch-ignored-directories abbreviated-home-dir)
  :commands lsp)

(defun kotlin-lsp-server-start-fun (port)
  (list "kotlin-lsp.sh" "--socket" (number-to-string port)))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
	       '(kotlin-mode . "kotlin"))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-tcp-connection 'kotlin-lsp-server-start-fun)
    :activation-fn (lsp-activate-on "kotlin")
    :major-modes '(kotlin-mode)
    :priority -1
    :server-id 'kotlin-jb-lsp)))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package which-key :config (which-key-mode))
(use-package company-quickhelp
  :ensure t
  :config (company-quickhelp-mode 1))

(use-package treesit
  :ensure nil
  :config
  (setq treesit-language-source-alist
        '(
	  (bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c          . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cmake      . ("https://github.com/uyha/tree-sitter-cmake"))
          (cpp        . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css        . ("https://github.com/tree-sitter/tree-sitter-css"))
          (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
          (dot        . ("https://github.com/rydesun/tree-sitter-dot"))
          (doxygen    . ("https://github.com/tree-sitter-grammars/tree-sitter-doxygen"))
          (elisp      . ("https://github.com/Wilfred/tree-sitter-elisp"))
          (gitcommit  . ("https://github.com/gbprod/tree-sitter-gitcommit"))
          (go         . ("https://github.com/tree-sitter/tree-sitter-go"))
          (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod"))
          (gosum      . ("https://github.com/amaanq/tree-sitter-go-sum"))
          (gowork     . ("https://github.com/omertuc/tree-sitter-go-work"))
          (html       . ("https://github.com/tree-sitter/tree-sitter-html"))
          (http       . ("https://github.com/rest-nvim/tree-sitter-http"))
          (java       . ("https://github.com/tree-sitter/tree-sitter-java"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.1" "src"))
          (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
          (lua        . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))
          (make       . ("https://github.com/tree-sitter-grammars/tree-sitter-make"))
          (markdown   . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown"))
          (proto      . ("https://github.com/treywood/tree-sitter-proto"))
          (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
          (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql        . ("https://github.com/derekstride/tree-sitter-sql"))
          (toml       . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
          (vue        . ("https://github.com/tree-sitter-grammars/tree-sitter-vue"))
          (yaml       . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))
	  )
	)
  )

;; load theme settings
(load-file (concat user-emacs-directory "theme.el"))

;; set environment variables
(setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/zulu-23.jdk/Contents/Home")

;; move custom file
(setq custom-file (concat user-emacs-directory "custom.el"))
(load-file custom-file)
