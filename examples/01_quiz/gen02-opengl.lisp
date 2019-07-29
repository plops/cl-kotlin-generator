(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)



;; https://developer.android.com/training/graphics/opengl/environment.html#kotlin
;; https://developer.android.com/training/graphics/opengl
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
	     )
	    ,@(loop for (e pos) in `((true left) (false right))
		 collect
		 `(Button
		  :android.layout_width wrap_content
		  :android.layout_height wrap_content
		   
		  ,@(if (eq pos 'left)
			`(:app.layout_constraintLeft_toLeftOf parent)
			`(:app.layout_constraintLeft_toRightOf "@id/true_button"))
		  
		  ,@(if (eq pos 'left)
			`(:app.layout_constraintRight_toLeftOf "@id/false_button")
			`(:app.layout_constraintRight_toRightOf parent))
		  :app.layout_constraintTop_toBottomOf "@id/textview"
		  :android.text ,(format nil "~a" e)
		  :android.id ,(format nil "@+id/~a_button" e)
		  )))))
	 (code
	     `(do0
	       (package com.example.quizactivity)
	       (import
		android.os.Bundle
		android.view.View
		       androidx.appcompat.app.AppCompatActivity
		       android.util.Log.d
		       kotlinx.android.synthetic.main.activity_main.*
		       
		       android.content.Context
		       android.opengl.GLSurfaceView

		       javax.microedition.khronos.egl.EGLConfig
		       javax.microedition.khronos.opengles.GL10

		       android.opengl.GLES20
		       
		       
		       )


	       (defclass MainActivity ((AppCompatActivity))
		 (let-var ((_count 0)))
		 "private lateinit var _gl_view: GLSurfaceView"
		 ,@(loop for e in `((Create ((savedInstanceState Bundle?))
					    (do0
					     (unless (== savedInstanceState null)
					       (setf _count (savedInstanceState?.getInt (string "_count") 0)))
					     ;;(setContentView R.layout.activity_main)
					     ;;(setSupportActionBar toolbar)
					     (setf _gl_view (MyGLSurfaceView this))
					     (setContentView _gl_view)
					     #+nil (true_button.setOnClickListener
					      (lambda (view)
						(declare (type View? view))
						(d (string "martin")
						   (string "true_button clicked!"))))))
				    (SaveInstanceState ((savedInstanceState Bundle))
						       (savedInstanceState.putInt (string "_count") _count))
				    (PostCreate ((savedInstanceState Bundle?)))
				    (Destroy)
				    (Start)
				    (Stop)
				    (PostResume)
				    (Pause))
		      collect
			(destructuring-bind (name-no-on &optional params extra) e
			  (let ((name (format nil "on~a" name-no-on)))
			   `(override (defun ,name (,@(mapcar #'first params))
					,@(loop for (var type) in params collect
					       `(declare (type ,type ,var)))
					(dot super (,name ,@(mapcar #'first params)))
					(incf _count)
					(d (string "martin") (string ,(format nil "~a {$_count}" name)))
					,(if extra
					     extra
					     "// none"))))))
		 )

	       (defclass MyGLRenderer (GLSurfaceView.Renderer)
		 (override (defun onSurfaceCreated (unused config)
			     (declare (type GL10 unused)
				      (type EGLConfig config))
			     (GLES20.glClearColor .2f 0.0f 0.0f 1.0f)))
		 (override (defun onDrawFrame (unused)
			     (declare (type GL10 unused))
			     (GLES20.glClear GLES20.GL_COLOR_BUFFER_BIT)))
		 (override (defun onSurfaceChanged (unused width height)
			     (declare (type GL10 unused)
				      (type Int width height))
			     (GLES20.glViewport 0 0 width height))))
	       
	       (defclass (MyGLSurfaceView "context: Context")
		   ((GLSurfaceView context))
		 "private val _renderer: MyGLRenderer"
		 "init"
		 (progn
		   (setEGLContextClientVersion 2)
		   (setf _renderer (MyGLRenderer))
		   (setRenderer _renderer)))
	       

	       )))
    (ensure-directories-exist path-kotlin)
    (ensure-directories-exist path-layout)
 
    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    #+nil (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  path-lisp) 
	)))
 
