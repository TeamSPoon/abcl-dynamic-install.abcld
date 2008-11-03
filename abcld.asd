;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008 by Mark <evenson.not.org@gmail.com>
;;;; Use and distribution, without any warranties, under the terms of the 
;;;; <http://www.fsf.org/copyleft/lgpl.html> is "GNU Library General Public License" .

#-abcl (error "Sorry. This ASDF package won't work on any CL other than the Bear.")

(defpackage :abcld-asdf (:use :cl :asdf))
(in-package :abcld-asdf)

(defsystem :abcld
    :name "org.not.recursive.abcl.dynamic.install"
    :version "20081103"
    :depends-on (:jss) 
    :components
    ((:module java :pathname ""
	      :serial t
	      :components 
	      ((:file "packages")
	       (:file "abcld")))))




