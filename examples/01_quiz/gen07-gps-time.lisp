(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://stackoverflow.com/questions/8210264/sync-android-devices-via-gps-time 
;; https://github.com/androidthings/drivers-samples/blob/master/gps/src/main/java/com/example/androidthings/driversamples/GpsActivity.java
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
					;<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
					;<uses-permission android:name="com.google.android.things.permission.MANAGE_GNSS_DRIVERS"/>
					;<uses-permission android:name="com.google.android.things.permission.USE_PERIPHERAL_IO"/>
	     ,@(loop for e in
		    `(android.permission.ACCESS_FINE_LOCATION
					;com.google.android.things.permission.MANAGE_GNSS_DRIVERS
					;com.google.android.things.permission.USE_PERIPHERAL_IO
		      )
		  collect
		    `(uses-permission
		      :android.name ,e
		      ))
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
	     android.location.LocationProvider
	     android.location.OnNmeaMessageListener
	     android.content.Context

	     android.Manifest
	     android.content.pm.PackageManager
	     androidx.core.app.ActivityCompat
	     androidx.core.content.ContextCompat
					;com.google.android.things.contrib.driver.gps.NmeaGpsDriver
	     )

	    (do0
	     (do0
	      "private const"
	      (let ((REQUEST_CODE_PERMISSIONS 10))))
	     (do0
	      "private "
	      (let ((REQUIRED_PERMISSIONS (arrayOf Manifest.permission.ACCESS_FINE_LOCATION
						   ))))))
	    (defclass MainActivity ((AppCompatActivity)
				    
				    )
	      (do0 "private"
		   (defun allPermissionsGranted ()
		     (declare (values Boolean))
		     (return (dot REQUIRED_PERMISSIONS
				  (all (lambda (it)
					 (declare (type String it)
						  (values Boolean))
					 (return
					   (== (ContextCompat.checkSelfPermission
						baseContext it)
					       PackageManager.PERMISSION_GRANTED))))))))
	      
	      ,@(loop for (var type) in `((_location_manager LocationManager)
					  (_provider LocationProvider))
		   collect
		     (format nil "private lateinit var ~a : ~a" var type))
	      
	      ;;"private lateinit var _gps_driver : NmeaGpsDriver"
	      ,@(loop for e in
		     `((Create ((savedInstanceState Bundle?))
			       (do0
				(setContentView R.layout.activity_main)


				(if (allPermissionsGranted)
				    (do0
				     (setf _location_manager (as (getSystemService Context.LOCATION_SERVICE)
								 LocationManager))
				     #+nil (do0 (setf _gps_driver (NmeaGpsDriver
								   this
								   (string "UART2")
								   9600
								   2.5f))
						(_gps_driver.register))
				     (setf _provider (_location_manager.getProvider
						      LocationManager.GPS_PROVIDER))
				     (when (== _provider null)
				       (d (string "martin")
					  (string "no gps provider")))
				     (when (GpsTestUtil))
				     (let ((now (currentTimeMillis)))
				       (d (string "martin")
					  (string "now = ${now}"))) 
				     )
				    (do0
				     (ActivityCompat.requestPermissions
				      this
				      REQUIRED_PERMISSIONS
				      REQUEST_CODE_PERMISSIONS)))

				
				
				
				))
		       
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
 
 
