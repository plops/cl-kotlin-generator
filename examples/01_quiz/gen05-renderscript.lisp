(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://www.youtube.com/watch?v=uzBw6AWCBpU
;; Google I/O 2013 - High Performance Applications with RenderScript

;; https://www.youtube.com/watch?v=kybZnFQh6fE
;; Using RenderScript in Android Studio in 8 min

;; https://youtu.be/LNNyVVLk-ms?t=1268
;; Practical Image Processing in Android

;; https://developer.android.com/guide/topics/renderscript/compute

;; use native renderscript api (not support library api). it is the
;; more modern version and leads to smaller apk's

;; Renderscript: parallel computing on android, the easy way

;; change gradle app
;; Android.defaultconfig.renderscriptTargetApi 18




(let* ((main-activity "MainActivity")
       (title "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp title
			    (string-downcase title)))
       (path-layout (format nil "~a/~a/app/src/main/res/layout/"
			    path-lisp title))
       (path-manifest (format nil "~a/~a/app/src/main/"
			    path-lisp title))

       
       ;FirstGame/app/src/main/res/layout/content_main.xml
       ;FirstGame/app/src/main/res/values/strings.xml
       ;QuizActivity/app/src/main/AndroidManifest.xml
       
       )
  (let* ((manifest
	  `(do0
	   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   (manifest
	    :xmlns.android "http://schemas.android.com/apk/res/android"
	    :package com.example.quizactivity
	    (uses-feature
	     :android.name android.hardware.camera
	     :android.required true )
	    (application
	     :android.allowBackup true
	     :android.icon @mipmap/ic_launcher
	     :android.roundIcon @mipmap/ic_launcher_round
	     :android.supportsRtl true
	     :android.theme @style/AppTheme
	     (activity
	      :android.name .MainActivity
	      (intent-filter
	       (action :android.name android.intent.action.MAIN)
	       (category :android.name android.intent.category.LAUNCHER)))))
	   ))
	 (layout
	  `(do0
	   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   (androidx.constraintlayout.widget.ConstraintLayout
	    :xmlns.android "http://schemas.android.com/apk/res/android"
	    :xmlns.app "http://schemas.android.com/apk/res-auto"
	    :xmlns.tools "http://schemas.android.com/tools"
	    :android.layout_width match_parent
	    :android.layout_height match_parent
	    :tools.context com.example.quizactivity.MainActivity
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
	     ))))
	 (code
	     `(do0
	       (package com.example.quizactivity)
	       (import


		androidx.appcompat.app.AppCompatActivity
		android.util.Log.d

		android.renderscript.*
		
		android.os.Bundle

		android.content.Context
		
		       )


	       (defclass MainActivity ((AppCompatActivity)
				       
				       )
		 
		 ,@(loop for e in `((Create ((savedInstanceState Bundle?))
					    (do0
					     
					     (setContentView R.layout.activity_main)
					     (example)
					     ))
				    
				    (SaveInstanceState ((savedInstanceState Bundle))
						       )
				    (PostCreate ((savedInstanceState Bundle?)))
				    (Destroy)
				    (Start)
				    (Stop)
				    (PostResume)
				    (Resume )
				    (Pause ))
		      collect
			(destructuring-bind (name-no-on &optional params extra) e
			  (let ((name (format nil "on~a" name-no-on)))
			   `(override (defun ,name (,@(mapcar #'first params))
					,@(loop for (var type) in params collect
					       `(declare (type ,type ,var)))
					(dot super (,name ,@(mapcar #'first params)))
					(d (string "martin") (string ,(format nil "~a" name)))
					,(if extra
					     extra
					     "// none"))))))
		 (do0 "private"
		  (defun example ()
		    (let ((_rs (RenderScript.create this))
			  (input_array (intArrayOf ,@(loop for i below 9 collect i)))
			  (input_alloc (lambda ()
					 (declare (values Allocation))
					 (let ((res (Allocation.createSized
						     _rs
						     (Element.I32 _rs)
						     input_array.size)))
					   (res.copyFrom input_array)
					   (return res))))
			  (output_array (IntArray input_array.size))
			  (output_alloc (Allocation.createSized _rs
								(Element.I32 _rs)
								input_array.size))
			  (myscript (ScriptC_sum _rs))
			  )
		      (myscript.forEach_sum2 input_alloc output_alloc)
		      (d (string "martin")
			 (string ,(format nil "output ~{~a~^, ~}"
					  (loop for i below 9 collect (format nil "{$output_array[~a]}" i)))))
		      )))

		 ))))
    (ensure-directories-exist path-kotlin)
    (ensure-directories-exist path-layout)
 
    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    
    (write-xml (format nil "~a/~a" path-manifest "AndroidManifest") manifest)
    #+nil (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  path-lisp) 
	)))
 
 
