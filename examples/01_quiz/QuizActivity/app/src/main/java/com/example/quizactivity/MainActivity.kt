package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import java.lang.System.currentTimeMillis
import android.location.LocationManager
import android.location.OnNmeaMessageListener
import android.content.Context
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.things.contrib.driver.gps.NmeaGpsDriver
private const
val REQUEST_CODE_PERMISSIONS = 10
private 
val REQUIRED_PERMISSIONS = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
class MainActivity : AppCompatActivity() {
    private
    fun allPermissionsGranted(): Boolean {
        return REQUIRED_PERMISSIONS.all(fun (it: String): Boolean {
            return (ContextCompat.checkSelfPermission(baseContext, it))==(PackageManager.PERMISSION_GRANTED)
})
}
    private lateinit var _location_manager : LocationManager
    private lateinit var _gps_driver : NmeaGpsDriver
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            _location_manager=getSystemService(Context.LOCATION_SERVICE) as LocationManager
            _gps_driver=NmeaGpsDriver(this, "UART2", 9600, 2.5f)
            _gps_driver.register()
            val now = currentTimeMillis()
            d("martin", "now = ${now}")
} else {
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