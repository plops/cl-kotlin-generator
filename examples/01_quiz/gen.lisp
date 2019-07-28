(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)




(let* ((main-activity "MainActivity")
       (title "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp title
			    (string-downcase title)))
       (path-layout (format nil "~a/~a/app/src/main/res/layout/"
			    path-lisp title))
       ;FirstGame/app/src/main/res/layout/content_main.xml
       ;FirstGame/app/src/main/res/values/strings.xml

       )
  (let* ((layout
	  `
	  (do0
	   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   (androidx.constraintlayout.widget.ConstraintLayout
	    :xmlns.android "http://schemas.android.com/apk/res/android"
	    :xmlns.app "http://schemas.android.com/apk/res-auto"
	    :xmlns.tools "http://schemas.android.com/tools"
	    :android.layout_width match_parent
	    :android.layout_height match_parent
	    :tools.context .MainActivity
					;:android.gravity center
					;:android.orientation vertical
	    (TextView
	     :android.id "@+id/textview"
	     :android.layout_width wrap_content
	     :android.layout_height wrap_content
	     :android.padding 24dp
	     :android.text "Hello World!"
	     :app.layout_constraintBottom_toBottomOf parent
	     :app.layout_constraintLeft_toLeftOf parent
	     :app.layout_constraintRight_toRightOf parent
	     :app.layout_constraintTop_toTopOf parent
	     )
	    ,@(loop for (e pos) in `((true left) (false right))
		 collect
		 `(Button
		  :android.layout_width wrap_content
		  :android.layout_height wrap_content
		   
		  ,@(if (eq pos 'left)
			`(:app.layout_constraintLeft_toLeftOf parent)
			`(:app.layout_constraintLeft_toRightOf "@+id/true_button"))
		  
		  ,@(if (eq pos 'left)
			`(:app.layout_constraintRight_toLeftOf "@+id/false_button")
			`(:app.layout_constraintRight_toRightOf parent))
		  :app.layout_constraintTop_toBottomOf "@+id/textview"
		  :android.text ,(format nil "~a" e)
		  :android.id ,(format nil "@+id/~a_button" e)
		  )))))
	 (code
	     `(do0
	       (package com.example.quizactivity)
	       (import ;android.content.Intent
		       android.os.Bundle
		       androidx.appcompat.app.AppCompatActivity
		       android.util.Log.d
		       kotlinx.android.synthetic.main.activity_main.*
		       ;kotlinx.android.synthetic.main.content_main.*
		       )
	       #+nil (defclass FriendsAdapter ((RecyclerView.Adapter<FriendsAdapter.ViewHolder>))
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
			     ;(setSupportActionBar toolbar)
			     ))
		 )
	       )))
    (ensure-directories-exist path-kotlin)
    (ensure-directories-exist path-layout)

    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    #+nil (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  path-lisp)
	)))
 
