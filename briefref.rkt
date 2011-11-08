#lang racket/base

(require racket/sequence
	 racket/dict)

(define (struct-ref structure ref)
  (ref structure))

(define type-reference-functions (make-parameter (list
						  (cons struct? struct-ref)
						  (cons dict? dict-ref)
						  (cons sequence? sequence-ref))))

(define (briefref obj ref)
  (if (null? (type-reference-functions))
      (error '@ "failed because type of ~s is not recognized" obj)
      (if ((caar (type-reference-functions)) obj)
	  ((cdar (type-reference-functions)) obj ref)
	  (parameterize ((type-reference-functions (cdr (type-reference-functions))))
	    (briefref obj ref)))))

(define (@* obj refs)
  (if (null? refs) obj
      (@* (briefref obj (car refs)) (cdr refs))))

(define (@ obj . refs)
  (@* obj refs))

(provide @ @* type-reference-functions briefref)
