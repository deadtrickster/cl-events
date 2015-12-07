(in-package :cl-user)

(defpackage :cl-events.test.system
  (:use :cl :asdf))

(in-package :cl-events.test.system)

(defsystem :cl-events.test
  :version "0.1"
  :description "Tests for cl-events"
  :maintainer "Ilya Khaprov <ilya.khaprov@publitechs.com>"
  :author "Ilya Khaprov <ilya.khaprov@publitechs.com> and CONTRIBUTORS"
  :licence "MIT"
  :depends-on ("cl-events"
               "prove"
               "log4cl"
               "mw-equiv")
  :serial t
  :components ((:module "t"
                :serial t
                :components
                ((:file "package")
                 (:test-file "dummy"))))
  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)))
