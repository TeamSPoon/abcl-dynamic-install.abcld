;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008-11 by Mark <evenson.not.org@gmail.com>
;;;; Use and distribution, without any warranties, under the terms of the 
;;;; <http://www.fsf.org/copyleft/lgpl.html> is "GNU Library General Public License"


(in-package :abcld-asdf)
(defvar *abcl-java-imports* '(:jmethod :jobject-class :jfield-raw))

(defpackage :abcld
  (:use :common-lisp
	:java)
  (:import-from :cl-user 

		;;; polluted by JSS
		*added-to-classpath*
		:new
		:find-java-class
		:get-java-field

                :invoke

		;;; XXX Don't know why this isn't exported
		;;; Originially from ABCL's JAVA package
		:jmethod :jobject-class :jfield-raw)
  (:export 
   ;;; control abstractions for unpackaged JSS 
   *added-to-classpath*
   :new
   :find-java-class
   :get-java-field

   :invoke

   :jmethod :jobject-class :jfield-raw

   :jclass-name-string

   :get-java-field

   :verbose *verbose*

   :jenum
   +java-null+
   :introspect

   :instantiate

   :add-instantiate-hook

   :jstream
   :jfield-static 
   :jclass-dynamic
   
   :with-registered-exception
   
   :find-java-class
   :jobject-public

   :jarray-from-list))

