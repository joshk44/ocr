package com.joseferreyra.ocr.android

import android.graphics.Bitmap
import android.util.Log
import androidx.collection.intIntMapOf
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.asAndroidBitmap
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

fun parseOCR(bitmap: Bitmap,
             onSuccess: (String) -> Unit,
             onFailure: (String) -> Unit): Unit {
    val textRecognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)


    textRecognizer.process(InputImage.fromBitmap(bitmap, 0))
        .addOnSuccessListener { visionText ->
            onSuccess(visionText.text)
        }
        .addOnFailureListener {
            onFailure ("Error: ${it.message ?: "Unknown error"}")
        }
}


