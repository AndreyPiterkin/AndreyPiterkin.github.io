#lang racket/base
(require pollen/tag)
(require txexpr)

(provide (all-defined-out))
(define headline (default-tag-function 'h2 #:style
                                       "white-space:nowrap;"))
(define items (default-tag-function 'ul #:class "dash"))
(define item (default-tag-function 'li))
(define lang (default-tag-function 'em #:style "font-style: normal;
                                   font-weight: 500;"))

(define (rows #:gap [gap 4] #:align [alignment "stretch"] . els)
    (define txexprs (filter txexpr? els))
    (define style (format "display: flex; flex-direction: column;
                          row-gap: ~aem; align-self: ~a;" gap alignment))
    (txexpr 'div `((style ,style)) (map flex-item
                          txexprs)))

(define (cols #:gap [gap 4] #:align [alignment "stretch"] . els)
    (define txexprs (filter txexpr? els))
    (define style (format "display: flex; flex-direction: row;
                          column-gap: ~aem; align-self: ~a;" gap
                          alignment))
    (txexpr 'div `((style ,style)) (map flex-item
                          txexprs)))

(define (empty-vspace #:size [size 4])
    (define style (empty-space size 0 0 0))
    (txexpr 'div style))

(define (empty-space t b l r)
    (define style (format "padding: ~aem ~aem ~aem ~aem;" t r b l))
    `((style ,style)))

(define (flex-item item)
    item)

