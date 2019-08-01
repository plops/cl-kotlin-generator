package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.os.Bundle
import android.content.Context
import com.example.learn.LoginRequest
import com.example.learn.LoginServiceGrpc
import io.grpc.ManagedChannel
import io.grpc.okhttp.OkHttpChannelBuilder
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        val connection_channel: ManagedChannel by lazy{
            OkHttpChannelBuilder.forAddress("192.168.1.104", 8080).usePlaintext().build()
}
        val login_service = LoginServiceGrpc.newBlockingStub(connection_channel)
        val request_message = LoginRequest.newBuilder().setUsername("bla").setPassword("foo").build()
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