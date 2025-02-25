#lang racket/base
(require pollen/tag
         txexpr
         pollen/decode
         racket/match
         racket/list
         racket/function

         (for-syntax syntax/parse
                     racket/base
                     racket/list
                     racket/function))

(provide (all-defined-out))

(define headline (default-tag-function 'h2 #:class "headline"))
(define lang (default-tag-function 'em #:style "font-style: normal;
                                   font-weight: 500;"))
(define list-items (default-tag-function 'ul #:class "dash"))
(define list-item (default-tag-function 'li))

(define-syntax items
  (lambda (stx)
    (syntax-parse stx
      [(_ (~or* (item ...) (~datum "\n")) ...)
       (define/syntax-parse ((filtered ...) ...)
          (filter identity (attribute item)))
       #'(list-items (apply list-item (list filtered ...)) ...)])))

(define-syntax vempty 
  (lambda (stx)
    (syntax-parse stx
      [(_ x:string)
       #'(empty-vspace #:size x)])))

(module setup racket/base
  (provide (all-defined-out))
  (define command-char #\~))

(define (link #:url url #:target [target "_blank"] text)
  (txexpr 'a `((href ,url) (target ,target)) `(,text)))


(define (rows #:gap [gap 4] #:align [alignment "stretch"] #:class [class ""] . els)
  (define txexprs (filter txexpr? els))
  (define style (format "display: flex; flex-direction: column;
                        row-gap: ~aem; align-self: ~a;" gap alignment))
                        (txexpr 'div `((class ,class) (style ,style)) (map flex-item
                                                                           txexprs)))

(define (cols #:gap [gap 4] #:align [alignment "stretch"] #:class [class
                                                                    ""] . els)
  (define txexprs (filter txexpr? els))
  (define style (format "display: flex; flex-direction: row;
                        column-gap: ~aem; align-self: ~a;" gap
                        alignment))
  (txexpr 'div `((class ,class) (style ,style)) (map flex-item
                                                     txexprs)))

(define (empty-vspace #:size [size 4])
  (define style (empty-space size 0 0 0))
  (txexpr 'div style))

(define (empty-space t b l r)
  (define style (format "padding: ~aem ~aem ~aem ~aem;" t r b l))
  `((style ,style)))

(define (flex-item item)
  item)
