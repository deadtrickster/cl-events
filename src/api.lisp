(in-package :cl-events)

(defun make-once-handler (event handler)
  (let ((once-handler))
    (setf once-handler
          (lambda (&rest args)
            (unwind-protect
                 (apply handler args)
              (event- event once-handler))))))

;; ClientAPI

(defun event+ (event handler &rest args &key once)
  (apply #'add-event-handler event (or
                                    (and once (make-once-handler event handler))
                                    handler)
                             args))

(defun event- (event tag)
  (funcall #'remove-event-handler event tag))

(defun event! (event &rest args)
  (apply #'invoke-event-handlers event args))
