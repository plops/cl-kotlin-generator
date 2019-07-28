package com.example.quizactivity
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import kotlinx.android.synthetic.main.activity_main.*
class MainActivity : AppCompatActivity() {
    var _count = 0
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        true_button.setOnClickListener(fun (view: View?){
            d("martin", "true_button clicked!")
})
}
    override fun onSaveInstanceState(savedInstanceState: Bundle){
        super.onSaveInstanceState(savedInstanceState)
        (_count)++
        d("martin", "onSaveInstanceState {$_count}")
        // none
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