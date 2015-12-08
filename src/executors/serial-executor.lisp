(in-package :cl-events)

(defclass serial-executor ()
  ()
  (:documentation "Iterates over sink content and executes event handlers one after another"))

