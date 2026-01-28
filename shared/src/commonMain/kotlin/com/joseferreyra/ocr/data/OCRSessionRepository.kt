package com.joseferreyra.ocr.data

import com.joseferreyra.ocr.data.OCRSessionDataSource
import com.joseferreyra.ocr.database.OCRSession
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class OCRSessionRepository(
    private val ocrSessionDataSource: OCRSessionDataSource,
    private val scope: CoroutineScope
) {

    fun addSession(ocrSession: OCRSession) {
        scope.launch {
            ocrSessionDataSource.insertSession(ocrSession)
        }
    }

    fun getListOfOCRSession() = ocrSessionDataSource.getListOfOCRSession()
}