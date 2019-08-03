(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

;; https://proandroiddev.com/security-best-practices-symmetric-encryption-with-aes-in-java-7616beaaade9
;; https://developer.android.com/reference/javax/crypto/CipherOutputStream.html

;; the init vector needs to be stored as well

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

	     android.content.pm.PackageManager
	     androidx.core.content.ContextCompat
	     androidx.core.app.ActivityCompat
	     java.io.File
	     java.lang.System.currentTimeMillis
	     java.io.FileOutputStream
	     java.io.FileInputStream
	     java.util.zip.GZIPOutputStream
 
	     java.security.KeyStore

	     javax.crypto.Cipher
	     javax.crypto.KeyGenerator
	     android.security.keystore.KeyGenParameterSpec
	     android.security.keystore.KeyProperties

	     javax.crypto.CipherOutputStream
	     
	     javax.crypto.spec.GCMParameterSpec


	     java.util.zip.GZIPInputStream
	     javax.crypto.CipherInputStream
	     
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
		 "data class CipherResult(val cipher:Cipher,val init_vec:ByteArray)"
	       (defun make_cipher ()
		 (declare (values CipherResult))
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
				    ,trafo)))
		       (cipher.init Cipher.ENCRYPT_MODE secretkey)
		       (let ((iv (cipher.getIV)))
			 (return (CipherResult cipher iv)))))))
	      
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

	      (defun generate_data (count)
		(declare (values String)
			 (type Int count))
		(let ((now (currentTimeMillis))
		      (str (string "${now},bsltaa,${count}\\n")))
		  (return str)))
	      

	      (defun decrypt_gzip_stream (fn init_vector)
		(declare (type ByteArray init_vector)
			 (type String fn)
					;(values String)
			  )
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
		     (let ((dir (getCacheDir))
			   (file (File dir fn))
			   (istr (FileInputStream file))
			   (ic (CipherInputStream istr cipher))
			   (iz (GZIPInputStream ic))
			   (n 1024)
			   (data (ByteArray n))
			   (bytes_read (iz.read data 0 n))
			   (data_str (data.toString)))
		       (d (string "martin")
			  (string "${data_str}"))
		       ))))
	      
	      (defun crypto_gzip_write (o str)
		(declare (type GZIPOutputStream o)
			 (type String str))
		(let ((data (str.toByteArray Charsets.UTF_8)))
		  (o.write data)))

	      (do0 "data class CompressedCryptoStream(val stream:GZIPOutputStream,val init_vec:ByteArray)"
		   (defun make_crypto_appending_gzip_stream (fn)
		     (declare (type String fn)
			      (values CompressedCryptoStream))
		     ;; apppend if it exists
		     (let ((dir (getCacheDir))
			   (file (File dir fn))
			   (o (FileOutputStream file; true
						))
			   
			   ((paren cipher iv) (make_cipher))
			   (oc (CipherOutputStream o cipher))
			   
			   (oz (GZIPOutputStream oc))
			   )
		       (return (CompressedCryptoStream oz iv)))))
	      
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
			      (let (((paren o iv) (make_crypto_appending_gzip_stream (string "data.aes.gz")))
				    (dir (getCacheDir)) ;; FIXME do i need to hide the init vector?
				    (file (File dir (string "data.aes.iv")))
				    )
				(file.writeBytes iv)
				(for (i "1..2100")
				     (do0
				      ;(Thread.sleep 100)
				      (crypto_gzip_write o (generate_data i))))
				)
			      (decrypt_gzip_stream (string "data.aes.gz") iv)
			      
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
					   "// none"))))))))

	       )
	    )))
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

