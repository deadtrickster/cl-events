(ql:quickload :cl-events)

(in-package :cl-events)

(defun make-broadcast-event ()
  (make-instance 'broadcast-event))

;; use event type

(defclass channel ()
  ((name :accessor channel-name)
   (state :initform :closed
          :accessor :channel-state)
   ;; events
   (on-message :initform (make-broadcast-event)
               :reader channel-on-message)
   (on-close :initform (make-broadcast-event)
             :reader channel-on-close)))

(defparameter *channel* (make-instance 'channel))

;; subscribe

(event+ (channel-on-message *channel*)
        (lambda (message)
          (format t "Received: ~a" message)))

(event+ (channel-on-close *channel*)
        (lambda (channel)
          (format t "Closed: ~a" channel)))

;; fire

(event! (channel-on-message *channel*) "Hello from cl-events")

#|Received: Hello from cl-events|#

(event! (channel-on-close *channel*) *channel*)

#|Closed: #<CHANNEL {1003D06703}>|#
