package com.joseferreyra.ocr.data

import com.joseferreyra.ocr.database.OCRSession

class OCRSessionDataSourceLocal(
    database: com.joseferreyra.ocr.database.OCRDatabase
) : OCRSessionDataSource {

    private val ocrSessionDao = database.ocrSessionDao()

    override fun getListOfOCRSession(): kotlinx.coroutines.flow.Flow<List<OCRSession>> {
        return ocrSessionDao.getAllAsFlow()
    }

    override suspend fun insertSession(ocrSession: OCRSession) {
        ocrSessionDao.insert(ocrSession)
    }
}