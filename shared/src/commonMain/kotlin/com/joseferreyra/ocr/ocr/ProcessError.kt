package com.joseferreyra.ocr.ocr

enum class ProcessError {
    NO_OCR_ENGINE,
    NO_IMAGE,
    IMAGE_TOO_LARGE,
    OCR_ENGINE_ERROR,
    UNKNOWN_ERROR;

    override fun toString(): String {
        return when (this) {
            NO_OCR_ENGINE -> "No OCR engine available"
            NO_IMAGE -> "No image provided"
            IMAGE_TOO_LARGE -> "Image is too large to process"
            OCR_ENGINE_ERROR -> "Error occurred in the OCR engine"
            UNKNOWN_ERROR -> "An unknown error occurred"
        }
    }
}

class OCRProcessException(val error: ProcessError) : Exception(error.toString()) {
    override fun toString(): String {
        return "OCRProcessException: $error"
    }
}