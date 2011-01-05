(defparameter *systems*
  (let ((hashtable (make-hash-table)))
    (setf (gethash :alexandria hashtable)
	  `(:uri "git://common-lisp.net/projects/alexandria/alexandria.git" 
		 :last-accessed 20110103))
    (setf (gethash :bordeaux-threads hashtable)
	 `(:uri "git://common-lisp.net/r/projects/bordeaux-threads/bordeaux-threads.git"
		:patch-uri "http://slack.net/~evenson/abcl/bordeaux-threads-abcl-20101204a.diff"
		:last-accessed 20110103))
    hashtable))

(defgeneric install ((asdf:system


