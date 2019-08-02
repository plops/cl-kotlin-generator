package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import android.content.Context
import android.Manifest
import java.io.File
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import java.security.KeyStore
import java.security.KeyPairGenerator
private const
val REQUEST_CODE_PERMISSIONS = 10
private 
val REQUIRED_PERMISSIONS = arrayOf()
class MainActivity : AppCompatActivity() {
    private
    fun allPermissionsGranted(): Boolean {
        return REQUIRED_PERMISSIONS.all(fun (it: String): Boolean {
            return (ContextCompat.checkSelfPermission(baseContext, it))==(PackageManager.PERMISSION_GRANTED)
})
}
    private lateinit var _key_store : KeyStore
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            d("martin", "required permissions obtained")
            // secure place to store keys
            _key_store=(fun (): KeyStore {
                val ks = KeyStore.getInstance("AndroidKeyStore")
                ks.load(null)
                return ks
})()
            val generator = KeyPairGenerator("RSA", "AndroidKeyStore")
            val alias = "alias0"
            initGeneratorWithKeyGenParameterSpec(generator, alias)
            val pair = generator.generateKeyPair()
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