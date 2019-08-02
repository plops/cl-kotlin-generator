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
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import javax.crypto.spec.GCMParameterSpec
private const
val REQUEST_CODE_PERMISSIONS = 10
private 
val REQUIRED_PERMISSIONS = arrayOf<String>()
data class EncryptionResult(val data:ByteArray,val init_vec:ByteArray)
fun encrypt(str: String): EncryptionResult {
    val keystore = KeyStore.getInstance("AndroidKeyStore")
    keystore.load(null)
    val keygen = KeyGenerator.getInstance("AES", "AndroidKeyStore")
    val spec_builder = KeyGenParameterSpec.Builder("alias0", ((KeyProperties.PURPOSE_ENCRYPT) or (KeyProperties.PURPOSE_DECRYPT)))
    val spec = spec_builder.setBlockModes(KeyProperties.BLOCK_MODE_GCM).setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE).build()
    keygen.init(spec)
    val secretkey = keygen.generateKey()
    val cipher = Cipher.getInstance("AES/GCM/NoPadding")
    cipher.init(Cipher.ENCRYPT_MODE, secretkey)
    val iv = cipher.getIV()
    val encryption = cipher.doFinal(str.toByteArray())
    return EncryptionResult(encryption, iv)
}
fun decrypt(data: ByteArray, init_vector: ByteArray): String {
    val keystore = KeyStore.getInstance("AndroidKeyStore")
    keystore.load(null)
    val cipher = Cipher.getInstance("AES/GCM/NoPadding")
    val spec = GCMParameterSpec(128, init_vector)
    val entry = keystore.getEntry("alias0", null) as KeyStore.SecretKeyEntry
    cipher.init(Cipher.DECRYPT_MODE, entry.getSecretKey(), spec)
    return String(cipher.doFinal(data), Charsets.UTF_8)
}
class MainActivity : AppCompatActivity() {
    private
    fun allPermissionsGranted(): Boolean {
        return REQUIRED_PERMISSIONS.all(fun (it: String): Boolean {
            return (ContextCompat.checkSelfPermission(baseContext, it))==(PackageManager.PERMISSION_GRANTED)
})
}
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            d("martin", "required permissions obtained")
            // secure place to store keys
            val (data, iv) = encrypt("hello world")
            val dec = decrypt(data, iv)
            d("martin", "${dec}")
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