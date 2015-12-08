# CL-EVENTS [![Build Status](https://travis-ci.org/deadtrickster/cl-events.svg)](https://travis-ci.org/deadtrickster/cl-events) [![Coverage Status](https://coveralls.io/repos/deadtrickster/cl-events/badge.svg?branch=master&service=github)](https://coveralls.io/github/deadtrickster/cl-events?branch=master)

Events for Common Lisp

## Example

``` lisp
;; broadcast-event
;; handlers can be added/removed from many threads
;; and will be executed in lparallel pool

(defclass broadcast-event (multi-thread-sink
                           pooled-executor)
  ())

;; use event type

(defclass channel
  ((name :accessor channel-name)
   (state :initform close
          :accessor :channel-state)
   ;; events
   (on-message :initform (make-broadcast-event)
               :reader channel-on-message)
   (on-close :initform (make-bradcast-event)
             :reader channel-on-close)))

(defparameter *channel* (channel.new.open))

;; subscribe

(event+ (channel-on-message *channel*)
        (lambda (message)
          (format "Received: ~a" (message-body-string message))))

(event+ (channel-on-close *channel*)
        (lambda (channel)
          (format "Closed: ~a" channel)))

;; fire

(event! (channel-on-message *channel*) message)

```
