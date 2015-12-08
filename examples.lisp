
(defclass connection ()
  (on-open
   on-message
   on-close))

(defgeneric add-event-handler (sink handler &key &allow-other-keys))
(defgeneric remove-event-handler (sink handler))

(defgeneric invoke-event-handler (executor &rest args))

(event+ (connection-on-open) (lambda ()))
(event- (connection-on-open) (lambda ()))
(event! (connection-on-open) "arg1" "arg2")



(add-event-handler (connection-on-open) (lambda ()))
(add-event-handler (connection-on-message) (lambda ()) :tag :client1)
(add-event-handler (connection-on-message) (lambda ()) :tag :client1)
(add-event-handler (connection-on-message) (lambda ()) :tag :client2)
(add-event-handler (connection-on-message) (lambda ()) :tag :client3)
(add-event-handler (connection-on-close) (lambda ()))

(remove-event-handler (connection-on-open) (lambda ()))
(remove-event-handler (connection-on-messsage) :client1)


(invoke-event-handler (connection-on-messsage) "arg1" "arg2" "arg3")
