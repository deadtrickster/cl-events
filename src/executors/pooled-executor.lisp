(in-package :cl-events)

(defparameter *thread-pool* nil)

(defclass pooled-executor ()
  ()
  (:documentation "Executes each event handler in lparallel thread pool"))

(defun get-thread-pool ()
  (or *thread-pool*
      (progn
        (log:warn "*thread-pool* not set, using default")
        (setf *thread-pool* (lparallel:make-kernel 5)))))

(defun execute-in-thread-pool (handler args)
  (lparallel.kernel::submit-raw-task
   (lparallel.kernel::make-task-instance
    (lambda ()
      (apply handler args))
    :cl-events)
   (get-thread-pool)))

(defmethod invoke-executor ((executor pooled-executor) sink args)
  (invoke-executor 'pooled-executor sink args))

(defmethod invoke-executor ((executor (eql ' pooled-executor)) sink args)
  (let ((handlers (sink-handlers-list sink)))
    (iter (for handler in handlers)
      (execute-in-thread-pool handler args))))
