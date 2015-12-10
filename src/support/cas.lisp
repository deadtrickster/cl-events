(in-package :cl-events)

(defmacro cas (place old new &environment env)
  (declare (ignorable env))
  (check-type old symbol)
  ;; macroexpand is needed for sbcl-1.0.53 and older
  #+sbcl `(eq ,old (sb-ext:compare-and-swap ,place
                                            ,old ,new))
  #+ccl `(ccl::conditional-store ,place ,old ,new)
  #+lispworks `(sys:compare-and-swap ,place ,old ,new))
