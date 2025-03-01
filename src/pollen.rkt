#lang racket/base
(require txexpr
         racket/match
         racket/list
         racket/function
         racket/string
         pollen/core
         pollen/tag
         (for-syntax syntax/parse
                     racket/base
                     racket/list
                     racket/string
                     racket/function))

(provide (all-defined-out))

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
      [(_ size x:number)
       #'(empty-vspace #:size x)])))

(begin-for-syntax
  (define-syntax-class row-or-col
    #:description "either 'rows' or 'cols'"
    (pattern (~literal rows))
    (pattern (~literal cols))))

(define-syntax flex
  (lambda (stx)
    (syntax-parse stx
      #:datum-literals (? gap align class)
      [(_ dir:row-or-col (~optional (gap n:number) #:defaults ([n #'"4"])) 
                         (~optional (align alignment:string) #:defaults ([alignment #'"stretch"]))
                         (~optional (class c:string) #:defaults ([c #'""]))
                         (~seq item (~seq "\n" ...)) ...)
       #'(dir #:gap n #:align alignment #:class c item ...)]
      [(_ (? dir-c:string) (~optional (gap n:number) #:defaults ([n #'"4"])) 
                           (~optional (align alignment:string) #:defaults ([alignment #'"stretch"]))
                           (~optional (class c:string) #:defaults ([c #'""]))
                           (~seq item (~seq "\n" ...)) ...)
       ;; TODO: this is a hack, where in the styles css you have to !important the overriding class
       ;; for directions
       #'(rows #:gap n #:align alignment #:class (string-append dir-c " " c) item ...)])))

(define-syntax (link stx)
  (syntax-parse stx
    #:datum-literals (url target)
    [(_ (url u) (~optional (target t:string) #:defaults ([t #'"_blank"])) text)
      #'(link-expand #:url u #:target t text)]))

(define-syntax (nav stx)
  (syntax-parse stx
    #:datum-literals (class-if url target proto)
    [(_ (~optional (proto x)) 
        (url u) 
        (~optional (target t:string) #:defaults ([t #'"_blank"]))
        (~optional (class c:string) #:defaults ([c #'""])) 
        text)
     (if (attribute x)
         #'#\0
         #`(nav-expand #:url u #:target t #:class (if (string-contains? (last (string-split (select-from-metas 'here-path (current-metas)) "/"))
                                                                      #,(last (string-split (syntax->datum #'u) "/"))) (list c "active") (list c)) text))]))

(module setup racket/base
  (provide (all-defined-out))
  (define command-char #\~))

(define (link-expand #:url url #:target [target "_blank"] text)
  (txexpr 'a `((href ,url) (target ,target)) `(,text)))

(define (nav-expand #:url url #:target [target "_blank"] #:class [c '()] text)
  (txexpr 'a `((href ,url) (target ,target) (class ,(string-append "nav-item " (string-join c)))) `(,text)))


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

(define (headline t)
  `(a ((class "headline") (href "/") (style "text-decoration: none; color: black;")) (h2 ,t)))


(struct work-exp (company-name start-date end-date loc title languages technologies bullets blog-refs))
(define-syntax (experience stx)
  (syntax-parse stx
    #:datum-literals (dates)
    [(_ name:id (dates d1 d2) (b1 ...))
     #`(rt:experience (work-exp #,(syntax->datum #'name) d1 d2 #f #f #f #f #f b1 ...))])
  )

(define (rt:experience work-exp-info)
  `(p ((class "experience-block")) ,@(work-exp-bullets work-exp-info)))

(define (languages->html langs)
  (map (default-tag-function 'p) langs))

(define (technologies->html techs)
  (map (default-tag-function 'em) techs))
