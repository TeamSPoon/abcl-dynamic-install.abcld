;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008 by Mark <evenson.not.org@gmail.com>
;;;; Use and distribution, without any warranties, under the terms of the 
;;;  GNU Library General Public License, readable in http://www.fsf.org/copyleft/lgpl.html
(in-package :org.not.recursive.java.bytecode)

;;;; Tanatlizingly not-working, huh?  visit urn:recursive.not.org for cannonical source

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
