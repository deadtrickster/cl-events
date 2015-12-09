(in-package :cl-events)

(defclass chained-executor ()
  ()
  (:documentation "Emulates serial-executor for non-blocking environments"))

(defmethod invoke-event-handlers ((event chained-executor) &rest args)
  (let ((handlers (event-handlers-list event)))
    (labels ((execute-handler ()
               (apply (pop handlers) args))
             (next()
               (when handlers
                 (bb:create-promise
                  (lambda (resolve reject)
                    (declare (ignore reject))
                    (bb:attach (execute-handler)
                            (lambda (&rest args)
                              (declare (ignore args))
                              (bb:attach (next)
                                         (lambda (&rest args)
                                           (declare (ignore args))
                                           (funcall resolve))))))))))
      (next))))
