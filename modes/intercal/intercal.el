;;; intercal-mode.el --- major mode for intercal  -*- lexical-binding: t; -*-

(defvar intercal-mode-hook nil)

(defvar intercal-mode-map
  (let ((map (make-keymap))))
  "Keymap for INTERCAL major mode")

(defconst intercal-font-lock-keywords
  (list
   ("\\(^.*NOT$\\)" . font-lock-comment-face)
   ;; (concat "\\<" (regexp-opt '("DO" "PLEASE") t) "\\>")
   ("\\<\\(DO\\|PLEASE\\)\\>" . font-lock-keyword-face)
   ;; (concat "\\<" (regexp-opt '("<-" "ABSTAIN FROM" "REINSTATE" "STASH" "RETRIEVE" "NEXT" "RESUME" "FORGET" "REMEMBER" "TRY AGAIN" "GIVE UP") t) "\\>")
   ("\\<\\(<-\\|ABSTAIN FROM\\|FORGET\\|GIVE UP\\|NEXT\\|RE\\(?:INSTATE\\|MEMBER\\|\\(?:SUM\\|TRIEV\\)E\\)\\|STASH\\|TRY AGAIN\\)\\>" . font-lock-function-name-face)
   ;; (regexp-opt '("BY" "SUB" "$" "¢" "?" "&" "~" "'" "\"" "!" "+") t)
   ("\\(BY\\|SUB\\|[!\"$&'?~¢\\+]\\)" . font-lock-operator-face)
   ("#\\([0-9]+\\)" . font-lock-constant-face)
   ("\\([\\.,:;][0-9]+\\)" . font-lock-variable-face)
   ))

(defconst intercal--font-lock-defaults
  (let ((keywords '(""))))
