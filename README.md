# CL-EVENTS [![Build Status](https://travis-ci.org/deadtrickster/cl-events.svg)](https://travis-ci.org/deadtrickster/cl-events) [![Coverage Status](https://coveralls.io/repos/deadtrickster/cl-events/badge.svg?branch=master&service=github)](https://coveralls.io/github/deadtrickster/cl-events?branch=master)

Events for Common Lisp

## Example

``` lisp
;; broadcast-event
;; handlers can be added/removed from many threads
;; and will be executed in lparallel pool

(defclass broadcast-event (multi-thread-sink
                           pooled-executor)
  ())

;; use event type

(defclass channel
  ((name :accessor channel-name)
   (state :initform close
          :accessor :channel-state)
   ;; events
   (on-message :initform (make-broadcast-event)
               :reader channel-on-message)
   (on-close :initform (make-bradcast-event)
             :reader channel-on-close)))

(defparameter *channel* (channel.new.open))

;; subscribe

(event+ (channel-on-message *channel*)
        (lambda (message)
          (format "Received: ~a" (message-body-string message))))

(event+ (channel-on-close *channel*)
        (lambda (channel)
          (format "Closed: ~a" channel)))

;; fire

(event! (channel-on-message *channel*) message)

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
