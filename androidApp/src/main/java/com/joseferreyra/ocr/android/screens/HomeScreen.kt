package com.joseferreyra.ocr.android.screens

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.lifecycle.viewmodel.compose.viewModel
import com.joseferreyra.ocr.android.di.App
import com.joseferreyra.ocr.viewmodel.OCRSessionListViewModel
import com.joseferreyra.ocr_kmm.database.OCRSession

@Composable
fun HomeScreen() {
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
                // Launch camera if permission is granted
                try {
                    val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                    context.startActivity(intent)
                } catch (e: Exception) {
                    Log.e("CameraError", "Error launching camera: ${e.message}", e)
                    Toast.makeText(context, "Error launching camera: ${e.message}", Toast.LENGTH_LONG).show()
                }
            } else {
                Toast.makeText(context, "Camera permission is required", Toast.LENGTH_LONG).show()
            }
        }

        val cameraLauncher = rememberLauncherForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            // Handle the camera result here
            Log.d("CameraResult", "Received result: ${result.resultCode}")
            if (result.resultCode == android.app.Activity.RESULT_OK) {
                val imageBitmap = result.data?.extras?.get("data")
                if (imageBitmap != null) {
                    Log.d("CameraResult", "Image captured successfully")
                    Toast.makeText(context, "Image captured successfully", Toast.LENGTH_SHORT).show()
                    // Aquí podrías procesar la imagen para OCR
                }
            } else {
                Log.d("CameraResult", "Camera was cancelled or failed")
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
                            val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                            cameraLauncher.launch(intent)
                        } catch (e: Exception) {
                            Log.e("CameraError", "Error launching camera: ${e.message}", e)
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
        initializeDatabase(viewModel)
    }
}

fun initializeDatabase(viewModel: OCRSessionListViewModel) {
    viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 1"))
    viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 2"))
    viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 3"))
    viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 4"))
}
