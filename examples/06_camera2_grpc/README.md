- i want to expose camera2 functionality with a grpc interface

# grpc
- i haven't found proper instructions how to add grpc server to an
  android studio project
  - i watched this video but it didn't help with my issue: https://youtu.be/88syHWoe6fc
- wire seems to be installable for android: https://square.github.io/wire/#wire-kotlin
- maybe wire is easier to install than grpc 

- protobuf gradle plugin https://youtu.be/D-vuRmuSwUA?t=1592

- https://github.com/grpc/grpc-kotlin/blob/master/build.gradle.kts


To make gRPC and Protobuf available in your Android project, you need
to modify your `build.gradle.kts` file to include the necessary
plugins and dependencies.

Here is how you can modify your existing `build.gradle.kts` file:
   
```kotlin  
// Top-level build file where you can add configuration options common to all sub-projects/modules.  
plugins {  
    id("com.android.application") version "8.1.3" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
    kotlin("jvm") version "1.8.0" apply false
    id("com.google.protobuf") version "0.9.4" apply false
    id("org.gradle.test-retry") version "1.5.6"
    id("io.github.gradle-nexus.publish-plugin") version "1.3.0"
}  
   
group = "io.grpc"
version = "1.4.1" // CURRENT_GRPC_KOTLIN_VERSION
   
ext["grpcVersion"] = "1.57.2"
ext["protobufVersion"] = "3.24.1"
ext["coroutinesVersion"] = "1.7.3"
   
subprojects {  
  
    apply {  
        plugin("java")  
        plugin("org.jetbrains.kotlin.jvm")  
        plugin("com.google.protobuf")  
        plugin("org.gradle.test-retry")  
        plugin("maven-publish")  
        plugin("signing")  
    }  
  
    // gradle-nexus/publish-plugin needs these here too  
    group = rootProject.group  
    version = rootProject.version  
  
    repositories {  
        mavenCentral()  
    }  
  
    tasks.withType<JavaCompile> {  
        sourceCompatibility = JavaVersion.VERSION_1_8.toString()  
        targetCompatibility = JavaVersion.VERSION_1_8.toString()  
    }  
  
    tasks.withType<KotlinCompile> {  
        kotlinOptions {  
            freeCompilerArgs = listOf("-Xjsr305=strict")  
            jvmTarget = JavaVersion.VERSION_1_8.toString()  
        }  
    }  
  
    // Include the rest of the build.gradle.kts file here...  
}  
```  
   
This script does the following:

1. It applies the necessary plugins for your project: `kotlin("jvm")`,
   `com.google.protobuf`, `org.gradle.test-retry`,
   `io.github.gradle-nexus.publish-plugin`.

2. It sets the `group` and `version` for your project, which are used
   when publishing your project.

3. It defines some project-wide properties in `ext` for the versions
   of gRPC, Protobuf, and coroutines.

4. In the `subprojects` block, it applies the necessary plugins for
   each of your subprojects, configures the `group` and `version` for
   each subproject, and adds `mavenCentral()` to the list of
   repositories for resolving dependencies.

5. It configures the source and target compatibility versions for Java
   and Kotlin compilation tasks.
  
Remember to also add the specific gRPC and Protobuf dependencies in
the `dependencies` block of your module-level `build.gradle.kts` file.

Also, remember that for a real Android project, you need to replace
the versions in `ext` with the versions that are compatible with your
project.


This script is a starting point, you might need to make further
changes based on your specific needs and project structure.

### android grpc server using okhttp

https://github.com/grpc/grpc-java/issues/9676


Cronet is client-only.  Historically we have not  supported any HTTP/2
server on Android. But since 1.49 we added OkHttpServerBuilder, so I'd
recommend that if you need a server on Android.

I'll also note for Android we have the Binder transport, but that's
for device-local RPCs.

https://github.com/grpc/grpc-java/blob/master/examples/src/main/java/io/grpc/examples/helloworld/HelloWorldServer.java

```
    int port = 50051;
    server = Grpc.newServerBuilderForPort(port, InsecureServerCredentials.create())
        .addService(new GreeterImpl())
        .build()
        .start();
```

But replace ServerBuilder with OkHttpServerBuilder.

(At some point we'll hook up OkHttpServerBuilder into the
ServerBuilder.forPort() API, so you could just use the ServerBuilder
API. But we haven't done that as of yet.)

#### grpc binder transport

https://chromium.googlesource.com/external/github.com/grpc/grpc/+/HEAD/examples/android/binder/java/io/grpc/binder/cpp/exampleserver/native.cc

```
  static GreeterService service;
  grpc::ServerBuilder server_builder;
  server_builder.RegisterService(&service);
  JavaVM* jvm;
  {
    jint result = env->GetJavaVM(&jvm);
    assert(result == 0);
  }
  server_builder.AddListeningPort(
      "binder:example.service",
      grpc::experimental::BinderServerCredentials(
          std::make_shared<
              grpc::experimental::binder::SameSignatureSecurityPolicy>(
              jvm, context)));
```

The gRFC L73 for a BinderChannel in gRPC has been posted:
https://github.com/grpc/proposal/pull/191 . Mailing list discussion:
https://groups.google.com/d/msg/grpc-io/RFmjrxdtwzE/dW5HdkbDBgAJ .

## android netty grpc server

https://stackoverflow.com/questions/65781232/grpc-server-for-android

```
[...] if you need a HTTP/2 gRPC server on Android and don't care about
TLS and performance (e.g., for use in tests), then I'd expect
grpc-netty to mostly "just work." You may experience an error during
compilation about duplicate files in META-INF/services, but that can
be resolved with packagingOptions (ideally "merge", but "pickFirst"
probably functions).
```
https://github.com/saturnism/grpc-by-example-java/blob/master/simple-grpc-server/src/main/java/com/example/grpc/server/MyGrpcServer.java

https://www.baeldung.com/kotlin/grpc

https://grpc.io/docs/platforms/android/kotlin/quickstart/
gRPC Kotlin does not support running a server on an Android device. For this quick start, the Android client app will connect to a server running on your local (non-Android) computer.
https://github.com/grpc/grpc-kotlin/blob/master/examples/android/build.gradle.kts

## android kotlin grpc client

- also shows gradle configuration

https://proandroiddev.com/connecting-android-apps-with-server-using-grpc-919719bd9a97

- official doc for client:
https://grpc.io/docs/platforms/android/java/basics/
https://github.com/grpc/grpc-java/blob/v1.59.1/README.md


For Android client, use grpc-okhttp instead of grpc-netty-shaded and
grpc-protobuf-lite instead of grpc-protobuf:

```
implementation 'io.grpc:grpc-okhttp:1.59.1'
implementation 'io.grpc:grpc-protobuf-lite:1.59.1'
implementation 'io.grpc:grpc-stub:1.59.1'
compileOnly 'org.apache.tomcat:annotations-api:6.0.53' // necessary for Java 9+
```

For Android protobuf-based codegen integrated with the Gradle build
system, also use protobuf-gradle-plugin but specify the 'lite'
options:

```
plugins {
    id 'com.google.protobuf' version '0.9.4'
}

protobuf {
  protoc {
    artifact = "com.google.protobuf:protoc:3.22.3"
  }
  plugins {
    grpc {
      artifact = 'io.grpc:protoc-gen-grpc-java:1.59.1'
    }
  }
  generateProtoTasks {
    all().each { task ->
      task.builtins {
        java { option 'lite' }
      }
      task.plugins {
        grpc { option 'lite' }
      }
    }
  }
}
```

## android C++ grpc server example

https://github.com/grpc/grpc/tree/master/examples/android/helloworld



# camera2 

- this video is good for camera2 https://youtu.be/S-7H72UTiBU
- start with an empty view


