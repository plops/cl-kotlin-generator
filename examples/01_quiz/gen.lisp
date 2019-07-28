(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

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


(split-keyword-pairs `(
		       :android.layout_width wrap_content
					     :android.layout_height wrap_content
					     :android.padding 24dp
					     :android.text @string/question_text
					     (Button
					      :android.layout_width wrap_content
					      :android.layout_height wrap_content
					      :android.text @string/true_button
					      )
					     (Button
					      :android.layout_width wrap_content
					      :android.layout_height wrap_content
					      :android.text @string/false_button)))

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
		       (format str "<~a ~{~&~a~^ ~}>~&~@[~a~]~&</~a>"
			       name
			       (mapcar #'(lambda (x)
					   (destructuring-bind (a b) x
					     (format nil "~a=\"~a\"" a b)))
				       pairs)
			       (mapcar #'emit rest) name)))))
	      (cond
		
		((or (symbolp code)
		     (stringp code)) ;; print variable
		 (format nil "~a" code))
		((numberp code) ;; print constants
		 (cond ((integerp code) (format str "~a" code))
		       ((floatp code) 
			(format str "~a" (print-sufficient-digits-f64 code)))))))
	  "")) )

(emit-xml :code
 `(LinearLayout
  :xmls.android "http://schemas.android.com/apk/res/android"
  :android.layout_width match_parent
  :android.layout_height match_parent
  :android.gravity center
  :android.orientation vertical
 (Button)
  (TextView
   :android.layout_width wrap_content
   :android.layout_height wrap_content
   :android.padding 24dp
   :android.text @string/question_text
   (Button
    :android.layout_width wrap_content
    :android.layout_height wrap_content
    :android.text @string/true_button
    )
   (Button
    :android.layout_width wrap_content
    :android.layout_height wrap_content
    :android.text @string/false_button))))


(let* ((main-activity "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp main-activity
			    (string-downcase main-activity)))
       )
  (let* ((code
	  `(do0
		     (package com.example.firstgame)
		     (import android.content.Intent
			     android.os.Bundle
			     androidx.appcompat.app.AppCompatActivity
			     android.util.Log.d
			     kotlinx.android.synthetic.main.activity_main.*
			     kotlinx.android.synthetic.main.content_main.*
			     )
		     (defclass FriendsAdapter ((RecyclerView.Adapter<FriendsAdapter.ViewHolder>))
		       (override (defun onCreateViewHolder (parent viewType)
				   (declare (type ViewGroup parent)
					    (type int viewType)
					    (values ViewHolder))
				   (let ((view (dot
						(LayoutInflater.from
						 parent.context)
						(inflate R.layout.row_friend
							 parent
							 false))))
				     (return (ViewHolder view)))))
		       
		       )
		     (defclass MainActivity ((AppCompatActivity))
		       (override (defun onCreate (savedInstanceState)
				   (declare (type Bundle? savedInstanceState))
				   (super.onCreate savedInstanceState)
				   (setContentView R.layout.activity_main)
				   (setSupportActionBar toolbar)
				   ))
		       )
		     )))
    (ensure-directories-exist path-kotlin)
    (write-source (format nil "~a/~a" path-kotlin main-activity) code)))
