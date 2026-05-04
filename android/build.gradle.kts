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
