package com.example.a04_usbcam
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
}
}