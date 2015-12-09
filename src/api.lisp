(in-package :cl-events)

;; ClientAPI

(defun event+ (event handler &rest args)
  (apply #'add-event-handler event handler args))

(defun event- (event tag)
  (apply #'remove-event-handler (sink tag)))

(defun event! (event &rest args)
  (apply #'invoke-event-handlers event args))
