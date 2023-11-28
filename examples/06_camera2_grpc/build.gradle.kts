// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.1.4" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
    kotlin("jvm") version "1.8.0" apply false
    id("com.google.protobuf") version "0.9.4" apply false
}

group = "io.grpc"
version = "1.4.1" // CURRENT_GRPC_KOTLIN_VERSION
   
ext["grpcVersion"] = "1.57.2"
ext["protobufVersion"] = "3.24.1"
