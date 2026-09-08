;;; functions.el --- my init.el functions -*- lexical-binding: t -*-

(eval-when-compile
  (require 'cl-lib))

(defun get-environment-variables ()
  "Get a list of all defined environment variables."
  (mapcar #'(lambda (str)
	      (string-match "\\([a-zA-Z0-9_]+\\)=." str)
	      (match-string 1 str))
	  process-environment))

(defun --prompt-env ()
  "Prompt the user for an environment variable."
  (completing-read "Environment variable: " (get-environment-variables) nil nil))

(defun prepend-env (variable value)
  "Prepend some VALUE to an environment VARIABLE."
  (interactive (list (--prompt-env)
		     (read-string "Value to prepend: ")))
  (let ((newenv (concat value ":" (getenv variable))))
    (setenv variable newenv)
    (when (called-interactively-p 'any)
      (message "%s" newenv))))

(defun append-env (variable value)
  "Append some VALUE to an environment VARIABLE."
  (interactive (list (--prompt-env)
		     (read-string "Value to append: ")))
  (let ((newenv (concat (getenv variable) ":" value)))
    (setenv variable newenv)
    (when (called-interactively-p 'any)
      (message "%s" newenv))))

(defun file-in-emacs-directory (relative-path)
  "Get the full path of a RELATIVE-PATH inside of the `user-emacs-directory'."
  (interactive (list (read-file-name "File: " user-emacs-directory nil nil nil)))

  (setq relative-path (expand-file-name relative-path user-emacs-directory))

  (when (called-interactively-p 'any)
    (message "%s" relative-path))
  
  relative-path)

(defun add-directory-to-exec-path (directory)
  "Add DIRECTORY to the PATH environment variable."
  (interactive "DDirectory: ")
  (add-to-list 'exec-path directory)
  (prepend-env "PATH" directory))

(cl-defmacro os-switch (&key darwin windows linux else)
  "Perform a different operation depending on the host OS."
  `(cond ((and ,darwin (eq system-type 'darwin)) (progn ,darwin))
	 ((and ,windows (eq system-type 'windows-nt)) (progn ,windows))
	 ((and ,linux (eq system-type 'gnu/linux)) (progn ,linux))
	 (t (progn ,else))))

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

(defun open-func-file ()
  "Open the functions file."
  (interactive)
  (find-library "functions"))

(defun open-func-file-other-window ()
  "Open the functions file in another window."
  (interactive)
  (find-library-other-window "functions"))

(defun my/goto-theme ()
  "Internal function to jump to the theme header in the init file."
  (interactive)
  (goto-char (min-point))
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
  (goto-char (min-point))
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
  "Open college directory with dired."
  (interactive)
  (dired "~/Documents/school/College"))

(defun crontab-e ()
  "Run `crontab -e` in an emacs buffer."
  (interactive)
  (with-editor-async-shell-command "crontab -e"))

(defun my/get-regexp-matches-in-file (r filepath &optional group-num)
  "Returns a list of matches in FILEPATH with regexp R."
  (setq group-num (or group-num 0))
  (with-temp-buffer
    (insert-file-contents filepath)
    (goto-char (point-min))
    (let (matches)
      (while (re-search-forward r nil t)
	(when (match-string group-num)
	  (push (match-string group-num) matches)))
      (nreverse matches))))

(defun use-package-configure (package)
  "Find the `use-package' definition for PACKAGE in `user-init-file'."
  (interactive (list
		(completing-read
		 "Package: " 
		 (my/get-regexp-matches-in-file "^ *[^;](use-package \\([^()\n]+\\))?" user-init-file 1)
		 nil t)))
  (open-init-file)
  (goto-char (point-min))
  (re-search-forward (concat "^ *[^;](use-package *\\(" package "\\)")))

(defun major-mode-remap-add (majormode newmode)
  "Adds a major mode remap to `major-mode-remap-alist'. Replaces the remap if it already exists."
  (setf (alist-get majormode major-mode-remap-alist) newmode)
  major-mode-remap-alist)

(defun minor-mode-enabled-p (mode)
  "Return non-nil if minor MODE is enabled."
  (member mode minor-mode-list))

(defun minor-mode-p (symbol)
  "Return non-nil if SYMBOL is a known minor mode."
  (and (symbolp symbol)
       (or (memq symbol minor-mode-list)
	   (get symbol 'minor-mode))))

(defun major-mode-p (symbol)
  "Return non-nil if SYMBOL is a known major mode."
  (and (symbolp symbol)
       (fboundp symbol)
       (or (get symbol 'derived-mode-parent)
	   (eq symbol 'fundamental-mode)
	   (let ((doc (documentation symbol)))
	     (and doc (string-match-p "major mode" doc))))))

(provide 'functions)
