;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
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
	       (:file "abcl")))))

(defsystem :abcl-dynamic-test
    :name "org.not.abcl.test"
    :depend-on (:lisp-unit)
    :components
    ((:module java :pathname "test"
	      :components 
	      ((:file "not.org.lisp")))))



