package com.example.quizactivity
import androidx.appcompat.app.AppCompatActivity
import android.util.Log.d
import android.renderscript.*
import android.os.Bundle
import android.content.Context
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
        val input_array = IntArrayOf(0, 1, 2, 3, 4, 5, 6, 7, 8)
        val input_alloc = fun (): Allocation {
            val res = Allocation.createSized(_rs, Element.I32(_rs), input_array.length)
            res.copyFrom(input_array)
            return res
}
        val output_array = IntArray(input_array.length)
        val output_alloc = Allocation.createSized(_rs, Element.I32(_rs), input_array.length)
        val myscript = ScriptC_sum(_rs)
        myscript.forEach_sum2(input_alloc, output_alloc)
        d("martin", "output {$output_array[0]}, {$output_array[1]}, {$output_array[2]}, {$output_array[3]}, {$output_array[4]}, {$output_array[5]}, {$output_array[6]}, {$output_array[7]}, {$output_array[8]}")
}
}