package com.example.quizactivity
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import kotlinx.android.synthetic.main.activity_main.*
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        true_button.setOnClickListener(fun (view: View?){
            d("martin", "true_button clicked!")
})
}
}