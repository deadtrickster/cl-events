(in-package :cl-events)

(defclass multi-thread-sink (#-cas
                      single-thread-sink)
  (#+cas
   (proxy :initform (make-instance 'single-thread-sink))
   #-cas
   (lock :initform (bt:make-lock "multi-thread-sink lock")))
  (:documentation "Hanldlers added/removed possibly concurrently from many threads."))

#-cas
(defmethod event-handlers-list :around ((sink multi-thread-sink))
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))

#-cas
(defmethod add-event-handler :around ((sink multi-thread-sink) handler &key &allow-other-keys)
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))

#-cas
(defmethod remove-event-handler :around ((sink multi-thread-sink) handler)
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))
