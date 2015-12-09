(in-package :cl-events)

(defclass threaded-executor ()
  ()
  (:documentation "Executes each event handler in newly created thread"))

(defmethod invoke-event-handlers ((event threaded-executor) &rest args)
  (let ((handlers (event-handlers-list event)))
    (loop for handler across handlers
          do (bt:make-thread (lambda () (apply handler args))
                             :name "cl-events-event-handler"))))
