;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |108|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 108 Pedestrian traffic light program
(require 2htdp/image)
(require 2htdp/universe)

; A CrossingState is any of the following
; Walking  t: Walk man displayed at time t where t is a number between 1 & 10
; Counting t: Number t displayed. The color is green if t is even otherwise its orange. t is between 0 & 9
; Waiting   : Wait man displayed

;  Description of states & transitions
;  STATE              EVENT         RESULT-STATE            
;  Walking t          1 < t         Walking t-1
;  Walking 0          t = 1         Counting 
;  Counting           0 <= t < 9    Counting

(define WAIT-MAN (bitmap/file "../assets/pedestrian_traffic_light_red.png"))
(define WALK-MAN (bitmap/file "../assets/pedestrian_traffic_light_green.png"))

