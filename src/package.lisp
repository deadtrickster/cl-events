(in-package :cl-user)

(defpackage :cl-events
  (:use :cl
        :alexandria)
  (:export ;; events developer API
           #:add-event-handler
           #:remove-event-handler
           #:invoke-event-handlers

           ;; sinks
           #:single-thread-sink
           #:multi-thread-sink

           ;; executors
           #:serial-executor
           #:chained-executor
           #:threaded-executor
           #:pooled-executor
           #:*thread-pool*

           ;; predefined event types
           #:event
           #:simple-event
           #:non-blocking-event

           ;; events user API
           #:event+
           #:event-
           #:event!))

(in-package :cl-events)
