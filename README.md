# CL-EVENTS [![Build Status](https://travis-ci.org/deadtrickster/cl-events.svg)](https://travis-ci.org/deadtrickster/cl-events) [![Coverage Status](https://coveralls.io/repos/deadtrickster/cl-events/badge.svg?branch=master&service=github&qwe=1)](https://coveralls.io/github/deadtrickster/cl-events?branch=master)

Composable events system for Common Lisp

## Wut

CL-EVENTS sees event as an entity that implements the following APIs:

- `add-event-handler`
- `remove-event-handler`
- `sink-handlers-list`
- `invoke-executor`
- `invoke-event-handlers`

This was futher re-grouped as
- Sinks (`add-event-handler`, `remove-event-handler`, `sink-handlers-list`)
- Executors (`invoke-executor`)
- Events (`invoke-event-handlers`)

CL-EVENTS implements the following SINK types:

- `single-thread-think` - add/remove/list operations must be performed in single thread OR synchronized manually
- `multi-thread-think` - add/remove/list operations synchronized for you. On available platforms CAS is used.

and EXECUTOR types:

- `serial-executor` - consecutively executes handlers returned by `event-handlers-list`. The next handler executed only after previous one returned
- `chained-executor` - emulates `serial-executor` for non-blocking word. It assumes you are using [blackbird](https://github.com/orthecreedence/blackbird) as promises implementation. The next handler executed only after promise returned by previous one is resolved.
- `threaded-executor` - each handler executed in its own newly-created thread.
- `pooled-executor` - handlers executed in [lparallel](http://lparallel.org/) pool. Note: if`*thread-pool*` is nil new lparallel kernel of size 5 will be automatically created.

CL-EVENTS also exports number of predefined event types:
-  `event` `(multi-thread-sink serial-executor)`
-  `simple-event` `(single-thread-sink serial-executor)`
-  `non-blocking-event` `(single-thread-sink chained-executor)`
-  `broadcast-event` `(multi-thread-sink pooled-executor)`

Usually you just need to define your custom sink/executor types and compose events.
For further customizations `invoke-event-handlers` can be used to select executor at runtime for example,

```
(defparameter *event-executor* nil)

(defclass bunny-event (multi-thread-sink pooled-executor)
  ())

(defmethod invoke-event-handlers ((event bunny-event) &rest args)
  (if *event-executor*
      (invoke-executor *event-executor* event args)
      (call-next-method)))
```

## Example

``` lisp
;; broadcast-event
;; handlers can be added/removed from many threads
;; and will be executed in lparallel pool

(ql:quickload :cl-events)

(in-package :cl-events)

(defun make-broadcast-event ()
  (make-instance 'broadcast-event))

;; use event type

(defclass channel ()
  ((name :accessor channel-name)
   (state :initform :closed
          :accessor :channel-state)
   ;; events
   (on-message :initform (make-broadcast-event)
               :reader channel-on-message)
   (on-close :initform (make-broadcast-event)
             :reader channel-on-close)))

(defparameter *channel* (make-instance 'channel))

;; subscribe

(event+ (channel-on-message *channel*)
        (lambda (message)
          (format t "Received: ~a" message)))

(event+ (channel-on-close *channel*)
        (lambda (channel)
          (format t "Closed: ~a" channel)))

;; fire

(event! (channel-on-message *channel*) "Hello from cl-events")

#|Received: Hello from cl-events|#

(event! (channel-on-close *channel*) *channel*)

#|Closed: #<CHANNEL {1003D06703}>|#

```

## License

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

By contributing to the project, you agree to the license and copyright terms therein and release your contribution under these terms.

## Copyright

Copyright (c) 2015 Ilya Khaprov <ilya.khaprov@publitechs.com> and [CONTRIBUTORS](CONTRIBUTORS.md)

CL-EVENTS uses a shared copyright model: each contributor holds copyright over their contributions to CL-EVENTS. The project versioning records all such contribution and copyright details.

If a contributor wants to further mark their specific copyright on a particular contribution, they should indicate their copyright solely in the commit message of the change when it is committed. Do not include copyright notices in files for this purpose.
