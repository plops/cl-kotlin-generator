package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import androidx.renderscript.*
import android.os.Bundle
import android.content.Context
import java.util.Arrays
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)
        d("martin", "onCreate")
        setContentView(R.layout.activity_main)
        example()
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
    private
    fun example(){
        val _rs = RenderScript.create(this)
        val input_array = intArrayOf(0, 1, 2, 3, 4, 5, 6, 7, 8)
        val input_alloc = (fun (): Allocation {
            val res = Allocation.createSized(_rs, Element.I32(_rs), input_array.size)
            res.copyFrom(input_array)
            return res
})()
        val output_array = IntArray(input_array.size)
        val output_alloc = Allocation.createSized(_rs, Element.I32(_rs), input_array.size)
        val myscript = ScriptC_sum(_rs)
        myscript.forEach_sum2(input_alloc, output_alloc)
        output_alloc.copyTo(output_array)
        val str0 = Arrays.toString(input_array)
        val str1 = Arrays.toString(output_array)
        d("martin", str0)
        d("martin", str1)
}
}