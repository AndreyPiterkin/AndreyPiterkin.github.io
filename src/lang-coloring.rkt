#lang racket

(provide current-shared-colortable add-coloring!)

(require colors racket/class)

(define golden-ratio-conj 0.618033988749895)
(define sat 0.7)
(define val 0.8)
(define colors-file "colors.rktd")
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
    (thunk (write (cons (current-shared-colortable) prev-hue)))))
