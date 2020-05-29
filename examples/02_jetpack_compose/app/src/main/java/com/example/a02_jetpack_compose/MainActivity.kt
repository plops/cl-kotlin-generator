package com.example.a02_jetpack_compose
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.Composable
import androidx.ui.core.setContent
import androidx.ui.foundation.Text
import androidx.ui.layout.Column
import androidx.ui.tooling.preview.Preview
class MainActivity : AppCompatActivity() {
    override fun onCreate(saved_instance_state: Bundle?){
        super.onCreate(saved_instance_state)
        setContent {
            NewsStory()
}
}
}
@Composable fun Greeting(name: String){
    Text("Hello $name!")
}
@Preview @Composable fun PreviewGreeting(){
    Greeting("Android")
}
@Composable fun NewsStory(){
    Column {
        Text("a day in shark fin cove")
        Text("davenport california")
        Text("dec 2018")
}
}
@Preview @Composable fun PreviewNewsStory(){
    NewsStory()
}