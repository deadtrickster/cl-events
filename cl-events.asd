(in-package :cl-user)

(defpackage :cl-events.system
  (:use :cl :asdf))

(in-package :cl-events.system)

(defsystem :cl-events
  :version "0.1"
  :description "Events for Common Lisp"  
  :maintainer "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :author "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :licence "MIT"
  :depends-on ("alexandria"
               "log4cl"
               "lparallel")
  :components ((:module "src"
                :serial t
                :components
                ((:file "package")
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
