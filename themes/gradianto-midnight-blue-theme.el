;;; -*- lexical-binding: t -*-

(deftheme gradianto-midnight-blue "jetbrains my beloved")

(load-theme 'org-common t t)

(custom-theme-set-faces
 'gradianto-midnight-blue
 
 '(default ((t (:background "#1a1a25" :foreground "#d8d8d8" :family "JetBrains Mono" :height 130))))
 '(fixed-pitch ((t (:family "JetBrains Mono NL"))))
 '(variable-pitch ((t (:family "CMU Sans Serif"))))

 '(highlight ((t (:background "#47387E" :foreground "#C2C2C2"))))
 '(region ((t (:background "#383983" :foreground "#d8d8d8"))))
 
 '(line-number ((t (:foreground "#B1B7BC")))) 
 '(line-number-current-line ((t (:inherit line-number :background "#27243d" :foreground "#DBE3E9"))))
 '(mode-line ((t (:background "#282839" :foreground "gray100" :height 140))))
 '(mode-line-inactive ((t (:box nil))))
 '(show-paren-match ((t (:background "#3B514D" :foreground "#FFEF28"))))

 '(tab-line ((t (:inherit default))))
 '(tab-line-inactive ((t (:box nil))))

 '(minibuffer-prompt ((t (:foreground "#00D66E"))))
 
 '(fringe ((t (:inherit default))))

 '(hl-line ((t (:background "#27243d" :extend t))))

 '(window-divider ((t (:foreground "#423A5F"))))
 '(vertical-border ((t (:foreground "#423A5F"))))
 
 '(font-lock-function-name-face ((t (:foreground "#ebbf8c"))))
 '(font-lock-number-face ((t (:foreground "#bbb55b"))))
 '(font-lock-comment-face ((t (:foreground "#5d69bb" :slant italic))))
 '(font-lock-keyword-face ((t (:foreground "#cc8b60"))))
 '(font-lock-constant-face ((t (:foreground "#616fc6"))))
 '(font-lock-string-face ((t (:foreground "#96bf7d"))))
 '(font-lock-builtin-face ((t (:foreground "#9876aa" :slant italic))))
 '(font-lock-variable-name-face ((t (:foreground "#838cca"))))
 '(font-lock-delimiter-face ((t (:inherit font-lock-keyword-face))))
 '(font-lock-bracket-face ((t (:inherit fixed-pitch))))
 '(font-lock-escape-face ((t (:foreground "#d7539b"))))
 '(font-lock-type-face ((t (:foreground "#757db3"))))
 '(font-lock-doc-face ((t (:style bold))))
 '(font-lock-warning-face ((t (:foreground "#bc3f3c"))))
 '(font-lock-preprocessor-face ((t (:foreground "#CBBC3A"))))

 '(eglot-highlight-symbol-face ((t (:background "#283551"))))

 '(eglot-semantic-number ((t (:inherit font-lock-number-face))))
 '(eglot-semantic-class ((t (:inherit font-lock-type-face))))
 '(eglot-semantic-modifier ((t (:inherit font-lock-keyword-face))))
 '(eglot-semantic-method ((t (:inherit font-lock-function-name-face))))
 '(eglot-semantic-namespace ((t (:inherit default))))

 '(eglot-semantic-declaration ((t)))
 '(eglot-semantic-static ((t)))

 '(company-tooltip ((t (:background "#282839" :foreground "gray100"))))
 '(company-tooltip-common ((t (:foreground "#CDCB46"))))
 '(company-tooltip-selection ((t (:background "#47387E"))))
 )

(custom-theme-set-variables
 'gradianto-midnight-blue

 '(company-icon-margin 3)
 
 '(company-box-icon-right-margin 2)
 '(company-box-icons-alist 'company-box-icons-intellij-dark)
 )

(enable-theme 'org-common)

(provide-theme 'gradianto-midnight-blue)
