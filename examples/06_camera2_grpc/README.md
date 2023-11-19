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

# camera2 

- this video is good for camera2 https://youtu.be/S-7H72UTiBU
- start with an empty view

