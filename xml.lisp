(in-package :cl-kotlin-generator)
(defun keyword-to-xml (v)
  "convert :android.padding to android:padding"
  (substitute #\: #\. (format nil "~a" v)))

(defun split-keyword-pairs (ls)
  "search through ls collect all keyword value pairs, and return with the remaining stuff; replace . with : in keywords"
  (let ((pairs nil)
	(last-index -1))
    (loop named collect-pairs for i from 0 by 2 do
	 (if (and
	      (< i (length ls))
	      (keywordp (elt ls i)))
	     (push (list (keyword-to-xml (elt ls i)) (elt ls (+ i 1))) pairs)
	     (progn
	       (setf last-index i)
	       (return-from collect-pairs))))
    (values pairs (subseq ls last-index))
   ))

(defun emit-xml (&key code (str nil))
   (flet ((emit (code)
	    (emit-xml :code code)))
      (if code
	  (if (listp code)
	      (case (car code)
		; (string (format nil "\"~a\"" (cadr code)))
		;; maybe i can collect references to strings here
		(t (destructuring-bind (name &rest args) code
		     (multiple-value-bind (pairs rest) (split-keyword-pairs args)
		       (format t "~&bla ~a~%" rest)
		       (format str "~&<~a ~{~&~a~^ ~}>~{~a~}~&</~a>"
			       name
			       (mapcar #'(lambda (x)
					   (destructuring-bind (a b) x
					     (format nil "~a=\"~a\"" a b)))
				       pairs)
			       (mapcar #'emit rest)
			       name)))))
	      (cond
		
		((or (symbolp code)
		     (stringp code)) ;; print variable
		 (format nil "~a" code))
		((numberp code) ;; print constants
		 (cond ((integerp code) (format str "~a" code))
		       ((floatp code) 
			(format str "~a" (print-sufficient-digits-f64 code)))))))
	  "")) )
