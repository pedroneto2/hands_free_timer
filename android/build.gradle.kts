allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Force 16 KB-compatible versions of vosk-android and JNA, overriding what
// vosk_flutter's build.gradle declares (0.3.46 and 5.13.0 respectively).
subprojects {
    configurations.all {
        resolutionStrategy {
            force("com.alphacephei:vosk-android:0.3.75")
            force("net.java.dev.jna:jna:5.16.0")
        }
    }
}

// Suppress obsolete Java source/target, unchecked-cast, and deprecated-API
// warnings that originate from third-party plugin dependencies (vosk_flutter,
// google_mobile_ads, etc.). Our own app module is already on Java 17.
subprojects {
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.addAll(
            listOf("-Xlint:-options", "-Xlint:-unchecked", "-Xlint:-deprecation")
        )
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
