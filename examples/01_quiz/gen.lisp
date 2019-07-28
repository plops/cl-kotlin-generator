(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)




(let* ((main-activity "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp main-activity
			    (string-downcase main-activity)))
       (path-layout (format nil "~a/~a/app/src/main/res/layout/"
			    path-lisp main-activity))
       ;FirstGame/app/src/main/res/layout/content_main.xml
       ;FirstGame/app/src/main/res/values/strings.xml

       )
  (let* ((layout
	  `(LinearLayout
	    :xmls.android "http://schemas.android.com/apk/res/android"
	    :android.layout_width match_parent
	    :android.layout_height match_parent
	    :android.gravity center
	    :android.orientation vertical
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
	 (code
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
    (ensure-directories-exist path-layout)

    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout main-activity) layout)
    #+nil (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  path-lisp)
	)))
 
