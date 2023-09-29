(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

(defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

(let* ((main-activity "MainActivity")
       (path-kotlin "/home/martin/stage/cl-kotlin-generator/examples/05_gl/app/src/main/java/com/example/a05_gl/MainActivity"))
  (let* ((code
	  `(do0
	    (package com.example.a05_gl)
	    ;; https://developer.android.com/develop/ui/views/graphics/opengl/environment
	    (import
	     javax.microedition.khronos.egl.EGLConfig
	     javax.microedition.khronos.opengles.GL10
	     android.opengl.GLES20
	     android.content.Context
	     android.opengl.GLSurfaceView)

	    (defclass OpenGLES20Activity ((Activity))
	      "private lateinit var gLView: GLSurfaceView"
	      (space
	       "override"
	       (defun onCreate (saved_instance_state)
		 (declare (type Bundle? saved_instance_state))
		 (super.onCreate saved_instance_state)
		 (setf gLView (MyGLSurfaceView this))
		 (setContentView gLView))))
	    (defclass MyGLRenderer (GLSurfaceView.Renderer)
	      (space "override"
	       (defun onSurfaceCreated (unused config)
		 (declare (type GL10 unused)
			  (type EGLConfig config))
		 (GLES20.glClearColor 0s0 0s0 0s0 1s0)))
	      (space "override"
	       (defun onSurfaceChanged (unused w h)
		 (declare (type GL10 unused)
			  (type Int w h))
		 (GLES20.glViewport 0 0 w h)))
	      (space "override"
		     (defun onDrawFrame (unused )
		       (declare (type GL10 unused))
		       (GLES20.glClear GLES20.GL_COLOR_BUFFER_BIT))))

	    (defclass  (MySurfaceView "context: Context") ((GLSurfaceView context))
	      (space private val "render: MyGLRenderer")
	      (space
	       init
	       (progn
		 (setEGLContextClientVersion 2)
		 (setf renderer (MyGLRenderer))
		 (setf renderMode (GLSurfaceView.RENDERMODE_WHEN_DIRTY))
		 (setRenderer renderer))))
	    )))
    (ensure-directories-exist path-kotlin)
    ;(ensure-directories-exist path-layout)
    
    (write-source path-kotlin code)
    ;(write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    
    ;(write-xml (format nil "~a/~a" path-manifest "AndroidManifest") manifest)
    #+nil (sb-ext:run-program
	   "/home/martin/Downloads/android-studio/bin/format.sh"
	   (list "-r"  path-lisp) 
	   )))
 
 
;; adb install -r /home/martin/stage/cl-kotlin-generator/examples/01_quiz/QuizActivity/app/build/outputs/apk/debug/app-debug.apk

