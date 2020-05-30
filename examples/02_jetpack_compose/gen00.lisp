(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

(let* ((main-activity "MainActivity")
       (path-kotlin "/home/martin/stage/cl-kotlin-generator/examples/02_jetpack_compose/app/src/main/java/com/example/a02_jetpack_compose/MainActivity"))
  (let* ((code
	  `(do0
	    (package com.example.a02_jetpack_compose)
	    (imports (androidx.ui.layout Column padding Spacer preferredHeight fillMaxSize)
		     (androidx.ui.core setContent Modifier)
		     (androidx.ui.foundation Text Canvas) 
		     (androidx.ui.material MaterialTheme)
		     (androidx.ui.geometry Offset)
		     (androidx.ui.graphics Paint Color Path)
		     (androidx.ui.text.style TextOverflow))
	    (import
	     android.os.Bundle
	     androidx.appcompat.app.AppCompatActivity
	     androidx.compose.Composable
	     
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
		(space MaterialTheme
		 (progn
			(space (Column :modifier (Modifier.padding 16.dp))
			       (progn
				 (Text (string "title atisrnt iasto aesnt arnstiea atansr enosrietan einsrt oaiesnt ars inoanesr tas astie na rienstodypbv kp vienkvtk ae nrtoanr arstioenasirn taoist oiasntinaie")
					:style MaterialTheme.typography.h2
				       :maxLines 2
				       :overflow TextOverflow.Ellipsis)
				 (Spacer (Modifier.preferredHeight 16.dp))
				 ,@(loop for e in `("a day in shark fin cove" 
						    "davenport california" 
						    "dec 2018")
				      collect
					`(Text (string ,e)
					       :style MaterialTheme.typography.body2
					       ))))
			(let ((paint (Paint)))
			  (setf paint.color (Color #xFF0000FF))
			  (space (Canvas :modifier (Modifier.fillMaxSize))
				(progn
				  (drawCircle :center (Offset 50f 500f)
					      :radius 40f
					      :paint paint)
				  (let ((path (Path))
					(paint_path (Paint)))
				    (setf paint_path.color Color.Red)
				    (path.moveTo 50f 500f)
				    (path.lineTo 55f 550f)
				    (path.lineTo 105f 650f)
				    (path.lineTo 305f 1250f)
				    (drawPath :path path
					      :paint paint_path)))))))))
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

