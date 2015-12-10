(in-package :cl-events.test)

(plan 1)

(defclass se-event (single-thread-sink serial-executor)
  ())

(defclass ce-event (single-thread-sink chained-executor)
  ())

(defclass te-event (single-thread-sink threaded-executor)
  ())

(defclass pe-event (single-thread-sink pooled-executor)
  ())

(subtest "Executors test"
  (subtest "Serial executor"
    (let ((event (make-instance 'se-event))
          (y 0))
      (iter (for i from 0 to 999)
        (event+ event (lambda () (incf y))))
      (event! event)
      (is y 1000)))

  (subtest "Chained executor"
    (let ((event (make-instance 'ce-event))
          (y 0))
      (iter (for i from 0 to 99) ;; be delicate with stack
        (event+ event (lambda () (incf y))))
      (event! event)
      (is y 100)))

  (subtest "Thread executor"
    (let ((event (make-instance 'te-event))
          (y 0)
          (lock (bt:make-lock)))
      (iter (for i from 0 to 999)
        (event+ event (lambda ()
                        (sleep (/ (random 100) 1000))
                        (bt:with-lock-held (lock)
                          (incf y)))))
      (event! event)
      (sleep 5)
      (is y 1000)))

  (subtest "Pooled executor"
    (let ((event (make-instance 'pe-event))
          (y 0)
          (lock (bt:make-lock)))
      (iter (for i from 0 to 999)
        (event+ event (lambda ()
                        (sleep (/ (random 100) 1000))
                        (bt:with-lock-held (lock)
                          (incf y)))))
      (event! event)
      (sleep 20)
      (is y 1000))))

(finalize)
