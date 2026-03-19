;;; intercal-mode.el --- major mode for intercal  -*- lexical-binding: t; -*-

(defgroup intercal-mode nil
  "Major mode for INTERCAL."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :prefix 'intercal-
  :group 'languages)

(defface intercal-mode-label-face
  '((((class color) (background light))
     :foreground "yellow" :weight "bold"))
  "Face for labels in `intercal-mode'."
  :group 'intercal-mode)

(defcustom intercal-mode-hook nil
  "Hook run by `intercal-mode'."
  :type 'hook
  :group 'intercal-mode)

(defvar intercal-mode-map
  (let ((map (make-keymap)))
    map)
  "Keymap for INTERCAL major mode")

(defconst intercal-mode-statements-72
  '("ABSTAIN FROM" "REINSTATE"
    "IGNORE" "REMEMBER"
    "NEXT" "FORGET" "RESUME"
    "STASH" "RETRIEVE"
    "GIVE UP"
    "READ OUT" "WRITE IN" "<-"))

(defconst intercal-mode-gerunds-72
  '("ABSTAINING" "REINSTATING"
    "IGNORING" "REMEMBERING"
    "NEXTING" "FORGETTING" "RESUMING"
    "STASHING" "RETRIEVING"
    "GIVING UP"
    "READING OUT" "WRITING IN"
    "CALCULATING"))

(defconst intercal-mode-statements-c
  (append intercal-mode-statements-72
	  '("COME FROM" "TRY AGAIN")))

(defconst intercal-mode-gerunds-c
  (append intercal-mode-gerunds-72
	  '("COMING FROM" "TRYING AGAIN")))

(defconst intercal-mode-statements-c-regex
  (concat "\\<\\(" (regexp-opt intercal-mode-statements-c) "\\>\\)"))
(defconst intercal-mode-gerunds-c-regex
  (concat "\\<\\(" (regexp-opt intercal-mode-gerunds-c) "\\>\\)"))

;; (defvar intercal-font-lock-keywords
;;   `(("(\\([0-9]+\\))" (1 font-lock-variable-name-face))
;;     ("\\(DO\\|PLEASE\\)" (1 font-lock-keyword-face))
;;     (,intercal-mode-statements-c-regex (1 font-lock-function-name-face))
;;     (,intercal-mode-gerunds-c-regex (1 font-lock-builtin-face))
;;     ("\\(BY\\|SUB\\|[!\"$&'?~¢\\+]\\)" (1 font-lock-operator-face))
;;     ("\\([.,:;][0-9]+\\)" (1 font-lock-variable-name-face))
;;     ("\\(#[0-9]+\\)" (1 font-lock-constant-face))
;;     ("\\(^.*NOT.*\\)" (1 font-lock-comment-face t)))
;;   "Highlight rules for `intercal-mode'.")

(defvar intercal-mode-font-lock-keywords
  (let ((identifiers '("DO" "PLEASE" "MAYBE"))
	(qualifiers intercal-mode-statements-c)
	(operators '("BY" "SUB" "!" "\"" "$" "&" "'" "?" "~" "¢" "V" "\\+"))
	(gerunds intercal-mode-gerunds-c))
    `(("\\(^.*NOT.*\\)" . font-lock-comment-face)
      (,(regexp-opt identifiers 'symbols) . font-lock-keyword-face)
      (,(regexp-opt qualifiers 'symbols) . font-lock-function-name-face)
      (,(regexp-opt operators) . font-lock-type-face)
      (,(regexp-opt gerunds 'symbols) . font-lock-builtin-face)
      ("(\\([0-9]+\\))" . font-lock-variable-name-face)
      ("#[0-9]+" . font-lock-constant-face)
      ("%[0-9]+" . font-lock-constant-face)
      ("[.,:;][0-9]+" . font-lock-variable-name-face)))
  "Highlight rules for `intercal-mode'.")

(defun intercal-indent-line ()
  "Indent current line."
  (interactive))

;;;###autoload
(define-derived-mode intercal-mode prog-mode "INTERCAL"
  "Major mode for INTERCAL"
  (setq font-lock-defaults '(intercal-mode-font-lock-keywords))
  (setq font-lock-string-face nil)
  :custom 'intercal-mode)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.i[0-9]\\*\\'" . intercal-mode))

(provide 'intercal-mode)
