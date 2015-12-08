(in-package :cl-events)

(defclass threaded-executor ()
  ()
  (:documentation "Executes each event handler in newly created thread"))
