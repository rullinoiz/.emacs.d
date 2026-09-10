;;; intellij-icons.el --- intellij icons for company-box -*- lexical-binding: t -*-

;; Copyright (C) 2026 rullinoiz

;; Author: rullinoiz
;; URL: https://github.com/rullinoiz/.emacs.d/blob/master/icons/intellij-icons.el

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Code:

(require 'dash)

(eval-when-compile
  (require 'find-func)
  (require 'subr-x)
  (require 'company-box)
  (defconst intellij-icons-dir
    (->> (find-library-name "intellij-icons")
	 (file-name-directory)
	 (expand-file-name "images")
	 (file-name-as-directory)))
  (defconst intellij-icons--have-imagemagick (image-type-available-p 'imagemagick)
    "Emacs might not be compiled with imagemagick.")
  (defun intellij-icons-image (file)
    (let* ((extension (intern (upcase (or (file-name-extension file) ""))))
           (use-magick (and intellij-icons--have-imagemagick
                            (not (member extension imagemagick-types-inhibit))
                            (member extension imagemagick-enabled-types))))
      `(image :type ,(if use-magick 'imagemagick 'svg)
              :file ,(concat intellij-icons-dir file)
              :ascent center))))

(defvar company-box-icons-intellij-dark
  (eval-when-compile
    `((Unknown . ,(intellij-icons-image "unknown_dark.svg"))
      (Text . ,(intellij-icons-image "string_dark.svg"))
      (Method . ,(intellij-icons-image "method_dark.svg"))
      (Function . ,(intellij-icons-image "function_dark.svg"))
      (Constructor . ,(intellij-icons-image "constructor_dark.svg"))
      (Field . ,(intellij-icons-image "field_dark.svg"))
      (Variable . ,(intellij-icons-image "variable_dark.svg"))
      (Class . ,(intellij-icons-image "class_dark.svg"))
      (Interface . ,(intellij-icons-image "interface_dark.svg"))
      (Module . ,(intellij-icons-image "module_dark.svg"))
      (Property . ,(intellij-icons-image "property_dark.svg"))
      (Enum . ,(intellij-icons-image "enum_dark.svg"))
      (File . ,(intellij-icons-image "anyType_dark.svg"))
      (Folder . ,(intellij-icons-image "folder_dark.svg"))
      (EnumMember . ,(intellij-icons-image "enum_dark.svg"))
      (Constant . ,(intellij-icons-image "constant_dark.svg"))
      (Struct . ,(intellij-icons-image "struct_dark.svg"))
      (Event . ,(intellij-icons-image "event_dark.svg"))
      (Operator . ,(intellij-icons-image "operator_dark.svg")))))

(provide 'intellij-icons)
;;; intellij-icons.el ends here
