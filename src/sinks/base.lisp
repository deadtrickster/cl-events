(in-package :cl-events)

(defgeneric add-event-handler (sink handler &key &allow-other-keys))
(defgeneric remove-event-handler (sink tag))
(defgeneric event-handlers-list (sink))
