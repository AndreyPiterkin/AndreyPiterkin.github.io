#lang racket/base
(require pollen/tag
         txexpr
         pollen/decode
         racket/match
         racket/list
         racket/function)

(provide (all-defined-out))
(define headline (default-tag-function 'h2 #:class "headline"))
(define lang (default-tag-function 'em #:style "font-style: normal;
                                   font-weight: 500;"))
(define items (default-tag-function 'ul #:class "dash"))

(struct transformer (pred? transform) #:transparent)

;; Basically a scuffed, unsanitary macro expander
;; TODO: figure out how to ensure expansion is uniform, if there is some built in expansion for this
;; (convert to Racket and macro expand?)
(define (transform x . transformers)
  (define (apply-transformers x)
    (for/fold ([xpr x])
              ([transformer transformers])
        (if ((transformer-pred? transformer) x)
            ((transformer-transform transformer) x)
            x)))
  (match x
    [(list) '()]
    [(list xs ...)
     (map (lambda (x) (apply transform x transformers)) (apply-transformers x))]
    [x (apply-transformers x)]))

(define items-transformer
  (transformer
    (lambda (x)
      (match x
        [(list 'ul (list (list y ...) ...) z ...)
         #t]
        [_ #f]))
    (lambda (x)
      (match x
        [(list 'ul (list (list y ...) ...) sublists ...)
         (define (split-list l)
           (let loop ([groups '()]
                      [lst l])
             (define split-func (negate (curry equal? "\n")))
             (define prefix (takef lst split-func))
             (define suffix (dropf lst split-func))
             (if (null? prefix)
                 (reverse groups)
                 (loop (cons prefix groups) (if (null? suffix) suffix (rest suffix))))))
         `(ul ,y ,@(map (lambda (s) (cons 'li s)) (split-list sublists)))]
        [_ (error 'expansion-failure "unexpected pattern: ~v" x)]))))

(define (root . elements)
  (txexpr 'root empty (decode-elements (transform elements items-transformer))))

(module setup racket/base
  (provide (all-defined-out))
  (define command-char #\~))

(define (link #:url url #:target [target "_blank"] text)
  (txexpr 'a `((href ,url) (target ,target)) `(,text)))

(define (rows #:gap [gap 4] #:align [alignment "stretch"] #:class [class
                                                                    ""] . els)
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
