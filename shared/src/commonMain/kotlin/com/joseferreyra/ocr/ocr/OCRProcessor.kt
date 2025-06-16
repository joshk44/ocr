package com.joseferreyra.ocr_kmm.ocr

interface OCRProcessor {
    suspend fun processImage(image: ByteArray): List<String>
}