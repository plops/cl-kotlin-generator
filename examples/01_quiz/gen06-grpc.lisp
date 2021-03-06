(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)


;; this example is based on this website
;;  https://shuza.ninja/grpc-client-side-implementation-for-android/ 

;; i obtained the most recent version of protobuf here (it needs to be
;; written into a gradle file):
;; https://github.com/google/protobuf-gradle-plugin

(let* ((main-activity "MainActivity")
       (title "QuizActivity")
       (path-lisp "/home/martin/quicklisp/local-projects/cl-kotlin-generator/examples/01_quiz/")
       (path-kotlin (format nil "~a/~a/app/src/main/java/com/example/~a/"
			    path-lisp title
			    (string-downcase title)))
       (path-layout (format nil "~a/~a/app/src/main/res/layout/"
			    path-lisp title))
       (path-manifest (format nil "~a/~a/app/src/main/"
			    path-lisp title))

       
       ;FirstGame/app/src/main/res/layout/content_main.xml
       ;FirstGame/app/src/main/res/values/strings.xml
       ;QuizActivity/app/src/main/AndroidManifest.xml
       
       )
  (let* ((manifest
	  `(do0
	   "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	   (manifest
	    :xmlns.android "http://schemas.android.com/apk/res/android"
	    :package com.example.quizactivity
	    
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

		
		;com.example.quizactivity.LoginRequest
		;com.example.quizactivity.LoginResponse
		;com.example.quizactivity.LoginServiceGrpc
		io.grpc.ManagedChannel
		io.grpc.okhttp.OkHttpChannelBuilder

		io.reactivex.*
		io.reactivex.android.schedulers.AndroidSchedulers
		io.reactivex.disposables.Disposable
		io.reactivex.schedulers.Schedulers

		;kotlinx.android.synthetic.main.activity_login.*

		       )


	       (defclass MainActivity ((AppCompatActivity)
				       
				       )
		 
		 ,@(loop for e in
			`((Create ((savedInstanceState Bundle?))
				  (do0
				   (setContentView R.layout.activity_main)
				   (let (connection_channel
					  
					 (login_service (LoginServiceGrpc.newBlockingStub
							 connection_channel))
					 (request_message (dot (LoginRequest.newBuilder)
							       (setUsername (string "bla"))
							       (setPassword (string "foo"))
							       (build))))
				     (declare (type (dot
					   "ManagedChannel by lazy"
					   (progn
					     (dot (OkHttpChannelBuilder.forAddress
						   (string "192.168.1.104")
						   8080)
						  (usePlaintext)
						  (build))))
						    connection_channel))
				     (dot
				      Single.fromCallable
				      (progn
					(login_service.logIn request_message)
					)
				      (subscribeOn (Schedulers.io))
				      (observeOn (AndroidSchedulers.mainThread))
				      (subscribe (dot "object : SingleObserver<LoginResponse>"
						      (progn
							(override
							 (defun onSuccess (response)
							   (declare (type LoginResponse response))
							   (d (string "martin")
							      (string "response")))
							 )
							(override
							 (defun onSubscribe (d)
							   (declare (type Disposable d))))
							(override
							 (defun onError (e)
							   (declare (type Throwable e)))))))))))
				    
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
 
 
