package com.joseferreyra.ocr.android.screens

import android.icu.number.Scale
import android.net.wifi.ScanResult
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview

@Composable
fun ScanResult (text: String) {

    Text(
        "Scan Result: $text",
    )
}

@Composable
@Preview
fun ScanResultPreview() {
    ScanResult(text = "Sample Scan Result")
}