(in-package :cl-events.test)

(plan 1)

(subtest "Sinks tests"
  (subtest "Single-thread sink"
    (let ((sink (make-instance 'single-thread-sink)))
      (iter (for i from 0 to 999)
        (add-event-handler sink (intern (format nil "HANDLER~a" i))))
      (is (length (event-handlers-list sink)) 1000)
      (is (find 'handler54 (event-handlers-list sink)) 'handler54)
      (remove-event-handler sink 'handler54)
      (is (length (event-handlers-list sink)) 999)
      (is (find 'handler54 (event-handlers-list sink)) nil)))

  (subtest "Multi-thread sink"
    (let ((sink (make-instance 'multi-thread-sink)))
      ;; with sinke being single-thread-sink this test usually ends like as follows:
      #|
       Multi-thread sink
         × 953 is expected to be 1000
         × NIL is expected to be HANDLER54
         × 953 is expected to be 999
         ✓ NIL is expected to be NIL
       Multi-thread sink
         × 985 is expected to be 1000
         ✓ HANDLER54 is expected to be HANDLER54
         × 984 is expected to be 999
         ✓ NIL is expected to be NIL
      |#
      (flet ((run-thread (i)
               (bt:make-thread (lambda ()
                          (sleep (/ (random 100) 1000))
                          (add-event-handler sink (intern (format nil "HANDLER~a" i) (find-package :cl-events.test)))))))
        (iter (for i from 0 to 999)
          (run-thread i)))
      (sleep 2)
      (is (length (event-handlers-list sink)) 1000)
      (is (find 'handler54 (event-handlers-list sink)) 'handler54)
      (remove-event-handler sink 'handler54)
      (is (length (event-handlers-list sink)) 999)
      (is (find 'handler54 (event-handlers-list sink)) nil))))

(finalize)
