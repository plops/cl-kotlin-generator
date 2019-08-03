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
import java.io.FileInputStream
import java.util.zip.GZIPOutputStream
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import javax.crypto.CipherOutputStream
import javax.crypto.spec.GCMParameterSpec
import java.util.zip.GZIPInputStream
import javax.crypto.CipherInputStream
private const
val REQUEST_CODE_PERMISSIONS = 10
private 
val REQUIRED_PERMISSIONS = arrayOf<String>()
data class CipherResult(val cipher:Cipher,val init_vec:ByteArray)
fun make_cipher(): CipherResult {
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
    return CipherResult(cipher, iv)
}
class MainActivity : AppCompatActivity() {
    private
    fun allPermissionsGranted(): Boolean {
        return REQUIRED_PERMISSIONS.all(fun (it: String): Boolean {
            return (ContextCompat.checkSelfPermission(baseContext, it))==(PackageManager.PERMISSION_GRANTED)
})
}
    fun generate_data(count: Int): String {
        val now = currentTimeMillis()
        val str = "${now},bsltaa,${count}\n"
        return str
}
    fun decrypt_gzip_stream(fn: String, init_vector: ByteArray){
        val keystore = KeyStore.getInstance("AndroidKeyStore")
        keystore.load(null)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val spec = GCMParameterSpec(128, init_vector)
        val entry = keystore.getEntry("alias0", null) as KeyStore.SecretKeyEntry
        cipher.init(Cipher.DECRYPT_MODE, entry.getSecretKey(), spec)
        val dir = getCacheDir()
        val file = File(dir, fn)
        val istr = FileInputStream(file)
        val ic = CipherInputStream(istr, cipher)
        val iz = GZIPInputStream(ic)
        val n = 1024
        val data = ByteArray(n)
        val bytes_read = iz.read(data, 0, n)
        val data_str = data.toString()
        d("martin", "${data_str}")
}
    fun crypto_gzip_write(o: GZIPOutputStream, str: String){
        val data = str.toByteArray(Charsets.UTF_8)
        o.write(data)
}
    data class CompressedCryptoStream(val stream:GZIPOutputStream,val init_vec:ByteArray)
    fun make_crypto_appending_gzip_stream(fn: String): CompressedCryptoStream {
        val dir = getCacheDir()
        val file = File(dir, fn)
        val o = FileOutputStream(file)
        val (cipher, iv) = make_cipher()
        val oc = CipherOutputStream(o, cipher)
        val oz = GZIPOutputStream(oc)
        return CompressedCryptoStream(oz, iv)
}
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        if ( allPermissionsGranted() ) {
            d("martin", "required permissions obtained")
            val (o, iv) = make_crypto_appending_gzip_stream("data.aes.gz")
            val dir = getCacheDir()
            val file = File(dir, "data.aes.iv")
            file.writeBytes(iv)
            for (i in 1..21100) {
                crypto_gzip_write(o, generate_data(i))
}
            o.close()
            decrypt_gzip_stream("data.aes.gz", iv)
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