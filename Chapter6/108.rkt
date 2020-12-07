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
;  Walking t     1 <= t <= 9          Walking t-1
;                     t = 0         Counting 
;  Counting      1 <= t <= 9         Counting
;                     t = 0         Waiting
;  Waiting            space         Walking t=9
; ------------------------------------------------
(require 2htdp/image)
(require 2htdp/universe)
(define WAIT-MAN (bitmap/file "../assets/pedestrian_traffic_light_red.png"))
(define WALK-MAN (bitmap/file "../assets/pedestrian_traffic_light_green.png"))
; Definition of CrossingState
(define-struct cs [cur])
; (make-cs cur) creates a CrossingState.
; cur is the current CrossingState and it is one of the following types
; a Walk
; a Count
; a Wait
; Definition of WalkingState
(define-struct walk [time])
; (make-walk time)
; 1 <= time <= 10 and time is a Number
; Definition of CountingState
(define-struct count [time])
; (make-count time)
; 1 <= time <= 9 and time is a Number
; Definition of WaitingState
(define-struct wait [])
; (make-wait) is a struct
; Number -> Image
; produce a number as an image
;
; We define a TimedState to be either
; - WalkingState
; - CountingState
; thus all TimeStates are CrossingStates.
; Template
;(cond [(count? cs) ...]
;      [(wait? cs) ...]
;      [(walk? cs) ...]
;      )
; CountingState -> Image
; render a number as text
(define (count->image cs)
  (text (number->string (count-time cs)) 24 "black")
  )
(check-expect (count->image (make-count 24))
              (text (number->string (count-time
                                     (make-count 24))
                                    )
                     24 "black"))
; TimedState -> CrossingState
(define (decrease-time ts)
  (cond [(count? ts)
         (if (= (count-time ts) 0)
             (make-wait)
             (make-count (- (count-time ts) 1)))]
        [(walk? ts)
         (if (=  (walk-time ts) 0)
             (make-count 9)
             (make-walk (- (walk-time ts) 1)))]
        )
  )
(define test-count-max-low (make-count 0))
(define test-count-six (make-count 6))
(define test-walk-max-low (make-walk 0))
(define test-walk-six (make-walk 6))
(check-expect (decrease-time test-count-max-low)
              (make-wait))
(check-expect (decrease-time test-count-six)
              (make-count (- (count-time test-count-six) 1)))
(check-expect (decrease-time test-walk-max-low)
              (make-count 9))
(check-expect (decrease-time test-walk-six)
              (make-walk (- (walk-time test-walk-six) 1)))

; CrossingState -> CrossingState
(define (tick-handler cs)
  (cond [(count? cs) (decrease-time cs)]
        [(walk? cs) (decrease-time cs)]
        [(wait? cs) cs]
        )
  )
; CrossingState KeyEven -> CrossingState
(define (key-handler cs ke)
  (if (and (wait? cs) (key=? " " ke))
      (make-walk 9)
      cs
      )
  )
(check-expect (key-handler  (make-wait) " ")
              (make-walk 9))
(check-expect (key-handler (make-wait) "a")
              (make-wait))
(check-expect (key-handler (make-count 10) " ")
              (make-count 10))
; CrossingState -> Image
(define (render cs)
  (cond [(count? cs)
         (count->image cs)]
        [(wait? cs) WAIT-MAN]
        [(walk? cs) WALK-MAN]
      )
  )
; CrossingState -> CrossingState
(define (main cs0)
  (big-bang cs0
    [on-draw render]
    [on-tick tick-handler 1]
    [on-key key-handler]
    ))

(main (make-wait))