package com.example.a02_jetpack_compose
import androidx.ui.layout.Column
import androidx.ui.layout.padding
import androidx.ui.layout.Spacer
import androidx.ui.layout.preferredHeight
import androidx.ui.layout.fillMaxSize
import androidx.ui.core.setContent
import androidx.ui.core.Modifier
import androidx.ui.foundation.Text
import androidx.ui.foundation.Canvas
import androidx.ui.material.MaterialTheme
import androidx.ui.material.TopAppBar
import androidx.ui.material.Button
import androidx.ui.geometry.Offset
import androidx.ui.graphics.Paint
import androidx.ui.graphics.Color
import androidx.ui.graphics.Path
import androidx.ui.graphics.PaintingStyle
import androidx.ui.text.style.TextOverflow
import androidx.compose.Model
import androidx.compose.Composable
import androidx.compose.state
import androidx.compose.MutableState
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.ui.unit.dp
import androidx.ui.tooling.preview.Preview
class MainActivity : AppCompatActivity() {
    val have_internet_permission_p: MutableState<Int> = state {
        0
}
    override fun request_permission_INTERNET(){
        if ( shouldShowRequestPermissionRationaleCompat(Manifest.permission.INTERNET) ) {
            requestPermissionCompat(arrayOf(Manifest.permission.INTERNET), format(, PERMISSION_REQUEST_~a, e))
} else {
            requestPermissionCompat(arrayOf(Manifest.permission.INTERNET), format(, PERMISSION_REQUEST_~a, e))
}
}
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray){
        (if ( (requestCode)==(format(, PERMISSION_REQUEST_~a, e)) ) {
            if ( &&((grantResults.size)==(1), (grantResults[0])==(PackageManager.PERMISSION_GRANTED)) ) {
                have_internet_permission_p.value=1
} else {
                have_internet_permission_p.value=0
}
})()
}
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
@Model data class Counter(var value: Int = 0)
@Composable fun NewsStory(){
    val counter_state: MutableState<Int> = state {
        0
}
    val counter2 = Counter()
    MaterialTheme {
        Column(modifier = Modifier.padding(16.dp)) {
            val _code_generation_time = "20:33:28 of Saturday, 2020-05-30 (GMT+1)"
            val _code_git_hash = "git:d42f3d0355738a79ebb9f7baa3add0c3d306ac7d"
            TopAppBar(title = {
                Text(text = _code_generation_time)
})
            Text(text = counter_state.value.toString())
            Text(text = counter2.value.toString())
            Button(onClick = {
                (counter_state.value)+=(5)
}) {
                Text(text = "Click to Add 5")
}
            Button(onClick = {
                (counter2.value)+=(15)
}) {
                Text(text = "Click to Add 15 to 2")
}
            Text("title atisrnt iasto aesnt arnstiea atansr enosrietan einsrt oaiesnt ars inoanesr tas astie na rienstodypbv kp vienkvtk ae nrtoanr arstioenasirn taoist oiasntinaie", style = MaterialTheme.typography.h2, maxLines = 2, overflow = TextOverflow.Ellipsis)
            Spacer(Modifier.preferredHeight(16.dp))
            Text("a day in shark fin cove", style = MaterialTheme.typography.body2)
            Text("davenport california", style = MaterialTheme.typography.body2)
            Text("dec 2018", style = MaterialTheme.typography.body2)
}
        val paint = Paint()
        paint.color=Color(4278190335)
        Canvas(modifier = Modifier.fillMaxSize()) {
            drawCircle(center = Offset(50f, 500f), radius = 40f, paint = paint)
            val path = Path()
            val paint_path = Paint()
            paint_path.color=Color.Red
            paint_path.strokeWidth=15f
            paint_path.style=PaintingStyle.stroke
            path.moveTo(50f, 500f)
            path.lineTo(55f, 550f)
            path.lineTo(105f, 650f)
            path.lineTo(305f, ((1250f)+(counter_state.value)))
            drawPath(path = path, paint = paint_path)
}
}
}
@Preview @Composable fun PreviewNewsStory(){
    NewsStory()
}