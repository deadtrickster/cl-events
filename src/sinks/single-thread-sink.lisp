(in-package :cl-events)

(defclass single-thread-sink ()
  ((handlers :initform (list) :accessor sink-handlers)
   (copy :initform (list) :accessor sink-handlers-copy))
  (:documentation "eventhandlers added/removed in single-threaded context."))

(defmethod event-handlers-list ((sink single-thread-sink))
  (sink-handlers-copy sink))

(defmethod add-event-handler ((sink single-thread-sink) handler &key &allow-other-keys)
  (setf (sink-handlers sink) (append (sink-handlers sink) (list handler))
        (sink-handlers-copy sink) (copy-seq (sink-handlers sink)))
  sink)

(defmethod remove-event-handler ((sink single-thread-sink) handler)
  (setf (sink-handlers sink) (remove handler (sink-handlers sink))
        (sink-handlers-copy sink) (sink-handlers sink))
  sink)
