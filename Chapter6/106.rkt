;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |106|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 106

; Update the code so it works with VAnimal 

(require 2htdp/universe)
(require 2htdp/image)

; a VAnimal is either
; a VCat or
; a VCham
; cx is x coordinate of Vanimal
; ch is happiness level of Vanimal
(define-struct vcat [cx ch])
(define-struct vcham [cx ch])

;; Constants
(define SN-WIDTH 420)
(define SN-HEIGHT 320)
(define SN-MID-Y (/ SN-HEIGHT 2))
(define SN-MID-X (/ SN-WIDTH 2))
(define SN (empty-scene SN-WIDTH SN-HEIGHT))
;; Constants related to the cat
(define VANIMAL-DX (* 0.05 SN-WIDTH))
(define CAT (bitmap/file "../assets/ninja_a.png"))
(define CHAM (rotate 90 (bitmap/file "../assets/chameleon.png")))
(define CAT-ALT (bitmap/file "../assets/ninja_b.png"))
; The cat is anchored at the bottom of the screen
; this number is how much to shift the cat up by
(define CAT-SHIFT-Y (- SN-HEIGHT (/ (image-height CAT) 2)))
; the cordinate where the cat would appear off the screen
(define SN-EDGE (ceiling (+ SN-WIDTH (/ (image-width CAT) 2))))
;; Constants related to the bar
; The bar is anchored on the left side of the screen
; when we do place image we must shift the bar this amount
(define BAR-SHIFT-X (/ SN-WIDTH 2))
(define BAR-HEIGHT (/ SN-HEIGHT 4))
(define HDECREASE .33)
(define SMHAPPY 1/3)
(define LGHAPPY 1/5)
; max happiness amount is 100
(define BAR-SCALE (/ SN-WIDTH 100))



; Number -> Number
(define (calc-next-x current-x)
  (modulo (+ current-x VANIMAL-DX) SN-EDGE))


; VAnimal -> Image
;(define (render-cat cs)
;  (if (odd? (vcat-cx cs)) CAT-ALT CAT))


; VAnimal -> Image
;(define (place-cat-on-scene cs)
;  (place-image/align (render-cat cs)
;                                 (vcat-cx cs)
;                                 CAT-SHIFT-Y
;                                 "center"
;                                 "bottom"
;                                 SN))

; VAnimal -> Image
;(define (render-happy-bar cs)
;  (rectangle (calculate-happy-bar-width (vcat-ch cs)) BAR-HEIGHT "solid" "red"))

; Number -> Number
(define (calculate-happy-bar-width hs)
  (* hs (/ SN-WIDTH 100)))
(check-expect (calculate-happy-bar-width 100)
              (* 100 (/ SN-WIDTH 100)))

; Number -> Number
; hs is current happiness level
; purpose: decrease happiness unless its already zero
;(define (calc-next-happy hs)
;  (if (> hs 0) (- hs (* hs HDECREASE)) 0))
(define (increase-happy hs key)
  (cond
    [(key=? key "up")    (+ hs (* hs SMHAPPY))]
    [(key=? key "down")  (+ hs (* hs LGHAPPY))]))             

; VAnimal -> VAnimal
; Each clock tick update the x position of the animal
; The happiness level of the vanimal should decrease
;(define (clock-tick-handler va)
;  (cond [(vcat? va) (make-vcat (calc-next-x (vcat-cx va))
;                               (calc-next-happy (vcat-ch va)))]
;        [(vcham? va) ...]))

; Vanimal -> Image
;(define (render cs)
;  (place-image/align (render-happy-bar cs) 0 0 "left" "top" (place-cat-on-scene cs)))


;;Main
;(define (main cs0)
;  (big-bang cs0
;    [on-tick clock-tick-handler 1]
;    [to-draw render]))
;(main (make-vcat 0 100))