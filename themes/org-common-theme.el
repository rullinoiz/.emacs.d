;;; -*- lexical-binding: t -*-

(deftheme org-common "Common theme options for org-mode")

(custom-theme-set-faces
 'org-common
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
 '(org-block ((t (:inherit fixed-pitch :background "gray10")))))

(provide-theme 'org-common)
