;;;; -*- Mode: LISP; Syntax: COMMON-LISP -*-
;;;; Copyright (C) 2008-11 by Mark <evenson.not.org@gmail.com>
;;;; Use and distribution, without any warranties, under the terms of the 
;;;; <http://www.fsf.org/copyleft/lgpl.html> is "GNU Library General Public License"

;;;; Routines to facilitate scripting Java dynamically from Armed Bear Common Lisp.
(in-package #:abcld)

(defconstant +java-null+ 
  (make-immediate-object nil :ref) 
  "A Java object containing a 'null' reference.")

(defvar *verbose* nil
  "When set, *VERBOSE* indicates the stream to log verbose messages to.")

;;; c.f. http://nklein.com/2011/04/delayed-evaluation-across-packages/
;;;
;;; The question is whether creating a closure is generally cheaper
;;; than evaluating arguments to FORMAT?
(defmacro verbose (message &rest parameters)
  `(when *verbose*
     (format *verbose* (funcall (lambda() (format nil ,message ,@parameters))))
     (finish-output *verbose*)))

;;; XXXX 
#|
	 (jnew (lookup-in-added-classpath
		"com.ontotext.wsmo4j.serializer.xml.WsmlXmlSerializer")))
	(target (abcld-jnew "java.lang.StringBuffer"))

 (abcld-introspect-instance (name-or-ref)
  
|#

(defun introspect (name-or-ref)
  ;; presumably not in default classpath
  (verbose "Type-of ~A" name-or-ref)
  (when (typep name-or-ref 'java-object)
    (class-of name-or-ref))
  (when (typep name-or-ref 'string)
    (introspect-classpath name-or-ref)))

(defun instantiate (introspected)
  (verbose "Attempting to instantiate a/an ~A." introspected)
  (let* ((fully-qualified-classname 
	  (if (jinstance-of-p introspected "java.lang.Class")
	      (#"getName" introspected)
	      introspected))
	 (hook (gethash fully-qualified-classname *instantiate-hooks*)))
    (if hook
	(funcall hook introspected)
	(warn "~&Failed to find instantiation hook for ~A." fully-qualified-classname))))

(defun introspect-classpath (name-or-ref)
  (jclass-dynamic name-or-ref))

(defun dynamic-jars ()
    (loop :for jar :in *dynamic-classpath*
       :collecting jar))

;;; XXX somehow, we have to figure out how to enumerate available classloaders
(defun jclass-dynamic (name)
  "Returns the java.lang.Class for something on CL-USER:*added-to-classpath*"
  (#"forName" 'java.lang.Class
	      name
	      nil
	      (#"getClassLoader"  (jclass "dclass.Class"))))

;;; XXX need to fix classpath for when WSML2REASONER is not driving application
(defun jenum (&optional 
	      (enum "IRIS")
	      (enum-for-name
	       "org.wsml.reasoner.api.WSMLReasonerFactory$BuiltInReasoner")
	      (key #"toString")
	      (test #'equal))
  "Return java object for ENUM from ENUM-FOR-NAME type."
  (let* ((enum-class
	  (#"forName" 'java.lang.Class
		      enum-for-name
		      nil
		      (#"getClassLoader" (jobject-class (#"getFactory"
							 'DefaultWSMLReasonerFactory)))))
	 (enum-constants (#"getEnumConstants" enum-class)))
    (find enum enum-constants :key key :test test)))

(defvar *instantiate-hooks*
  (make-hash-table :test #'equal)
  "Hash of strings representing Java classnames and their associated instantiate hooks.")

(defun add-instantiate-hook (classname hook)
  "Possibly replace string indexed CLASSNAME with an instantiate HOOK
  of the form #'(lambda (classname) ..."
  (setf (gethash classname *instantiate-hooks*)
	hook))

(defun enumerate-instantiate-hooks (&optional (hook-table *instantiate-hooks*))
  (loop 
     :for key :being :each :hash-values :of hook-table
     :collecting key))
  

;;; XXX generalize to returning different types of java.io.* interfaces
(defun jstream (file)
  "For a pathname for FILE, return a Java java.io.InputStreamReader"
  (handler-case
      (let* ((pathname (namestring (merge-pathnames file)))
	     (file-input-stream (cl-user::new 'FileInputStream pathname))
	     (input-stream-reader (cl-user::new 'InputStreamReader
						file-input-stream)))
	(verbose "Opened '~A' for read." file)
	input-stream-reader)
    ;;; XXX Fix java exception hierarchy
    (java-throwable (e)
	(error "Failed to load file '~S' because of throwable: ~A"
	       file e))
    (java-exception (e)
	(error "Failed to load file '~S' because of exception: ~A"
	       file e))))


;;; XXX
(defun jfield-static (classname field)
  (jfield (class-for-name-dynamic-classpath classname) field))

(defun jclass-dynamic (classname)
  (class-for-name-dynamic-classpath classname))

(defun class-for-name-dynamic-classpath (classname)
  (find-java-class classname))
#| Uggh.  What was I smoking?
  (flet ((dynamic-classloader (classname)
	 (#"getClassLoader" (jobject-class classname)))
	 (introspect-classloaders ()
	   "dclass,Class"))
    (#"forName" 'java.lang.Class classname nil
		(dynamic-classloader (introspect-classloaders)))))
|#

(defun jhashtable (hashtable)
  "Create a java.util.Hashtable from a HASHTABLE"
  (let ((results (new 'java.util.Hashtable)))
    (loop :for key :being :the :hash-keys :of hashtable 
       :using (hash-value value)
       do (#"put" results key value))
    results))

;;; XXX register-java-exception doensn't seem to work here, although
;;; the tests in ABCL seem to run ok.
(defmacro with-registered-exception (exception condition &body body)
  `(unwind-protect
       (progn
         (register-java-exception ,exception ,condition)
         ,@body)
     (unregister-java-exception ,exception)))

(defun jobject-public (object)
  "Return the public methods and fields of an instance of OBJECT."
  (let ((class (jobject-class object)))
    (values 
     (map 'list 
	  (lambda (method)
	    (cons (jmethod-name method)
		  (jmethod-params method)))
	  (jclass-methods class))
     (map 'list #'jfield-name  (jclass-fields class)))))
  
;; (eval-when (:load-toplevel :execute)
;;   ;; XXX ensure we are binding to the same symbol as produced by JSS
;;   (setf *dynamic-classpath* cl-user::*added-to-classpath*))

(defmacro jclass-name-string (object)
  `(first (multiple-value-list (java::jclass-of ,object))))

;;; Properly, this should be a patch to lsw/jss
(in-package :asdf)
(defmethod source-file-type ((c jar-file) (s module)) "jar")

(in-package :abcld)
(defun jarray-from-list (list)
  "Return a Java array from a list of objects, possibly looking on the
JSS dynamic classpath."
  (let ((class (jobject-class (first list))))
    (java::jnew-array-from-list class list)))

