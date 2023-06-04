
- i think gpt-4 is halucinating about the uvc library
- i found this example file that implements uvc
  https://github.com/saki4510t/OpenCVwithUVC/blob/master/app/build.gradle

- here is a good discussion about the state of external cameras:
  https://stackoverflow.com/questions/57846505/accessing-a-usb-camera-using-android-camera2-api
  
  - android 11 doesn't seem to have reliable support

- try the sample for enumeration:
```
cd ~/src
git clone git@github.com:android/camera-samples.git
# 58MB
cd camera-samples
cd Camera2Video
./gradlew assembleRelease -x test

# starts downloading lots of stuff

```

- i try to open it in android studio in the hope that this downloads
  less
- i tried the app on android 11 and 7 and it doesn't list the external
  camera on any of them
