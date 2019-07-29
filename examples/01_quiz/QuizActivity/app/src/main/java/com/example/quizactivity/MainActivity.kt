package com.example.quizactivity
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import kotlinx.android.synthetic.main.activity_main.*
import android.content.Context
import android.opengl.GLSurfaceView
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10
import android.opengl.GLES20
class MainActivity : AppCompatActivity() {
    var _count = 0
    private lateinit var _gl_view: GLSurfaceView
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        (_count)++
        d("martin", "onCreate {$_count}")
        if ( !((savedInstanceState)==(null)) ) {
            _count=savedInstanceState?.getInt("_count", 0)
}
        _gl_view=MyGLSurfaceView(this)
        setContentView(_gl_view)
}
    override fun onSaveInstanceState(savedInstanceState: Bundle){
        super.onSaveInstanceState(savedInstanceState)
        (_count)++
        d("martin", "onSaveInstanceState {$_count}")
        savedInstanceState.putInt("_count", _count)
}
    override fun onPostCreate(savedInstanceState: Bundle?){
        super.onPostCreate(savedInstanceState)
        (_count)++
        d("martin", "onPostCreate {$_count}")
        // none
}
    override fun onDestroy(){
        super.onDestroy()
        (_count)++
        d("martin", "onDestroy {$_count}")
        // none
}
    override fun onStart(){
        super.onStart()
        (_count)++
        d("martin", "onStart {$_count}")
        // none
}
    override fun onStop(){
        super.onStop()
        (_count)++
        d("martin", "onStop {$_count}")
        // none
}
    override fun onPostResume(){
        super.onPostResume()
        (_count)++
        d("martin", "onPostResume {$_count}")
        // none
}
    override fun onPause(){
        super.onPause()
        (_count)++
        d("martin", "onPause {$_count}")
        // none
}
}
class MyGLRenderer : GLSurfaceView.Renderer() {
    override fun onSurfaceCreated(unused: GL10, config: EGLConfig){
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
}
    override fun onDrawFrame(unused: GL10){
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT)
}
    override fun onSurfaceChanged(unused: GL10, width: Int, height: Int){
        GLES20.glViewport(0, 0, width, height)
}
}
class MyGLSurfaceView(context: Context) : GLSurfaceView(context) {
    private val _renderer: MyGLRenderer
    init
    {
        setEGLContextClientVersion(2)
        _renderer=MyGLRenderer()
        setRenderer(_renderer)
}
}