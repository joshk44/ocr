package com.joseferreyra.ocr.interactor

import com.joseferreyra.ocr.data.OCRSessionRepository
import com.joseferreyra.ocr.database.OCRSession
import com.joseferreyra.ocr.domain.Resource
import kotlinx.coroutines.flow.Flow

class GetHistoricalSessions(
    private val ocrSessionRepository: OCRSessionRepository
) {
    suspend operator fun invoke(): Resource<Flow<List<OCRSession>>> {
        return try {
            Resource.Success(ocrSessionRepository.getListOfOCRSession())
        } catch (e: Exception) {
            Resource.Error(e)
        }
    }

}