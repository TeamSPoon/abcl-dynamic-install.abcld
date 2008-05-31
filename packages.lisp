;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008 by Mark <evenson.not.org@gmail.com.
;;;; Use and distribution, without any warranties, under the terms of the 
;;;  GNU Library General Public License, readable in http://www.fsf.org/copyleft/lgpl.html

(defpackage :abcld
  (:use :common-lisp
	:java)
  (:import-from :cl-user 

		;;; polluted by JSS
		*added-to-classpath*
		:new
		:find-java-class
		:get-java-field

		;;; XXX Don't know why this isn't exported
		;;; Originially from ABCL's JAVA package
		:jmethod :jobject-class :jfield-raw)
  (:export 
   ;;; control abstractions for unpackaged JSS 
   *added-to-classpath*
   :new
   :find-java-class
   :get-java-field

   :jmethod :jobject-class :jfield-raw

   #:get-java-field

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
   
   #:find-java-class
   #:jobject-public
   )
)

(defpackage :org.not.abcl.test
  (:use :common-lisp
	:abcld))

(in-package #:abcld)

