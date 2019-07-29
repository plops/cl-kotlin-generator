package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import kotlinx.android.synthetic.main.activity_main.*
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.Sensor
import android.os.Bundle
import android.content.Context
class MainActivity : AppCompatActivity(),SensorEventListener {
    private lateinit var _sensor_manager : SensorManager
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        _sensor_manager=getSystemService(Context.SENSOR_SERVICE) as SensorManager
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
        _sensor_manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)?.also(fun (acc){
            _sensor_manager.registerListener(this, acc, SensorManager.SENSOR_DELAY_NORMAL, SensorManager.SENSOR_DELAY_UI)
})
}
    override fun onPause(){
        super.onPause()
        d("martin", "onPause")
        // none
}
    override fun onAccuracyChanged(sensor: Sensor, accuracy: Int){
        d("martin", "accuracy ${accuracy}")
}
}