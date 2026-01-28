package com.joseferreyra.ocr.data

import com.joseferreyra.ocr.database.OCRSession
import kotlinx.coroutines.flow.Flow

interface OCRSessionDataSource {
    fun getListOfOCRSession(): Flow<List<OCRSession>>
    suspend fun insertSession(ocrSession: OCRSession)
}