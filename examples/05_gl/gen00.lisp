(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload "cl-kotlin-generator"))

(in-package :cl-kotlin-generator)

(defparameter *day-names*
    '("Monday" "Tuesday" "Wednesday"
      "Thursday" "Friday" "Saturday"
      "Sunday"))

(let* ((main-activity "MainActivity")
       (path-kotlin "/home/martin/stage/cl-kotlin-generator/examples/04_usbcam/app/src/main/java/com/example/a04_usbcam/MainActivity"))
  (let* ((code
	  `(do0
	    (package com.example.a04_usbcam)
	    "// This code is based on output of GPT-4 May 24 Version"
	    (import
	     android.content.Context
	     android.graphics.Color
	     android.hardware.usb.UsbDevice
	     android.hardware.usb.UsbManager
	     android.os.Bundle
	     androidx.appcompat.app.AppCompatActivity
	     android.view.TextureView
	     com.serenegiant.usb.UVCCamera
	     ;; use Alt+Enter on red tokens in android studio to get proposals for the import
	     )

	    

	    (defclass MainActivity ((AppCompatActivity))
	     
	      
	      "lateinit var textureView: TextureView"
	      
	      (space
	       "override"
	       (defun onCreate (saved_instance_state)
		 (declare (type Bundle? saved_instance_state))
		 (super.onCreate saved_instance_state)
		 (setContentView R.layout.activity_main)
		 (setf textureView
		       (findViewById R.id.textureView))
		 (connectToCamera)))
	      (space
	       private
	       (defun connectToCamera ()
		 (let ((usbManager (as (getSystemService
					Context.USB_SERVICE)
				       UsbManager))
		       (deviceList (usbManager.deviceList))
		       (device (deviceList.values.firstOrNull)))
		   (declare (type  "HashMap<String,UsbDevice>" deviceList))
		   (usbManager.requestPermission
		    device
		    permissionIntent)
		   (let ((connection (usbManager.openDevice device))
			 (iface (device.getInterface 0))
			 (uvcCamera (UVCCamera)))
		     (uvcCamera.open connection.fileDescriptor )
		     (uvcCamera.setPreviewTexture textureView.surfaceTexture)
		     (uvcCamera.startPreview))
		   #+nil (let ((bitmap (textureView.bitmap))
			 (histogram (IntArray 256)))
		     (for (y "0 until bitmap.height")
			  (for (x "0 until bitmap.width")
			       (let ((pixel (bitmap.getPixel x y))
				     (intensity (Color.red pixel)))
				 (incf (aref histogram intensity)))))
		     (let ((entries (histogram.mapIndexed
				     (lambda (index value)
				       (return (BarEntry (index.toFloat)
							 (value.toFloat))))))
			   (dataSet (BarDataSet entries (string "Pixel Intensity"))))
		       (dateSet.setColor Color.RED)
		       (let ((barData (BarData dataSet)))
			 (setf barChart.data barData)
			 (barChart.invalidate)))))
		 )))
	    
	    

	    
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

