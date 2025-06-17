package com.joseferreyra.ocr.android.screens

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun AboutScreen() {
    Surface(modifier = Modifier.fillMaxSize()) {
        Text(
            text = "About Screen",
            style = MaterialTheme.typography.headlineMedium
        )
    }
}
