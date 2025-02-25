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
      [(_ (~seq (item ...) (~seq "\n" ...)) ...)
       #'(list-items (list-item item ...) ...)])))

(define-syntax vempty 
  (lambda (stx)
    (syntax-parse stx
      #:datum-literals (size)
      [(_ size x:nat)
       #'(empty-vspace #:size x)])))

(begin-for-syntax
  (define-syntax-class row-or-col
    #:description "either 'rows' or 'cols'"
    (pattern (~literal rows))
    (pattern (~literal cols))))

(define-syntax flex
  (lambda (stx)
    (syntax-parse stx
      #:datum-literals (gap align class)
      [(_ dir:row-or-col (~optional (gap n:nat) #:defaults ([n #'"4"])) 
                         (~optional (align alignment:string) #:defaults ([alignment #'"stretch"]))
                         (~optional (class c:string) #:defaults ([c #'""]))
                         (~seq item (~seq "\n" ...)) ...)
       #'(dir #:gap n #:align alignment #:class c item ...)])))

(define-syntax (link stx)
  (syntax-parse stx
    #:datum-literals (url target)
    [(_ (url u) (~optional (target t:string) #:defaults ([t #'"target"])) text:string)
      #'(link-expand #:url u #:target t text)]))

(module setup racket/base
  (provide (all-defined-out))
  (define command-char #\~))

(define (link-expand #:url url #:target [target "_blank"] text)
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
