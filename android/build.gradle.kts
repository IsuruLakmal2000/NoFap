allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory = layout.projectDirectory.dir("../build")

subprojects {
    project.layout.buildDirectory = rootProject.layout.buildDirectory.dir(project.name)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

