#! /usr/bin/env racket
#lang racket/base

(require racket/mpair)

(require rackunit
	 "briefref.rkt")

(define test-data-struct (make-parameter (list 10 11 12 13
					       #(140 141)
					       "five"
					       #"six"
					       (mlist 170 171)
					       (hash 'a 180 'b 181 'c 182))))

(check-equal? (@ 4) 4 "Trivial case")
(check-equal? (@ (test-data-struct) 0) 10 "One level of referencing")
(check-equal? (@ (test-data-struct) 4 1) 141 "Two levels of referencing")
(check-equal? (@ (test-data-struct) 5 1) #\i "Looking into string")
(check-equal? (@ (test-data-struct) 6 2) (char->integer #\x) "Byte string")
(check-equal? (@ (test-data-struct) 7 0) 170 "Mutable list")
(check-equal? (@ (test-data-struct) 8 'b) 181 "Hash table")

(struct color (r g b (a #:auto))
	#:auto-value 255
	#:transparent)

(check-equal? (@ (color 150 0 127) color-r) 150 "Structure reference")
