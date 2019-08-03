package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import java.io.File
import java.lang.System.currentTimeMillis
import java.io.FileOutputStream
import java.util.zip.GZIPOutputStream
private const
val REQUEST_CODE_PERMISSIONS = 10
private 
val REQUIRED_PERMISSIONS = arrayOf<String>()
class MainActivity : AppCompatActivity() {
    private
    fun allPermissionsGranted(): Boolean {
        return REQUIRED_PERMISSIONS.all(fun (it: String): Boolean {
            return (ContextCompat.checkSelfPermission(baseContext, it))==(PackageManager.PERMISSION_GRANTED)
})
}
    fun generate_data(count: Int): String {
        val now = currentTimeMillis()
        val str = "${now},bsltaa,${count}"
        return str
}
    fun make_appending_gzip_stream(fn: String): GZIPOutputStream {
        val dir = getCacheDir()
        val file = File(dir, fn)
        val o = FileOutputStream(file, true)
        val oz = GZIPOutputStream(o)
        return oz
}
    fun gzip_write(o: GZIPOutputStream, str: String){
        val data = str.toByteArray(Charsets.UTF_8)
        o.write(data)
}
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            d("martin", "required permissions obtained")
            val o = make_appending_gzip_stream("data.gz")
            for (i in 1..2100320) {
                gzip_write(o, generate_data(i))
}
} else {
            d("martin", "request permissions ${REQUIRED_PERMISSIONS}")
            ActivityCompat.requestPermissions(this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS)
}
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
}