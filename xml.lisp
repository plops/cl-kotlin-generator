(in-package :cl-kotlin-generator)

(defun write-xml (name code &optional (dir (user-homedir-pathname))
				 ignore-hash)
  (let* ((fn (merge-pathnames (format nil "~a.xml" name)
			      dir))
	(code-str (emit-xml
		   :code code))
	(fn-hash (sxhash fn))
	 (code-hash (sxhash code-str)))
    (format t "write xml to ~a" fn)
    (multiple-value-bind (old-code-hash exists) (gethash fn-hash *file-hashes*)
     (when (or (not exists) ignore-hash (/= code-hash old-code-hash))
       ;; store the sxhash of the c source in the hash table
       ;; *file-hashes* with the key formed by the sxhash of the full
       ;; pathname
       (setf (gethash fn-hash *file-hashes*) code-hash)
       (with-open-file (s fn
			  :direction :output
			  :if-exists :supersede
			  :if-does-not-exist :create)
	 (write-sequence code-str s))
       ;; https://medium.com/@VeraKern/formatting-xml-layout-files-for-android-47aec62722fc
       ;; https://www.jetbrains.com/help/idea/command-line-formatter.html
       #+nil
       (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  (namestring fn))
	)
       (sb-ext:run-program
	"/usr/bin/xmllint"
	(list "--format"  (namestring fn) "--output"  (namestring fn))
	)))))

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
		(do0 (with-output-to-string (s)
		       ;; do0 {form}*
		       ;; write each form into a newline
		       (format s "~&~a~{~&~a~}"
			       (emit (cadr code))
			       (mapcar #'emit (cddr code)))))
		
		; (string (format nil "\"~a\"" (cadr code)))
		;; maybe i can collect references to strings here
		(t (destructuring-bind (name &rest args) code
		     (multiple-value-bind (pairs rest) (split-keyword-pairs args)
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
