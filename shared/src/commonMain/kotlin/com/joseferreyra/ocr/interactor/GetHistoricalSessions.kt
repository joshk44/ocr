package com.joseferreyra.ocr_kmm.interactor

import com.joseferreyra.ocr_kmm.data.OCRSessionDataSource
import com.joseferreyra.ocr_kmm.database.OCRSession
import com.joseferreyra.ocr_kmm.domain.Resource
import kotlinx.coroutines.flow.Flow

class GetHistoricalSessions(
    private val OCRSessionDataSource: OCRSessionDataSource
) {
    suspend operator fun invoke(): Resource<Flow<List<OCRSession>>> {
        return try {
            Resource.Success(OCRSessionDataSource.getListOfOCRSession())
        } catch (e: Exception) {
            Resource.Error(e)
        }
    }

}