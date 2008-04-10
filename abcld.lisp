(defpackage :abcld
  (:use :common-lisp
	:java)
  (:export 

   ;;; control abstractions for unpackaged JSS 
   #:get-java-field
   #:new

   #:verbose *verbose*

   #:jenum
   +java-null+
   #:introspect

   #:instantiate

   #:add-instantiate-hook

   #:jstream
   #:jfield-static 
   #:jclass-dynamic
   
   #:jhashtable

   #:with-registered-exception
   )
)

(defpackage :org.not.abcl.test
  (:use :common-lisp
	:abcld))



(in-package #:abcld)

