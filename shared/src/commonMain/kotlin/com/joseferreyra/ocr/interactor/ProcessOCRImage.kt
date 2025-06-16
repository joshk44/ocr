package com.joseferreyra.ocr_kmm.interactor

import com.joseferreyra.ocr_kmm.domain.Resource
import com.joseferreyra.ocr_kmm.ocr.OCRProcessor

class ProcessOCRImage(
    private val ocrProcessor: OCRProcessor
) {
    suspend operator fun invoke (
        image:ByteArray
    ): Resource<List<String>> {
        try {
            val result = ocrProcessor.processImage(image)
            return Resource.Success(result)
        } catch (e: Exception) {
            return Resource.Error(e)
        }
    }
}