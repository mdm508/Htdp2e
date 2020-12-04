;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |108|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 108 Walking Man
; A CrossingState is any of the following
; Walking  t: Walk man displayed at time t where t is a number between 1 & 10
; Counting t: Number t displayed. The color is green if t is even otherwise its orange. t is between 0 & 9
; Waiting   : Wait man displayed
; ------------------------------------------------
;  DFA for CrossingState
;  STATE              EVENT         RESULT-STATE            
;  Walking t          1 < t         Walking t-1
;                     t = 1         Counting 
;  Counting      1 <= t < 9         Counting
;                     t = 0         Waiting
;  Waiting            space         Walking t=10
; ------------------------------------------------
(require 2htdp/image)
(require 2htdp/universe)
(define WAIT-MAN (bitmap/file "../assets/pedestrian_traffic_light_red.png"))
(define WALK-MAN (bitmap/file "../assets/pedestrian_traffic_light_green.png"))
; Definition of CrossingState
(define-struct cs [cur])
(define-struct walk [time])
(define-struct count [time])
(define-struct wait [])
; Number -> Image
; produce a number as an image
(define (number->image n)
  ...
  )
; CrossingState -> CrossingState
(define (tick-handler cs)
  ...
  )
; CrossingState -> CrossingState
(define (key-handler cs)
  ...
  )
; CrossingState -> Image
(define (render cs)
  ...
  )
; CrossingState -> CrossingState
(define (main cs0)
  (big-bang cs0
    [on-draw render]
    [on-tick tick-handler 1]
    [on-key key-handler]
    ))