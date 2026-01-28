package com.joseferreyra.ocr.interactor

import com.joseferreyra.ocr.domain.Resource
import com.joseferreyra.ocr.ocr.OCRProcessor

class ProcessOCRImage(
    private val ocrProcessor: OCRProcessor
) {
    suspend operator fun invoke(
        image: ByteArray
    ): Resource<List<String>> {
        try {
            val result = ocrProcessor.processImage(image)
            return Resource.Success(result)
        } catch (e: Exception) {
            return Resource.Error(e)
        }
    }
}