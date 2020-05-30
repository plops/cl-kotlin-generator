package com.example.a02_jetpack_compose
import androidx.ui.layout.Column
import androidx.ui.layout.padding
import androidx.ui.layout.Spacer
import androidx.ui.layout.preferredHeight
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.Composable
import androidx.ui.core.setContent
import androidx.ui.core.Modifier
import androidx.ui.foundation.Text
import androidx.ui.unit.dp
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
    Column(modifier = Modifier.padding(16.dp)) {
        Text("title")
        Spacer(Modifier.preferredHeight(16.dp))
        Text("a day in shark fin cove")
        Text("davenport california")
        Text("dec 2018")
}
}
@Preview @Composable fun PreviewNewsStory(){
    NewsStory()
}