allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Use internal drive for build to avoid ExFAT resource fork issues
// Temporarily commented out to allow Flutter to find the APK
// val newBuildDir: Directory =
//     rootProject.layout.buildDirectory
//         .dir(System.getProperty("java.io.tmpdir") + "flutter_builds/" + rootProject.name)
//         .get()
// rootProject.layout.buildDirectory.value(newBuildDir)
// 
// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
