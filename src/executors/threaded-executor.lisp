(in-package :cl-events)

(defclass threaded-executor ()
  ()
  (:documentation "Executes each event handler in newly created thread"))

(defmethod invoke-executor ((executor threaded-executor) sink args)
  (invoke-executor 'threaded-executor sink args))

(defmethod invoke-executor ((executor (eql 'threaded-executor)) sink args)
  (let ((handlers (sink-handlers-list sink)))
    (iter (for handler in handlers)
      (bt:make-thread (lambda () (apply handler args))
                      :name "cl-events-event-handler"))))
