package com.joseferreyra.ocr.ocr

actual class OCRProcessorFactory {
    actual fun create(): OCRProcessor {
        return object : OCRProcessor {
            override suspend fun processImage(image: ByteArray): List<String> {
                // Placeholder implementation for Android
                return listOf("Processed image on IOS")
            }
        }
    }
}