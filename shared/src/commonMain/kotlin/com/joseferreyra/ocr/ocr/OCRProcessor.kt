package com.joseferreyra.ocr.ocr

interface OCRProcessor {
    suspend fun processImage(image: ByteArray): List<String>
}