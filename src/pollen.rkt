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
                     racket/function
                     racket/draw
                     racket/class
                     racket/path
                     colors))

(provide (all-defined-out))

(define list-items (default-tag-function 'ul #:class "dash"))
(define list-item (default-tag-function 'li))
(define par (default-tag-function 'p))

(define (identifier-exists? id)
  (with-handlers ([exn:fail? (lambda (_) #f)])
    (namespace-variable-value id )))

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
  (define BLOG-DIR (string->path "blog/"))
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

;; Experience macro and runtime

(struct work-exp (company-name start-date end-date loc title languages technologies bullets blog-refs))
(begin-for-syntax
  (define-splicing-syntax-class bullet
    #:description "experience bullet point of shape (b ...)"
    #:attributes ((b 1))
    (pattern (~seq (b ...) (~seq "\n" ...))))

  (define-splicing-syntax-class lang-bullet
    #:description "experience bullet point of shape (b ...)"
    #:attributes ((l 1))
    #:datum-literals (plang)
    (pattern (~seq ((~or (plang l:string) b) ...) (~seq "\n" ...))
             #:do [(for-each (lambda (lang) (add-coloring! lang)) (attribute l))])))

(define-syntax (plang stx)
  (syntax-parse stx
    [(_ l:string)
     (add-coloring! #'l)
     #`(let ([maybe-var (identifier-exists? 'langs)])
        (begin 
         (if maybe-var
           (set-box! maybe-var (cons (list l '#,(hash-ref (current-shared-colortable) (syntax->datum #'l) #'l)) (unbox maybe-var)))
           (void))
         (lang l '#,(hash-ref (current-shared-colortable) (syntax->datum #'l) #'l))))]))

(define-syntax (experience stx)
  (syntax-parse stx
    #:datum-literals (dates title loc)
    [(_ name:id (dates d1 d2) (title t) (~optional (loc l:string) #:defaults ([l #'#f])) (~and b:bullet bl:lang-bullet) ...)
     (define/syntax-parse langs
                          (map (lambda (s) (list (syntax->datum s) (hash-ref (current-shared-colortable) (syntax->datum s)))) (flatten (attribute bl.l))))
     #`(rt:experience (work-exp #,(symbol->string (syntax->datum #'name)) d1 d2 l t 'langs #f (list (list b.b ...) ...) #f))]))

(define (rt:experience work-exp-info)
  `(div ((class "experience-block"))
    (div ((class "experience-head")) 
         (div ((class "experience-title-name"))
           (p ((class "experience-name")) ,(work-exp-company-name work-exp-info))
           (p ((class "experience-title")) ,(work-exp-title work-exp-info))
           (div ((class "experience-langs")) ,@(languages->html (work-exp-languages work-exp-info))))
         (p ((class "experience-date-range")) (em ,(work-exp-start-date work-exp-info) " \u2014 " ,(work-exp-end-date work-exp-info))))
    (div ((class "experience-meta")))
    (div ((class "experience-bullets")) ,@(map (lambda (words) `(div ((class "bullet-text")) ,@words)) (work-exp-bullets work-exp-info)))))

(define (languages->html langs)
  (define (language->html lang)
    (define name (first lang))
    (define color (second lang))
    (define color-style (apply (curry format "background-color: rgba(~a, ~a, ~a, ~a)") color))
    (define name-color-style (apply (curry format "color: rgba(~a, ~a, ~a, ~a)") color))
    `(div ((class "lang"))
          (span ((class "lang-dot") (style ,color-style)))
          (p ((class "lang-name") (style ,name-color-style)) ,name)))
  (map language->html (remove-duplicates langs)))

(define (technologies->html techs)
  (map (default-tag-function 'em) techs))

(define (lang name color)
  (define name-color-style (apply (curry format "color: rgba(~a, ~a, ~a, ~a)") color))
  `(p ((class "lang-name") (style ,name-color-style)) ,name))

;; Blog
(define (rt:blog-desc title langs date)
  `(div ((class "blog-post-header"))
      (div ((class "blog-post-left"))
        ,(link (url (title->blog-url title)) (target "") `(p ((class "blog-post-title")) ,title))
        (div ((class "blog-post-lang-wrapper"))
          (div ((class "blog-post-languages")) ,@(languages->html langs))))
      (p ((class "blog-post-date")) ,date)))

(define (title->blog-url title)
  (string-append "blog/" (remove-non-alphanumeric-dash (string-replace title " " "-" #:all? #t)) ".html"))

(define (remove-non-alphanumeric-dash str)
  (regexp-replace* #rx"[^a-zA-Z0-9-]" str ""))
  
(begin-for-syntax
  (define (get-blog-posts)
     (define curr-path (current-directory))
     (define blog-path (build-path curr-path BLOG-DIR))
     (define blog-posts (directory-list blog-path #:build? #t))
     (filter (curryr path-has-extension? ".pm") blog-posts))

  (define (extract-titles blog-posts)
    (define w/o-ext (map (compose (curryr path-replace-extension "") file-name-from-path) blog-posts))
    ;; inefficient but I'm lazy
    (if (ormap path-get-extension w/o-ext)
        (extract-titles w/o-ext)
        (map path->string w/o-ext)))

  (define (extract-langs blog-posts)
    (define blog-modules (map make-resolved-module-path blog-posts))
    (define langs (map (curryr dynamic-require 'langs) blog-modules))
    (map unbox langs))

  (define (extract-dates blog-posts)
    (define blog-modules (map make-resolved-module-path blog-posts))
    (map (curryr dynamic-require 'date) blog-modules)))


(define-syntax (fill-in-blog stx)
  (syntax-parse stx
    #:datum-literals (plangs)
    [(_)
     (define blog-posts (get-blog-posts))
     (with-syntax ([(title ...) (extract-titles blog-posts)]
                  [(langs ...) (extract-langs blog-posts)]
                  [(date ...) (extract-dates blog-posts)])
       #'(flex rows (gap 1) (rt:blog-desc 'title 'langs 'date) ...))]))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; color utilities

(begin-for-syntax

  (define golden-ratio-conj 0.618033988749895)
  (define sat 0.7)
  (define val 0.8)
  (define colors-file (build-path (current-directory) (string->path "colors.rktd")))
  (define prev-hue 0.7)

  (define (gen-color start-hue) 
      (define hue start-hue)
      (thunk
        (set! hue (+ hue golden-ratio-conj))
        (set! hue (- hue (floor hue)))
        (set! prev-hue hue)
        (define color (hsv->color (hsv hue sat val)))
        (list (send color red) (send color green) (send color blue) (send color alpha))))
  (define color-generator (gen-color 0.5))

  (define lang-coloring-table 
    (if (file-exists? colors-file)
        (let* ([p (with-input-from-file colors-file (thunk (read)))]
               [next-color (cdr p)]
               [h (car p)])
          (set! color-generator (gen-color next-color))
          (make-hash (hash->list h)))
        (make-hash)))

  (define current-shared-colortable (make-parameter lang-coloring-table))

  (define (add-coloring! lang)
    (define lang^ (syntax->datum lang))
    (if (hash-has-key? (current-shared-colortable) lang^)
        (void)
        (hash-set! (current-shared-colortable) lang^ (color-generator)))

    (with-output-to-file colors-file
      #:exists 'replace
      (thunk (write (cons (current-shared-colortable) prev-hue))))))

(module setup racket/base
  (provide (all-defined-out))
  (define command-char #\~))
