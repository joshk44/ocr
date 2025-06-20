package com.joseferreyra.ocr.android.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.layout.windowInsetsBottomHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.joseferreyra.ocr.android.di.App
import com.joseferreyra.ocr.viewmodel.OCRSessionListViewModel
import com.joseferreyra.ocr_kmm.database.OCRSession

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SessionsScreen() {
    Surface(modifier = Modifier.fillMaxSize()) {

        val app = LocalContext.current.applicationContext as App
        val extras = remember(app) {
            val container = app.container
            OCRSessionListViewModel.newCreationExtras(container)
        }
        val viewModel: OCRSessionListViewModel = viewModel(
            factory = OCRSessionListViewModel.Factory,
            extras = extras,
        )

        val uiState by viewModel.ocrSessionList.collectAsState()

        LazyColumn {
            items(uiState.ocrSessionList, key = { it.id }) {
                AnimatedVisibility(
                    visible = uiState.ocrSessionList.isNotEmpty(),
                    enter = fadeIn(tween(300)),
                    exit = fadeOut(tween(300)),
                ) {
                    OCRItem(it)
                }
            }

            item {
                Spacer(
                    Modifier.windowInsetsBottomHeight(
                        WindowInsets.systemBars,
                    ),
                )
            }
        }

    }
}

@Composable
fun OCRItem(
    item: OCRSession,
    modifier: Modifier = Modifier,
) {
    Card(
        modifier = modifier
            .padding(horizontal = 16.dp, vertical = 8.dp)
            .clip(RoundedCornerShape(8.dp)),
        shape = RoundedCornerShape(8.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface,
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 8.dp,
        ),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(
                modifier = Modifier
                    .heightIn(min = 96.dp),
                verticalArrangement = Arrangement.Center,
            ) {
                Text(
                    text = item.dateTime.toString(),
                    color = MaterialTheme.colorScheme.onBackground,
                    style = MaterialTheme.typography.titleMedium,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    modifier = Modifier
                        .padding(horizontal = 16.dp)
                        .padding(top = 8.dp),
                )
                Text(
                    text = item.values,
                    modifier = Modifier
                        .padding(horizontal = 16.dp)
                        .padding(bottom = 8.dp),
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }
    }
}

@Preview
@Composable
fun ItemPreview() {
    OCRItem(
        OCRSession(1, 12212, "Sample values")
    )
}