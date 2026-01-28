package com.joseferreyra.ocr.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.CreationExtras
import androidx.lifecycle.viewmodel.MutableCreationExtras
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.joseferreyra.ocr.data.OCRSessionRepository
import com.joseferreyra.ocr.di.AppContainer
import com.joseferreyra.ocr.database.OCRSession
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

class OCRSessionListViewModel(
    private val repository: OCRSessionRepository
) : ViewModel() {

    val ocrSessionList: StateFlow<SessionListUIState> =
        repository
            .getListOfOCRSession()
            .map { SessionListUIState(it) }
            .stateIn(
                scope = viewModelScope,
                started = SharingStarted.WhileSubscribed(TIMEOUT_MILLIS),
                initialValue = SessionListUIState()
            )

    fun addSession(ocrSession: OCRSession) {
        viewModelScope.launch {
            repository.addSession(ocrSession)
        }
    }

    companion object {
        val APP_CONTAINER_KEY = CreationExtras.Key<AppContainer>()

        val Factory: ViewModelProvider.Factory = viewModelFactory {
            initializer {
                val appContainer = this[APP_CONTAINER_KEY] as AppContainer
                val repository = appContainer.dataRepository
                OCRSessionListViewModel(repository = repository)
            }
        }

        fun newCreationExtras(appContainer: AppContainer): CreationExtras =
            MutableCreationExtras().apply {
                set(APP_CONTAINER_KEY, appContainer)
            }
    }


}


data class SessionListUIState(
    val ocrSessionList: List<OCRSession> = emptyList()
)

private const val TIMEOUT_MILLIS = 5_000L
