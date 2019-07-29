(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)




;; https://developer.android.com/guide/topics/sensors/sensors_motion
;; https://developer.android.com/guide/topics/sensors/sensors_position

;; Note: When testing your app, you can improve the sensor's accuracy
;; by waving the device in a figure-8 pattern.

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
	     ))))
	 (code
	     `(do0
	       (package com.example.quizactivity)
	       (import


		androidx.appcompat.app.AppCompatActivity
		android.util.Log.d

		
		
		android.hardware.SensorEventListener
		android.hardware.SensorEvent
		android.hardware.SensorManager
		android.hardware.Sensor
		android.os.Bundle

		android.content.Context
		
		       )


	       (defclass MainActivity ((AppCompatActivity)
				       ;(Activity)
				       SensorEventListener)
		 "private lateinit var _sensor_manager : SensorManager"
		 ,@(loop for (name val) in `((_data_accelerometer (FloatArray 3))
					     (_data_magnetometer (FloatArray 3))
					     (_rotation_matrix (FloatArray 9))
					     (_orientation_angles (FloatArray 3)))
		      collect
			`(do0
			  ,(format nil "private val ~a = " name)
			  ,val))
		 ,@(loop for e in `((Create ((savedInstanceState Bundle?))
					    (do0
					     
					     (setContentView R.layout.activity_main)
					     (setf _sensor_manager
						  (as (getSystemService Context.SENSOR_SERVICE) SensorManager))
					     ))
				    
				    (SaveInstanceState ((savedInstanceState Bundle))
						       )
				    (PostCreate ((savedInstanceState Bundle?)))
				    (Destroy)
				    (Start)
				    (Stop)
				    (PostResume)
				    (Resume nil
					    (do0
					     ,@(loop for e in `(TYPE_ACCELEROMETER
								TYPE_MAGNETIC_FIELD)
						    collect
						    `(dot _sensor_manager
							  (getDefaultSensor (dot Sensor ,e))
							  ?
							  (also (lambda (x)
								  (_sensor_manager.registerListener
								   this
								   x
								   SensorManager.SENSOR_DELAY_NORMAL
								   SensorManager.SENSOR_DELAY_UI)))))))
				    (Pause nil (_sensor_manager.unregisterListener this)))
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
		 (override (defun onAccuracyChanged (sensor accuracy)
			     (declare (type Sensor sensor)
				      (type Int accuracy))
			     (d (string "martin") (string "accuracy ${accuracy}"))))
		 (override (defun onSensorChanged (event)
			     (declare (type SensorEvent event))
			     ;(d (string "martin") (string "sensor-changed"))
			     ,@(loop for (e data) in `((TYPE_ACCELEROMETER _data_accelerometer)
						       (TYPE_MAGNETIC_FIELD _data_magnetometer))
				    collect
				    `(when (== event.sensor.type (dot Sensor ,e))
				       (System.arraycopy event.values 0 ,data 0 (dot ,data size))
				       return))))
		 (defun updateOrientationAngles ()
		   (d (string "martin") (string "update-angles"))
		   #+nil (do0 (_sensor_manager.getRotationMatrix _rotation_matrix null
						       _data_accelerometer
						       _data_magnetometer)
			(_sensor_manager.getOrientation _rotation_matrix _orientation_angles)))
		 ))))
    (ensure-directories-exist path-kotlin)
    (ensure-directories-exist path-layout)
 
    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    #+nil (sb-ext:run-program
	"/home/martin/Downloads/android-studio/bin/format.sh"
	(list "-r"  path-lisp) 
	)))
 
 
