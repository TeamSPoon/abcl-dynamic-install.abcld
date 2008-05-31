;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008 by Mark <evenson.not.org@gmail.com.
;;;; Use and distribution, without any warranties, under the terms of the 
;;;  GNU Library General Public License, readable in http://www.fsf.org/copyleft/lgpl.html
#-abcl (error "Sorry. This ASDF package won't work on any CL other than the Bear.")

(defsystem :abcld
    :name "org.not.recursive.abcl.dynamic.install"
    :version "20080102"
    :depends-on (:jss) 
    :components
    ((:module java :pathname ""
	      :serial t
	      :components 
	      ((:file "packages")
	       (:file "abcld")))))

(defsystem :abcl-dynamic-test
    :name "org.not.abcl.test"
    :depend-on (:lisp-unit)
    :components
    ((:module java :pathname "test"
	      :components 
	      ((:file "not.org.lisp")))))



