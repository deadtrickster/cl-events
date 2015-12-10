(in-package :cl-user)

(defpackage :cl-events
  (:use :cl
        :alexandria
        :iterate)
  (:export ;; events developer API
           #:add-event-handler
           #:remove-event-handler
           #:sink-handlers-list
           #:invoke-executor

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
           #:broadcast-event
           #:invoke-event-handlers
           #:event-handlers-list

           ;; events user API
           #:event+
           #:event-
           #:event!))

(in-package :cl-events)
