package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import android.view.View
import androidx.lifecycle.LifecycleOwner
import android.view.TextureView
import android.view.ViewGroup
import androidx.camera.core.Preview
import androidx.camera.core.PreviewConfig
import android.util.Size
import android.util.Rational
class MainActivity : AppCompatActivity(),LifecycleOwner {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        _view_finder=findViewById(R.id.view_finder)
        _view_finder.post(fun (){
            startCamera()
})
        _view_finder.addOnLayoutChangeListener(fun (v: View, left: Int, top: Int, right: Int, bottom: Int, lefto: Int, topo: Int, righto: Int, bottomo: Int){
            updateTransform()
})
}
    override fun onSaveInstanceState(savedInstanceState: Bundle){
        super.onSaveInstanceState(savedInstanceState)
        d("martin", "onSaveInstanceState")
        // none
}
    override fun onPostCreate(savedInstanceState: Bundle?){
        super.onPostCreate(savedInstanceState)
        d("martin", "onPostCreate")
        // none
}
    override fun onDestroy(){
        super.onDestroy()
        d("martin", "onDestroy")
        // none
}
    override fun onStart(){
        super.onStart()
        d("martin", "onStart")
        // none
}
    override fun onStop(){
        super.onStop()
        d("martin", "onStop")
        // none
}
    override fun onPostResume(){
        super.onPostResume()
        d("martin", "onPostResume")
        // none
}
    override fun onResume(){
        super.onResume()
        d("martin", "onResume")
        // none
}
    override fun onPause(){
        super.onPause()
        d("martin", "onPause")
        // none
}
    private lateinit var _view_finder : TextureView
    private
    fun startCamera(){
        val preview_config = PreviewConfig.Builder().setTargetAspectRatio(Rational(1, 1)).setTargetResolution(Size(256, 256)).build()
        val preview = Preview(preview_config)
        preview.setOnPreviewOutputUpdateListener(fun (preview_output){
            val parent = _view_finder.parent as ViewGroup
            parent.removeView(_view_finder)
            parent.addView(_view_finder, 0)
            _view_finder.surfaceTexture=preview_output.surfaceTexture
            updateTransform()
})
        CameraX.bindToLifecycle(this, preview)
}
    fun updateTransform(){
        val matrix = Matrix()
        val center_x = (((5.e-1))*(_view_finder.width))
        val center_y = (((5.e-1))*(_view_finder.height))
        val rotation_degrees = when(_view_finder.display.rotation) {
            Surface.ROTATION_0 -> 0
            Surface.ROTATION_90 -> 90
            Surface.ROTATION_180 -> 180
            Surface.ROTATION_270 -> 270
            else -> return
}
}
}