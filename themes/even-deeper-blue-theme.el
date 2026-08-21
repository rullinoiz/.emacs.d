;;; -*- lexical-binding: t -*-

(deftheme even-deeper-blue "little bit deeper innit")

(load-theme 'deeper-blue t t)

(custom-theme-set-faces
 'even-deeper-blue
 '(default ((t (:background "#000000" :foreground "gray80" :family "JetBrains Mono" :height 130))))
 '(error ((t (:foreground "firebrick1"))))
 '(fixed-pitch ((t (:family "JetBrains Mono NL"))))
 '(variable-pitch ((t (:family "CMU Sans Serif"))))
 '(header-line ((t (:inherit mode-line :background "black" :foreground "gray90" :box (:line-width (80 . 5) :color "black" :style flat-button)))))
 '(line-number-current-line ((t (:inherit line-number :foreground "DeepSkyBlue1"))))
 '(mode-line ((t (:background "gray10" :foreground "gray100" :box nil :height 140))))
 '(mode-line-buffer-id ((t (:foreground "DeepSkyBlue1" :weight bold))))
 '(mode-line-highlight ((t (:box nil))))
 '(mode-line-inactive ((t (:background "black" :foreground "gray35" :box nil))))
 '(org-level-1 ((t (:height 1.5))))
 '(org-level-2 ((t (:height 1.35))))
 '(org-level-3 ((t (:height 1.25))))
 '(org-level-4 ((t (:height 1.15))))
 '(org-level-5 ((t (:height 1.1))))
 '(org-level-6 ((t (:height 1.1))))
 '(org-level-7 ((t (:height 1.1))))
 '(org-level-8 ((t (:height 1.1))))
 '(org-block-begin-line ((t (:inherit (shadow fixed-pitch)))))
 '(org-block-end-line ((t (:inherit (shadow fixed-pitch)))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(org-block ((t (:inherit fixed-pitch :background "gray10"))))
 '(shadow ((t (:foreground "gray40"))))
 '(cursor ((t (:background "gray80")))))

(enable-theme 'deeper-blue)
(enable-theme 'even-deeper-blue)

(provide-theme 'even-deeper-blue)
