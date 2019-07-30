(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://developer.android.com/training/camerax/architecture
;; i want to capture images and perform processing on the cpu
;; image analysis

;; we can also access the camera image using the gpu
;; https://stackoverflow.com/questions/44048389/draw-text-or-image-on-the-camera-stream-glsl

;; low level
;; https://developer.android.com/reference/android/hardware/camera2/package-summary
;; apparently google introduced camerax because different manufacturers had quirks
;; camerax abstracts them away

;; this code is based on:
;; https://codelabs.developers.google.com/codelabs/camerax-getting-started/#3

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
	       (category :android.name android.intent.category.LAUNCHER)))))))
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
	    (TextureView
	     :android.id "@+id/view_finder"
	     :android.layout_width 640px
	     :android.layout_height 640px
	     :android.padding 24dp
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
		android.view.View
		androidx.lifecycle.LifecycleOwner
		android.view.TextureView
		;android.content.Context
		)

	       (defclass MainActivity ((AppCompatActivity)
					LifecycleOwner)
		 ,@(loop for e in `((Create ((savedInstanceState Bundle?))
					    (do0
					     (setContentView R.layout.activity_main)
					     (setf _view_finder (findViewById R.id.view_finder))
					     (_view_finder.post
					      (lambda ()
						(startCamera)))
					     ;; View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom
					     (_view_finder.addOnLayoutChangeListener
					      (lambda (v left top right bottom
						       lefto topo righto bottomo
						       )
						(declare (type View v)
							 (type Int left top right bottom
						       lefto topo righto bottomo
						       ))
						(updateTransform)))))
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
		 "private lateinit var _view_finder : TextureView"
		 "private"

		 (defun startCamera ()
		   )

		 (defun updateTransform ()
		   )
		 
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
 
 
