(in-package :cl-events)

(defclass pooled-executor ()
  ()
  (:documentation "Executes each event handler in lparallel thread pool"))
