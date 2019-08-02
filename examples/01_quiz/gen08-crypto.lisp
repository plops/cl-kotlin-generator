(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://proandroiddev.com/secure-data-in-android-encryption-in-android-part-1-e5fd150e316f

;; key store trust zone (if available) will be used to store keys in a
;; way that makes them difficult to read from the device
;; keys will be deleted from store when its app is deleted

;; KeyInfo.isInsideSecurityHardware()

;; https://medium.com/@josiassena/using-the-android-keystore-system-to-store-sensitive-information-3a56175a454b
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
	     android.content.Context

	     android.Manifest
	     java.io.File

	     android.content.pm.PackageManager
	     androidx.core.content.ContextCompat
	     androidx.core.app.ActivityCompat
	     java.security.KeyStore
	     javax.crypto.Cipher
	     javax.crypto.KeyGenerator
	     android.security.keystore.KeyGenParameterSpec
	     android.security.keystore.KeyProperties
	     javax.crypto.spec.GCMParameterSpec
	     )

	    (do0
	     (do0
	      "private const"
	      (let ((REQUEST_CODE_PERMISSIONS 10))))
	     (do0
	      "private "
	      (let ((REQUIRED_PERMISSIONS
		     
		     (arrayOf<String> ;  Manifest.permission.ACCESS_FINE_LOCATION
			       )))
		)))
	    ,(let ((alias `(string "alias0"))
		   (trafo `(string "AES/GCM/NoPadding")))
	       `(do0
		 "data class EncryptionResult(val data:ByteArray,val init_vec:ByteArray)"
	       (defun encrypt (str)
		 (declare (type String str)
			  (values EncryptionResult))
		 (let ((keystore (KeyStore.getInstance
				  (string "AndroidKeyStore"))))
		   (keystore.load null)
		   (let ((keygen (KeyGenerator.getInstance (string "AES")
							   (string "AndroidKeyStore")))
			 (spec_builder (KeyGenParameterSpec.Builder
					,alias
					(logior
					 KeyProperties.PURPOSE_ENCRYPT
					 KeyProperties.PURPOSE_DECRYPT)))
			 (spec (dot spec_builder
				    (setBlockModes
				     KeyProperties.BLOCK_MODE_GCM)
				    (setEncryptionPaddings
				     KeyProperties.ENCRYPTION_PADDING_NONE)
				    (build)))
			 )
		     (keygen.init spec)
		     (let ((secretkey (keygen.generateKey))
			   (cipher (Cipher.getInstance
				    ,trafo
				    )))
		       (cipher.init Cipher.ENCRYPT_MODE secretkey)
		       (let ((iv (cipher.getIV))
			     (encryption (cipher.doFinal
					  (dot str
					       (toByteArray)))))
			 (return (EncryptionResult encryption
						   iv)))
		       ))))
	       (defun decrypt (data init_vector)
		 (declare (type ByteArray data
				init_vector)
			  (values String))
		 (let ((keystore (KeyStore.getInstance
				  (string "AndroidKeyStore"))))
		   (keystore.load null)
		   (let (
			 (cipher (Cipher.getInstance ,trafo))
			 (spec (GCMParameterSpec 128 init_vector))
			 (entry (as (dot keystore
				       (getEntry ,alias null)
				       )
				    KeyStore.SecretKeyEntry)))
		     (cipher.init Cipher.DECRYPT_MODE
				  (entry.getSecretKey)
				  spec)
		     (return (String (cipher.doFinal data)
				     Charsets.UTF_8)))))))
	    
	    (defclass MainActivity ((AppCompatActivity))
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
	      
	      #+nil,@(loop for (var type) in `((_key_store KeyStore)) collect
		     (format nil "private lateinit var ~a : ~a" var type))
	      
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
			      "// FIXME: eventually my use case would be to store a key in the keystore when the app is installed. all output that is stored in files must be encrypted with this key."
			      (let (((paren data iv) (encrypt (string "hello world")))
				    (dec (decrypt data iv))))
			      (d (string "martin")
				 (string "${dec}"))
			      )
			     (do0
			      (d (string "martin")
				 (string "request permissions ${REQUIRED_PERMISSIONS}"))
			      (ActivityCompat.requestPermissions
			       this
			       REQUIRED_PERMISSIONS
			       REQUEST_CODE_PERMISSIONS)))))
		       
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
					   "// none"))))))))))
    (ensure-directories-exist path-kotlin)
    (ensure-directories-exist path-layout)
    
    (write-source (format nil "~a/~a" path-kotlin main-activity) code)
    (write-xml (format nil "~a/~a" path-layout "activity_main") layout)
    
    (write-xml (format nil "~a/~a" path-manifest "AndroidManifest") manifest)
    #+nil (sb-ext:run-program
	   "/home/martin/Downloads/android-studio/bin/format.sh"
	   (list "-r"  path-lisp) 
	   )))
 
 
;; adb install -r /home/martin/stage/cl-kotlin-generator/examples/01_quiz/QuizActivity/app/build/outputs/apk/debug/app-debug.apk

