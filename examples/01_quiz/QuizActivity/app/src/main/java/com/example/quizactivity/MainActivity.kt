package com.example.quizactivity

import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.hardware.SensorEventListener
import android.hardware.SensorEvent
import android.hardware.SensorManager
import android.hardware.Sensor
import android.os.Bundle
import android.content.Context

class MainActivity : AppCompatActivity(), SensorEventListener {
    private lateinit var _sensor_manager: SensorManager
    private val _data_accelerometer =
        FloatArray(3)
    private val _data_magnetometer =
        FloatArray(3)
    private val _rotation_matrix =
        FloatArray(9)
    private val _orientation_angles =
        FloatArray(3)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        _sensor_manager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
    }

    override fun onSaveInstanceState(savedInstanceState: Bundle) {
        super.onSaveInstanceState(savedInstanceState)
        d("martin", "onSaveInstanceState")
        // none
    }

    override fun onPostCreate(savedInstanceState: Bundle?) {
        super.onPostCreate(savedInstanceState)
        d("martin", "onPostCreate")
        // none
    }

    override fun onDestroy() {
        super.onDestroy()
        d("martin", "onDestroy")
        // none
    }

    override fun onStart() {
        super.onStart()
        d("martin", "onStart")
        // none
    }

    override fun onStop() {
        super.onStop()
        d("martin", "onStop")
        // none
    }

    override fun onPostResume() {
        super.onPostResume()
        d("martin", "onPostResume")
        // none
    }

    override fun onResume() {
        super.onResume()
        d("martin", "onResume")
        _sensor_manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)?.also(fun(x) {
            _sensor_manager.registerListener(
                this,
                x,
                SensorManager.SENSOR_DELAY_NORMAL,
                SensorManager.SENSOR_DELAY_UI
            )
        })
        _sensor_manager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)?.also(fun(x) {
            _sensor_manager.registerListener(
                this,
                x,
                SensorManager.SENSOR_DELAY_NORMAL,
                SensorManager.SENSOR_DELAY_UI
            )
        })
    }

    override fun onPause() {
        super.onPause()
        d("martin", "onPause")
        _sensor_manager.unregisterListener(this)
    }

    override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {
        d("martin", "accuracy ${accuracy}")
    }

    override fun onSensorChanged(event: SensorEvent) {
        if ((event.sensor.type) == (Sensor.TYPE_ACCELEROMETER)) {
            System.arraycopy(event.values, 0, _data_accelerometer, 0, _data_accelerometer.size)
            return
        }
        if ((event.sensor.type) == (Sensor.TYPE_MAGNETIC_FIELD)) {
            System.arraycopy(event.values, 0, _data_magnetometer, 0, _data_magnetometer.size)
            return
        }
    }

    fun updateOrientationAngles() {
        d("martin", "update-angles")

        _sensor_manager.getRotationMatrix(
            _rotation_matrix,
            null,
            _data_accelerometer,
            _data_magnetometer
        )
        _sensor_manager.getOrientation(_rotation_matrix, _orientation_angles)
    }
}