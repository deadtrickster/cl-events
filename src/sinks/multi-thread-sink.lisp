(in-package :cl-events)

(defclass multi-thread-sink (single-thread-sink)
  (#-cl-events.cas
   (lock :initform (bt:make-lock "multi-thread-sink lock")))
  (:documentation "Hanldlers added/removed possibly concurrently from many threads."))

#-cl-events.cas
(defmethod event-handlers-list :around ((sink multi-thread-sink))
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))

#-cl-events.cas
(defmethod add-event-handler :around ((sink multi-thread-sink) handler &key &allow-other-keys)
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))

#-cl-events.cas
(defmethod remove-event-handler :around ((sink multi-thread-sink) handler)
  (bt:with-lock-held ((slot-value sink 'lock))
    (call-next-method)))

#+cl-events.cas
(defmethod sink-handlers-list ((sink multi-thread-sink))
  (sink-handlers sink))

;; TODO: maybe implement backoff strategy?

#+cl-events.cas
(defmethod add-event-handler ((sink multi-thread-sink) handler &key &allow-other-keys)
  (let ((hl (list handler)))
    (labels ((try-to-add ()
               (let* ((old (sink-handlers sink))
                      (new (append old hl)))
                 (cas (slot-value sink 'handlers)
                      old
                      new))))
      (loop
        (when (try-to-add)
          (return handler))))))

(defmethod remove-event-handler ((sink multi-thread-sink) handler)
  (labels ((try-to-remove ()
             (let* ((old (sink-handlers sink))
                    (new (remove handler old)))
               (cas (slot-value sink 'handlers)
                    old
                    new))))
    (loop
      (when (try-to-remove)
        (return handler)))))
