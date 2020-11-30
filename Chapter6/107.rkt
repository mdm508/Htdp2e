;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |107|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 107
; Update the code so it works with Zoo
; You should be able to press a key and switch between animals
; I've deviated from the instructions a bit.
; Instead of using k & l to focus on a particular animal
; I simply use space to trigger a swap
; In this problem we want to apply the design recipe for mixed data

; http://htdp.org/2003-09-26/Book/curriculum-Z-H-10.html#node_sec_7.2



(require 2htdp/universe)
(require 2htdp/image)

; VAnimal is either VCat or VCham
(define-struct vcat [cx ch])
(define-struct vcham [cx ch])

; Zoo
(define-struct zoo [focused hidden])
; a Zoo is a structure to help us store data on
; the animals in a zoo.
; focused & hidden are both VAnimals
; focused designates which
; animal will be sent keystrokes to and rendered on the window
; (make-zoo (make-vcat 100 100) (make-vcham 100 100)

;; Constants
(define SN-WIDTH 420)
(define SN-HEIGHT 320)
(define SN-MID-Y (/ SN-HEIGHT 2))
(define SN-MID-X (/ SN-WIDTH 2))
(define SN (empty-scene SN-WIDTH SN-HEIGHT))
(define VANIMAL-DX (* 0.05 SN-WIDTH))
(define CAT (bitmap/file "../assets/ninja_a.png"))
(define CAT-ALT (bitmap/file "../assets/ninja_b.png"))
(define CHAM (rotate  80 (bitmap/file "../assets/chameleon.png")))
(define CHAM-ALT (rotate 40 CHAM))
; The va is anchored at the bottom of the screen
; this number is how much to shift the va up by
(define VA-DELTAY (- SN-HEIGHT (/ (image-height CAT) 2)))
; the cordinate where the cat would appear off the screen
(define SN-EDGE (ceiling (+ SN-WIDTH (/ (image-width CAT) 2))))
(define BAR-HEIGHT (/ SN-HEIGHT 4))
(define HDECREASE .33)
(define SMHAPPY 1/3)
(define LGHAPPY 1/5)

; Test instances used in multiple test cases
(define cham1 (make-vcham (/ SN-WIDTH 2) 100))
(define cat1 [make-vcat (/ SN-WIDTH 2) 100])
(define zoo1 (make-zoo cat1 cham1))

; Helper functions
; Number -> Number
(define (calc-next-x current-x)
  (modulo (+ current-x VANIMAL-DX) SN-EDGE))
; Number -> Number
(define (calculate-happy-bar-width hs)
  (* hs (/ SN-WIDTH 100)))
(check-expect (calculate-happy-bar-width 100)
              (* 100 (/ SN-WIDTH 100)))
; Number -> Number
; hs is current happiness level
; purpose: decrease happiness unless its already zero
(define (decrease-happy hs)
  (if (> hs 0) (- hs (* hs HDECREASE)) 0))
; VAnimal -> Image
; decides which va image to use so when animated
; the illusion of movement is created
(define (choose-va-image va)
  (cond [(vcat? va)
         (if (odd? (vcat-cx va)) CAT-ALT CAT)]
        [(vcham? va)
         (if (odd? (vcham-cx va)) CHAM-ALT CHAM)]))
(define e-cham (make-vcham 100 100))
(define o-cham (make-vcham 101 100))
(define e-cat (make-vcat 100 100))
(define o-cat (make-vcat 101 100))
(check-expect (choose-va-image e-cat)
              (if (odd? (vcat-cx e-cat)) CAT-ALT CAT))
(check-expect (choose-va-image o-cat)
              (if (odd? (vcat-cx o-cat)) CAT-ALT CAT))
(check-expect (choose-va-image o-cham)
              (if (odd? (vcham-cx o-cham)) CHAM-ALT CHAM))
(check-expect (choose-va-image e-cham)
              (if (odd? (vcham-cx e-cham)) CHAM-ALT CHAM))
; VAnimal -> Image
(define (place-va-on-scene va)
  (place-image/align (choose-va-image va)
                     (cond [(vcat? va)
                            (vcat-cx va)]
                           [(vcham? va)
                            (vcham-cx va)]
                           )
                     VA-DELTAY
                     "center"
                     "bottom"
                     SN))
(check-expect (place-va-on-scene cham1)
              (place-image/align (choose-va-image cham1)
                                 (cond [(vcat? cham1)
                                        (vcat-cx cham1)]
                                       [(vcham? cham1)
                                        (vcham-cx cham1)]
                                       )
                                 VA-DELTAY
                                 "center"
                                 "bottom"
                                 SN))
(check-expect (place-va-on-scene cat1)
              (place-image/align (choose-va-image cat1)
                                 (cond [(vcat? cat1)
                                        (vcat-cx cat1)]
                                       [(vcham? cat1)
                                        (vcham-cx cat1)]
                                       )
                                 VA-DELTAY
                                 "center"
                                 "bottom"
                                 SN))
; Zoo VAnimal -> Zoo
; creates new zoowhere hidden of z is unchanged
; and focused is va
(define (update-focused z va)
  (make-zoo va (zoo-hidden z)))

(check-expect (update-focused zoo1 cham1)
              (make-zoo cham1 cham1))
; Zoo -> Zoo
; Each clock tick update the x position of va and decrease its happiness
(define (clock-tick-handler z)
  (cond [(vcat? (zoo-focused z))
         (update-focused
          z
          (make-vcat (calc-next-x (vcat-cx (zoo-focused z)))
                     (decrease-happy (vcat-ch (zoo-focused z)))))]
        [(vcham? (zoo-focused z))
         (update-focused
          z
          (make-vcham (calc-next-x (vcham-cx (zoo-focused z)))
                      (decrease-happy (vcham-ch (zoo-focused z)))))]))

; VAnimal -> Image
; Render a happiness bar for va
(define (render-happy-bar va)
  (cond [(vcat? va)
         (rectangle (calculate-happy-bar-width (vcat-ch va)) BAR-HEIGHT "solid" "red")]
        [(vcham? va)
         (rectangle (calculate-happy-bar-width (vcham-ch va)) BAR-HEIGHT "solid" "red")]))
(check-expect (render-happy-bar cham1)
              (rectangle (calculate-happy-bar-width (vcham-ch cham1)) BAR-HEIGHT "solid" "red"))
(check-expect (render-happy-bar cat1)
              (rectangle (calculate-happy-bar-width (vcat-ch cat1)) BAR-HEIGHT "solid" "red"))
; Zoo -> Image
; Whataever animnal is focused is rendered onto the screen
(define (render zoo)
  (place-image/align (render-happy-bar (zoo-focused zoo))
                     0 0 "left" "top"
                     (place-va-on-scene (zoo-focused zoo))))
; Number String -> Number
; hlevel is the happiness level of the va
(define (increase-happy hlevel key)
  (cond
    [(key=? key "up")    (+ hlevel (* hlevel SMHAPPY))]
    [(key=? key "down")  (+ hlevel (* hlevel LGHAPPY))]
    [else (decrease-happy hlevel)]))             
; Zoo -> Zoo
(define (switch-focus z)
  (make-zoo (zoo-hidden z) (zoo-focused z)))
; Zoo -> Zoo
; if space bar was pressed then swap which VAnimal is focused
; otherwise increase or decrease happiness of focused VAnimal
(define (key-handler z key)
  (cond  [(key=? key " ")
          (switch-focus z)]
         [(vcat? (zoo-focused z))
          (update-focused
           z
           (make-vcat (vcat-cx (zoo-focused z))
                    (increase-happy (vcat-ch (zoo-focused z)) key)))]
        [(vcham? (zoo-focused z))
         (update-focused
          z
          (make-vcham (vcham-cx (zoo-focused z))
                     (increase-happy (vcham-ch (zoo-focused z)) key)))]))

; Main
; VAnimal -> VAnimal
(define (main va)
  (big-bang va
    [to-draw render]
    [on-tick clock-tick-handler 1]
    [on-key key-handler]))
(define start-zoo (make-zoo
                       (make-vcat 0 100)
                       (make-vcham 0 100)))
(main start-zoo)

