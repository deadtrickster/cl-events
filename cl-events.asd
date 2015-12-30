(eval-when (:compile-toplevel :load-toplevel :execute)
  #+(or sbcl ccl lispworks)
  (pushnew :cl-events.cas *features*))

(in-package :cl-user)

(defpackage :cl-events.system
  (:use :cl :asdf))

(in-package :cl-events.system)

(defsystem :cl-events
  :version "0.2"
  :description "Events for Common Lisp"  
  :maintainer "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :author "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :licence "MIT"
  :depends-on ("alexandria"
               "iterate"
               "log4cl"
               "lparallel"
               "blackbird")
  :components ((:module "src"
                :serial t
                :components
                ((:file "package")
                 (:module "support"
                  :serial t
                  :components
                  (#+cl-events.cas(:file "cas")))
                 (:module "executors"
                  :serial t
                  :components
                  ((:file "base")
                   (:file "serial-executor")
                   (:file "chained-executor")
                   (:file "threaded-executor")
                   (:file "pooled-executor")))
                 (:module "sinks"
                  :serial t
                  :components
                  ((:file "base")
                   (:file "single-thread-sink")
                   (:file "multi-thread-sink")))
                 (:file "events")
                 (:file "api")))))
