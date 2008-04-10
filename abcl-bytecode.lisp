(in-package :org.not.recursive.java.bytecode)
;;;; $Id$

(defun fib (n)
  "Return the nth Fibonacci number."
  (if (< n 1)
      1
      (+ (fib (- n 1)) (fib (- n 2)))))


#:+abcl 
(defun get-class (function)
  (read-classfile (jarray-byte->string (get-class-bytes function))))

#:+abcl
(defun get-class-bytes (function) 
   (getf (system:function-plist function) 'system:class-bytes))

#:+abcl
(defun jarray-byte->string (array)
  (loop :for i :from 0 :to (- (java:jarray-length array) 1)
     :collecting (code-char (signed-byte->unsigned (java:jarray-ref array i)))
     :into result
     :finally (return (coerce result 'string))))
  

(defun signed-byte->unsigned (b) 
  (if (< b 0)
      (+ (- 128 (abs b)) 128)
      b))
