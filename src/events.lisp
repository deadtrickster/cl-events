(in-package :cl-events)

;; Predefined event types repository

;; aka classic-event
(defclass event (multi-thread-sink
          serial-executor)
  ())

;; aka js-like-event
(defclass simple-event (single-thread-sink
                 serial-executor)
  ())

(defclass non-blocking-event (single-thread-sink
                       chained-executor)
  ())

(defclass broadcast-event (multi-thread-sink
                    pooled-executor)
  ())

(defmethod invoke-event-handlers (event &rest args)
  (invoke-executor event event args))

(defun event-handlers-list (event)
  (sink-handlers-list event))
