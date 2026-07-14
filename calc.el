;;; -*- lexical-binding: t; -*-

(require 'calc)
(require 'calc-ext)
(require 'calc-mtx)

(defmath eigenvalues (m)
  "Compute the eigenvalues of the matrix"
  (interactive 1 "eigen")
  (add-to-list 'var-Decls '(vec (var l var-l) (var scalar var-scalar)) t)
  (let ((dim (nth 1 (mdims m))))
    (calc-ident dim)
    (calc-eval "l" 'push)
    (calc-times 2)
    (calc-minus)
    (calc-mdet 1)
    
    (find-root "l")))
  
