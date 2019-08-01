(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://stackoverflow.com/questions/8210264/sync-android-devices-via-gps-time 
;; https://github.com/androidthings/drivers-samples/blob/master/gps/src/main/java/com/example/androidthings/driversamples/GpsActivity.java

;; this example is based on:
;; https://github.com/barbeau/gpstest/blob/master/GPSTest/src/main/java/com/android/gpstest/GpsTestActivity.java


;;  The NMEA sentences indicate the absolute time which is sent at a
;;  random time during the second, and the 1 PPS signal indicates when
;;  a new second starts, so the combination of both is required for
;;  good time synchronization.
;; https://kb.meinbergglobal.com/kb/time_sync/ntp/configuration/ntp_nmea_operation

;; I don't think android gives me access to the 1pps signal

;; http://esr.ibiblio.org/?p=4171

;; > That module ships TTL-level serial data, with two lines for TX/RX,
;; > a ground, RTS, and a fifth wire carrying the PPS strobe (usually
;; > mapped as the DCD or Data Carrier Detect line).

;; Perhaps they do this in the phone?

;; every second a block of messages arrives
;; time between messages (in timestamp) is 2-3ms
;; perhaps this is good enough. can i verify this by synchronizing two phones via audio or wifi?

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
	     android.location.Location
	     android.location.LocationListener
	     android.location.OnNmeaMessageListener
	     android.content.Context

	     android.Manifest
	     android.content.pm.PackageManager
	     androidx.core.app.ActivityCompat
	     androidx.core.content.ContextCompat
					;com.google.android.things.contrib.driver.gps.NmeaGpsDriver
	     java.io.File
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
				    LocationListener
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
					  (_provider LocationProvider
						     )
					;(_message_listener OnNmeaMessageListener)
					  )
		   collect
		     (format nil "private lateinit var ~a : ~a" var type))
	      
	      ;;"private lateinit var _gps_driver : NmeaGpsDriver"
	      ,@(loop
		   for e in
		     `((Create
			((savedInstanceState Bundle?))
			(do0
			 (setContentView R.layout.activity_main)
			 (if (allPermissionsGranted)
			     (do0
			      (d (string "martin")
				 (string "required permissions obtained"))
			      (setf _location_manager (as (getSystemService Context.LOCATION_SERVICE)
							  LocationManager))
			      
			      (setf _provider (_location_manager.getProvider
					       LocationManager.GPS_PROVIDER))
				     
			      (when (== _provider null)
				(d (string "martin")
				   (string "no gps provider")))
			      (_location_manager.addNmeaListener
			       (lambda
				   (msg timestamp)
				 (declare (type String msg)
					  (type Long timestamp))
				 (let ((now (currentTimeMillis))
				       (dir (getCacheDir))
				       (file (File dir (string "gps_nmea_log.csv")))
				       )
				   
				   (d (string "martin")
				      (string "${file.getName()} ${now} ${timestamp} ${now-timestamp} '${msg.trim()}'"))
				   (file.appendText (string "${now},${timestamp},${now-timestamp},'${msg.trim()}'")))))
			      (_location_manager.requestLocationUpdates
			       (_provider.getName)
			       0
			       0.0f
			       this
			       )
				      
			      )
			     (do0
			      (d (string "martin")
				 (string "request permissions ${REQUIRED_PERMISSIONS}"))
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
	      (do0
	       ;; locationlistener
	       ,@(loop for e
		    in `((onLocationChanged ((loc Location))
					    (d (string "martin")
					       (string "location = {$loc}"))
					    override
					    )
			 (onStatusChanged ((provider String)
					   (status Int)
					   (extras Bundle))
					  (d (string "martin")
					     (string "provider={$provider} status={$status}"))
					  override)
			 (onProviderEnabled ((provider String)
					     )
					    (d (string "martin")
					       (string "provider={$provider} enabled"))
					    override)
			 (onProviderDisabled ((provider String)
					      )
					     (d (string "martin")
						(string "provider={$provider} disabled"))
					     override))
		    collect
		      (destructuring-bind (name par code &optional (style 'do0
									  )) e
			`(,style (do0 "public"
				      (defun ,name (,@(mapcar #'first par))
				       
					(declare ,@(loop for (var type) in par
						      collect
							`(type ,type ,var)))
					#+nil
					(dot super (,name ,@(mapcar #'first par

								    )))
					,code)))))
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
 
 
