(in-package :cl-events)

(defclass serial-executor ()
  ()
  (:documentation "Iterates over sink content and executes event handlers one after another"))

(defmethod invoke-event-handlers ((event serial-executor) &rest args)
  (let ((handlers (event-handlers-list event)))
    (iter (for handler in handlers)
      (apply handler args))))
