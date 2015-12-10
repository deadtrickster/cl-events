(in-package :cl-events)

(defclass chained-executor ()
  ()
  (:documentation "Emulates serial-executor for non-blocking environments"))

(defmethod invoke-executor ((executor chained-executor) sink args)
  (let ((handlers (sink-handlers-list sink)))
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
