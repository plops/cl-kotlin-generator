(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

(defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

(let* ((main-activity "MainActivity")
       (path-kotlin "/home/martin/stage/cl-kotlin-generator/examples/02_jetpack_compose/app/src/main/java/com/example/a02_jetpack_compose/MainActivity"))
  (let* ((code
	  `(do0
	    (package com.example.a02_jetpack_compose)
	    (imports (androidx.ui.layout Column padding Spacer preferredHeight fillMaxSize)
		     (androidx.ui.core setContent Modifier)
		     (androidx.ui.foundation Text Canvas) 
		     (androidx.ui.material MaterialTheme TopAppBar Button)
		     (androidx.ui.geometry Offset)
		     (androidx.ui.graphics Paint Color Path PaintingStyle)
		     (androidx.ui.text.style TextOverflow)
		     (androidx.compose Model Composable state MutableState)
		     (androidx.activity.result.contract ActivityResultContracts )
		     (com.android.volley Request Response)
		     #+volley (com.android.volley.toolbox Volley StringRequest)
		     )
	    (import
	     android.Manifest
	     android.os.Bundle
	     androidx.appcompat.app.AppCompatActivity
	     
	     
	     androidx.ui.unit.dp
	     androidx.ui.tooling.preview.Preview
					;com.example.a02_jetpack_compose.ui.AppTheme

	     ;; use Alt+Enter on red tokens in android studio to get proposals for the import
	     )

	    

	    (defclass MainActivity ((AppCompatActivity))
	      ;(let (("have_internet_permission_p: MutableState<Int>" (space state (progn 0)))))
	      
	      
	      
	      (let (("responseState: MutableState<String>" (space state (progn (string ""))))))
	      (space
	       "override"
	       (defun onCreate (saved_instance_state)
		 (declare (type Bundle? saved_instance_state))
		 (super.onCreate saved_instance_state)
		 
		 #+volley (let ((queue (Volley.newRequestQueue this))
		       (url (string "https://api.nasdaq.com/api/quote/ASML/info?assetclass=stocks"))
		       (stringRequest (StringRequest
				       Request.Method.GET
				       url
				       (space Response.Listener<String>
					      (progn
						"response ->"
						(setf responseState.value response)
						))
				       (space Response.ErrorListener
					      (progn
						
						))))))


		 #+nil (let ((requestPermissions
		     (space (registerForActivityResult (ActivityResultContracts.RequestPermissions)
						       
						       )
			    (progn "result ->"
				   (aref result (dot Manifest permission INTERNET))
				       
				 ;(setf have_internet_permission_p.value 1)
				 ;(setf have_internet_permission_p.value 0)
				 )))))
		 
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
	     (space @Model
		    data
		    class
		    (Counter "var value: Int = 0"))
	     (space
	      "@Composable"
	      (defun NewsStory ()
		(let (("counter_state: MutableState<Int>" (space state (progn 0)))
		      (counter2 (Counter)))
		 (space MaterialTheme
			(progn
			  (space (Column :modifier (Modifier.padding 16.dp))
				 (progn

				   (let ((_code_generation_time
					  (string ,(multiple-value-bind
							 (second minute hour date month year day-of-week dst-p tz)
						       (get-decoded-time)
						     (declare (ignorable dst-p))
						     (format nil "~2,'0d:~2,'0d:~2,'0d of ~a, ~d-~2,'0d-~2,'0d (GMT~@d)"
							     hour
							     minute
							     second
							     (nth day-of-week *day-names*)
							     year
							     month
							     date
							     (- tz)))))
					 (_code_git_hash (string ,(format nil "git:~a"
									  (let ((str (with-output-to-string (s)
										       (sb-ext:run-program "/usr/bin/git" (list "rev-parse" "HEAD") :output s))))
									    (subseq str 0 (1- (length str)))))))))
				 
				   (TopAppBar
				    :title
				    (progn
				      (Text :text _code_generation_time)))
				   (do0
				    (Text :text (counter_state.value.toString))
				    (Text :text (counter2.value.toString))
				    (space (Button :onClick (progn
							      (incf counter_state.value 5)
							      ))
					   (progn
					     (Text :text (string "Click to Add 5"))))
				    (space (Button :onClick (progn
							      (incf counter2.value 15)
							      ))
					   (progn
					     (Text :text (string "Click to Add 15 to 2")))))
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
				       (setf paint_path.color Color.Red
					     paint_path.strokeWidth 15f
					     paint_path.style PaintingStyle.stroke
					     )
					;(setf path.fillType evenOdd)
				       (path.moveTo 50f 500f)
				       (path.lineTo 55f 550f)
				       (path.lineTo 105f 650f)
				       (path.lineTo 305f (+ 1250f counter_state.value))
				    
				       (drawPath :path path
						 :paint paint_path))))))))))
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

