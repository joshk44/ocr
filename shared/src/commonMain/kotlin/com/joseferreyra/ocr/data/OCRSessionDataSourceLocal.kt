package com.joseferreyra.ocr_kmm.data

class OCRSessionDataSourceLocal(
    database: com.joseferreyra.ocr_kmm.database.OCRDatabase
) : OCRSessionDataSource {

    private val ocrSessionDao = database.ocrSessionDao()

    override fun getListOfOCRSession(): kotlinx.coroutines.flow.Flow<List<com.joseferreyra.ocr_kmm.database.OCRSession>> {
        return ocrSessionDao.getAllAsFlow()
    }

    override suspend fun insertSession(ocrSession: com.joseferreyra.ocr_kmm.database.OCRSession) {
        ocrSessionDao.insert(ocrSession)
    }
}