package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import java.lang.System.currentTimeMillis
import android.location.LocationManager
import android.location.LocationProvider
import android.location.OnNmeaMessageListener
import android.content.Context
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
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
    private lateinit var _provider : LocationProvider
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            d("martin", "required permissions obtained")
            _location_manager=getSystemService(Context.LOCATION_SERVICE) as LocationManager
            _provider=_location_manager.getProvider(LocationManager.GPS_PROVIDER)
            if ( (_provider)==(null) ) {
                d("martin", "no gps provider")
}
            _location_manager.addNmeaListener(fun (msg: String, timestamp: Long){
                val now = currentTimeMillis()
                d("martin", "${msg} ${now} ${timestamp}")
})
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