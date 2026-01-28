plugins {
    // Para AGP 9.0+, no es necesario declarar kotlinAndroid si usas built-in Kotlin
    alias(libs.plugins.androidApplication).apply(false)
    alias(libs.plugins.androidLibrary).apply(false)
    alias(libs.plugins.kotlinMultiplatform).apply(false)
    alias(libs.plugins.compose.compiler).apply(false)
}
