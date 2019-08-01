(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://stackoverflow.com/questions/8210264/sync-android-devices-via-gps-time 

(let* ((main-activity "MainActivity")
       (title "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp title
			    (string-downcase title)))
       (path-layout (format nil "~a/~a/app/src/main/res/layout/"
			    path-lisp title))
       (path-manifest (format nil "~a/~a/app/src/main/"
			    path-lisp title)))
  (let* ((manifest
	  `(do0
	   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   (manifest
	    :xmlns.android "http://schemas.android.com/apk/res/android"
	    :package com.example.quizactivity
	    (uses-feature
	     :android.name android.hardware.location.gps
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

		android.os.Bundle
		java.lang.System.currentTimeMillis
		android.location.LocationManager
		android.location.OnNmeaMessageListener
		android.content.Context
		)
	       (defclass MainActivity ((AppCompatActivity)
				       
				       )
		 "private lateinit var _location_manager : LocationManager"
		 ,@(loop for e in
			`((Create ((savedInstanceState Bundle?))
				  (do0
				   (setContentView R.layout.activity_main)
				   (setf _location_manager (as (getSystemService Context.LOCATION_SERVICE)
							       LocationManager))
				   
				   (let ((now (currentTimeMillis)))
				     (d (string "martin")
					(string "now = ${now}")))))
				    
				    (SaveInstanceState ((savedInstanceState Bundle)))
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
 
 
