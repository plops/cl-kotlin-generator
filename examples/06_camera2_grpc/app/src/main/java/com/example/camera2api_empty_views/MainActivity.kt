package com.example.camera2api_empty_views

import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.graphics.SurfaceTexture
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CaptureRequest
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.view.Surface
import android.view.TextureView
import io.grpc.Server


// when activity starts, a grpc server is initialized using grpc-netty-shaded
// and a camera is opened using camera2 api
// the camera is displayed on the screen using a textureView

class MainActivity : AppCompatActivity() {
    lateinit var handler: Handler
    private lateinit var handlerThread: HandlerThread
    private lateinit var cameraManager: CameraManager
    lateinit var textureView: TextureView
    lateinit var cameraCaptureSession: CameraCaptureSession
    lateinit var cameraDevice: CameraDevice
    lateinit var captureRequest: CaptureRequest
    lateinit var capReq: CaptureRequest.Builder

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // start the grpc server
        val server = Server()
        server.start()

        // getPermissions() is called to request permissions for camera and storage
        getPermissions()

        // textureView is initialized and a surfaceTextureListener is set
        textureView = findViewById(R.id.textureView)
        // cameraManager is initialized, it's task is to open the camera
        cameraManager = getSystemService(CAMERA_SERVICE) as CameraManager
        // handlerThread and handler are initialized, they are used to open the camera
        handlerThread = HandlerThread("videoThread")
        handlerThread.start()
        handler = Handler(handlerThread.looper)

        // surfaceTextureListener opens the camera when the textureView is available
        // and deallocates the camera when the textureView is destroyed
        textureView.surfaceTextureListener =
            object: TextureView.SurfaceTextureListener{
                override fun onSurfaceTextureAvailable(p0: SurfaceTexture, p1: Int, p2: Int) {
                    openCamera()
                }

                override fun onSurfaceTextureSizeChanged(p0: SurfaceTexture, p1: Int, p2: Int) {
                }

                override fun onSurfaceTextureDestroyed(p0: SurfaceTexture): Boolean {
                    return false
                }

                override fun onSurfaceTextureUpdated(p0: SurfaceTexture) {
                }
            }
    }

    @SuppressLint("MissingPermission")
    fun openCamera() {
        cameraManager.openCamera(cameraManager.cameraIdList[0], object: CameraDevice.StateCallback(){
            override fun onOpened(p0: CameraDevice) {
                // cameraDevice is initialized and a captureRequest is created
                cameraDevice = p0
                capReq = cameraDevice.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
                val surface= Surface(textureView.surfaceTexture)
                capReq.addTarget(surface)
                cameraDevice.createCaptureSession(listOf(surface),
                    object: CameraCaptureSession.StateCallback(){
                        override fun onConfigured(p0: CameraCaptureSession) {
                            // cameraCaptureSession is initialized and a repeating request is set
                            cameraCaptureSession = p0
                            captureRequest = capReq.build()
                            cameraCaptureSession.setRepeatingRequest(captureRequest, null, null)
                        }

                        override fun onConfigureFailed(p0: CameraCaptureSession) {
                        }
                    }, handler)
                    }

            override fun onDisconnected(p0: CameraDevice) {
            }

            override fun onError(p0: CameraDevice, p1: Int) {
            }
        }, handler)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        // if permissions are not granted, getPermissions() is called again
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        grantResults.forEach {
            if(it != PackageManager.PERMISSION_GRANTED)
                getPermissions()
        }
    }
    private fun getPermissions(){
        // permissions for camera and storage are requested
        val permissionsLst = mutableListOf<String>()
        if(checkSelfPermission(android.Manifest.permission.CAMERA)!= PackageManager.PERMISSION_GRANTED){
            permissionsLst.add(android.Manifest.permission.CAMERA)
        }
        if(checkSelfPermission(android.Manifest.permission.READ_EXTERNAL_STORAGE)!= PackageManager.PERMISSION_GRANTED){
            permissionsLst.add(android.Manifest.permission.READ_EXTERNAL_STORAGE)
        }
        if(checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)!= PackageManager.PERMISSION_GRANTED){
            permissionsLst.add(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
        }
        // if permissionsLst is not empty, permissions are requested
        if (permissionsLst.size > 0){
            requestPermissions(permissionsLst.toTypedArray(),101)
        }
    }
}