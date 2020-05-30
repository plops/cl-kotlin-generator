(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

(let* ((main-activity "MainActivity")
       (path-kotlin "/home/martin/stage/cl-kotlin-generator/examples/02_jetpack_compose/app/src/main/java/com/example/a02_jetpack_compose/MainActivity"))
  (let* ((code
	  `(do0
	    (package com.example.a02_jetpack_compose)
	    (import
	     android.os.Bundle
	     androidx.appcompat.app.AppCompatActivity
	     androidx.compose.Composable
	     androidx.ui.core.setContent
	     androidx.ui.core.Modifier
	     androidx.ui.foundation.Text
	     androidx.ui.layout.Column
	     androidx.ui.layout.padding
	     androidx.ui.unit.dp
	     androidx.ui.tooling.preview.Preview
					;com.example.a02_jetpack_compose.ui.AppTheme

	     ;; use Alt+Enter on red tokens in android studio to get proposals for the import
	     )

	    


	    (defclass MainActivity ((AppCompatActivity))
	      (space
	       "override"
		 (defun onCreate (saved_instance_state)
		   (declare (type Bundle? saved_instance_state))
		   (super.onCreate saved_instance_state)
		   (space
		    setContent
		    (progn
		      (NewsStory)
		      ;(Greeting (string "Android"))
		      )))))
	    
	    (do0
	     (space
	      "@Composable"
	      (defun Greeting (name)
		(declare (type String name))
		(Text (string "Hello $name!")))
	      )
	     (space
	      "@Preview"
	      "@Composable"
	      (defun PreviewGreeting ()
		(Greeting (string "Android")))))

	    (do0
	     (space
	      "@Composable"
	      (defun NewsStory ()
		(space (Column :modifier (Modifier.padding 16.dp))
		       (progn
			,@(loop for e in `("a day in shark fin cove"
					   "davenport california"
					   "dec 2018")
			     collect
			       `(Text (string ,e)))))))
	     (space
	      "@Preview"
	      "@Composable"
	      (defun PreviewNewsStory ()
		(NewsStory))))

	    
	    )))
    ;(ensure-directories-exist path-kotlin)
    ;(ensure-directories-exist path-layout)
    
    (write-source path-kotlin code)
    ;(write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    
    ;(write-xml (format nil "~a/~a" path-manifest "AndroidManifest") manifest)
    #+nil (sb-ext:run-program
	   "/home/martin/Downloads/android-studio/bin/format.sh"
	   (list "-r"  path-lisp) 
	   )))
 
 
;; adb install -r /home/martin/stage/cl-kotlin-generator/examples/01_quiz/QuizActivity/app/build/outputs/apk/debug/app-debug.apk

