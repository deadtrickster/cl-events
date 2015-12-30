(in-package :cl-events)

(defclass serial-executor ()
  ()
  (:documentation "Iterates over sink content and executes event handlers one after another"))

(defmethod invoke-executor ((executor serial-executor) sink args)
  (invoke-executor 'serial-executor sink args))

(defmethod invoke-executor ((executor (eql 'serial-executor)) sink args)
  (let ((handlers (sink-handlers-list sink)))
    (iter (for handler in handlers)
      (apply handler args))))
