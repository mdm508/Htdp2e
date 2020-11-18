;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |106|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 106
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

;; Functions related to the cat

; Number -> Number
; Calculate the next x coordinate that the cat will go to
(define (calc-next-x current-x)
  (modulo (+ current-x VANIMAL-DX) SN-EDGE))

;c
; CatState -> Image
; use the cats locations to determine
; which cat sprite to use
(define (render-cat cs)
  (if (odd? (vcat-cx cs)) CAT-ALT CAT))

;;;;;CHANGE
; CatState -> Image
; places the cat onto the empty scene
; this is an intermediate image
; that will later be combined with the
; progress bar
(define (place-cat-on-scene cs)
  (place-image/align (render-cat cs)
                                 (vcat-cx cs)
                                 CAT-SHIFT-Y
                                 "center"
                                 "bottom"
                                 SN))

;; Functions related to the bar
;;;;;CHANGE
; CatState -> Image
(define (render-happy-bar cs)
  (rectangle (calculate-happy-bar-width (vcat-ch cs)) BAR-HEIGHT "solid" "red"))

; Number -> Number
; function to determine the appropriate width of the bar
; based on the level of happiness hs
(define (calculate-happy-bar-width hs)
  (* hs (/ SN-WIDTH 100)))

(check-expect (calculate-happy-bar-width 100)
              (* 100 (/ SN-WIDTH 100)))

; HappyState -> Number
; hs is current happiness level
; purpose: decrease happiness unless its already zero
(define (calc-next-happy hs)
  (if (> hs 0) (- hs (* hs HDECREASE)) 0))

(define (increase-happy hs key)
  (cond
    [(key=? key "up")    (+ hs (* hs SMHAPPY))]
    [(key=? key "down")  (+ hs (* hs LGHAPPY))]))             


;; Handlers

; VAnimal -> VAnimal
; Each clock tick update the x position of the animal
; The happiness level of the vanimal should decrease
(define (clock-tick-handler va)
  (cond [(vcat? va) (make-vcat (calc-next-x (vcat-cx va))
                               (calc-next-happy (vcat-ch va)))]
        [(vcham? va) ...]))


;;;;;CHANGE
; CatState -> Image
; place the happy bar onto a scene that already has a cat on it
; **better way to do this is to use place images but we have not
; yet learned about lists
(define (render cs)
  (place-image/align (render-happy-bar cs) 0 0 "left" "top" (place-cat-on-scene cs)))

;;Testing
(define c1 (make-vcat 200 20))
(define c2 (make-vcat 1 0))
(define happy-cat (make-vcat 0 100))
(define cat-past-edge (make-vcat (+ 50 SN-EDGE) 0))

(check-expect (calc-next-cat-x (vcat-cx c1))
              (modulo (+ (vcat-cx c1) VANIMAL-DX) SN-EDGE))

(check-expect (place-cat-on-scene c1)
              (place-image/align (render-cat c1)
                                 (vcat-cx c1)
                                 CAT-SHIFT-Y
                                 "center"
                                 "bottom"
                                 SN))
(check-expect (place-cat-on-scene c2)
              (place-image/align (render-cat c2)
                                 (vcat-cx c2)
                                 CAT-SHIFT-Y
                                 "center"
                                 "bottom"
                                 SN))
(check-expect (render c1)
              (place-image/align (render-happy-bar c1) 0 0 "left" "top" (place-cat-on-scene c1)))

;;Main
(define (main cs0)
  (big-bang cs0
    [on-tick clock-tick-handler 1]
    [to-draw render]))
(main (make-vcat 0 100))