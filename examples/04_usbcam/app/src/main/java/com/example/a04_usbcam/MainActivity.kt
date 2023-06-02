package com.example.a04_usbcam
// This code is based on output of GPT-4 May 24 Version
import android.content.Context
import android.graphics.Color
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.view.TextureView
import com.serenegiant.usb.UVCCamera
class MainActivity : AppCompatActivity() {
    lateinit var textureView: TextureView
    override fun onCreate(saved_instance_state: Bundle?){
        super.onCreate(saved_instance_state)
        setContentView(R.layout.activity_main)
        textureView=findViewById(R.id.textureView)
        connectToCamera()
}
    private fun connectToCamera(){
        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        val deviceList: HashMap<String,UsbDevice> = usbManager.deviceList()
        val device = deviceList.values.firstOrNull()
        usbManager.requestPermission(device, permissionIntent)
        val connection = usbManager.openDevice(device)
        val iface = device.getInterface(0)
        val uvcCamera = UVCCamera()
        uvcCamera.open(connection.fileDescriptor)
        uvcCamera.setPreviewTexture(textureView.surfaceTexture)
        uvcCamera.startPreview()
}
}