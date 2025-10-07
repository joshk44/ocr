package com.joseferreyra.ocr.android.screens

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.lifecycle.viewmodel.compose.viewModel
import com.joseferreyra.ocr.android.di.App
import com.joseferreyra.ocr.android.parseOCR
import com.joseferreyra.ocr.viewmodel.OCRSessionListViewModel
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun HomeScreen(onNavigateToScanResult: (String) -> Unit) {
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

        val context = LocalContext.current
        val photoURI = remember { mutableStateOf<Uri?>(null) }

        val hasPermission = remember {
            mutableStateOf(
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.CAMERA
                ) == PackageManager.PERMISSION_GRANTED
            )
        }

        val permissionLauncher = rememberLauncherForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted ->
            hasPermission.value = isGranted
            if (isGranted) {
                Toast.makeText(context, "Camera permission granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(context, "Camera permission is required", Toast.LENGTH_LONG).show()
            }
        }

        fun createImageFile(): File {
            val timeStamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
            val imageFileName = "JPEG_${timeStamp}_"

            // Use the internal cache directory to avoid permission issues
            val storageDir = File(context.cacheDir, "camera_photos")
            if (!storageDir.exists()) {
                storageDir.mkdirs()
            }

            return File.createTempFile(
                imageFileName,
                ".jpg",
                storageDir
            )
        }

        val cameraLauncher = rememberLauncherForActivityResult(
            ActivityResultContracts.TakePicture()
        ) { success ->
            if (success) {
                photoURI.value?.let { uri ->
                    try {
                        val inputStream = context.contentResolver.openInputStream(uri)
                        val bitmap = BitmapFactory.decodeStream(inputStream)
                        inputStream?.close()

                        if (bitmap != null) {
                            // Image captured successfully at full size
                            parseOCR(bitmap ,
                                onSuccess = { resultText ->
                                    onNavigateToScanResult(resultText)
                                },
                                onFailure = { errorMessage ->
                                    Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show()
                                }
                            )
                        } else {
                            Toast.makeText(context, "Error processing the image", Toast.LENGTH_SHORT).show()
                        }
                    } catch (e: Exception) {
                        Toast.makeText(context, "Error: ${e.message}", Toast.LENGTH_SHORT).show()
                    }
                }
            } else {
                Toast.makeText(context, "Camera permission is required", Toast.LENGTH_LONG).show()
            }
        }

        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Button(
                onClick = {
                    if (hasPermission.value) {
                        try {
                            // Create a temporary file to save the photo
                            val photoFile = createImageFile()
                            // Create the URI for the file using FileProvider
                            val uri = FileProvider.getUriForFile(
                                context,
                                "${context.packageName}.fileprovider",
                                photoFile
                            )
                            // Save the URI to use it later
                            photoURI.value = uri
                            // Launch the camera with the URI to save the full-size image
                            cameraLauncher.launch(uri)
                        } catch (e: Exception) {
                            Toast.makeText(context, "Error launching camera: ${e.message}", Toast.LENGTH_LONG).show()
                        }
                    } else {
                        permissionLauncher.launch(Manifest.permission.CAMERA)
                    }
                },
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary
                )
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Camera Icon",
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Open Camera",
                    style = MaterialTheme.typography.bodyLarge
                )
            }
        }
    }
}
