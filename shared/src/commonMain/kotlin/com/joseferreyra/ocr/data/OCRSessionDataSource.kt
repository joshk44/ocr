package com.joseferreyra.ocr_kmm.data

import com.joseferreyra.ocr_kmm.database.OCRSession
import kotlinx.coroutines.flow.Flow

interface OCRSessionDataSource {
    fun getListOfOCRSession(): Flow<List<OCRSession>>
    suspend fun insertSession(ocrSession: OCRSession)
}