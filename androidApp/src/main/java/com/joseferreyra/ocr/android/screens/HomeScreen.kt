package com.joseferreyra.ocr.android.screens

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.MediaStore
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.mutableStateOf
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
                val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                if (intent.resolveActivity(context.packageManager) != null) {
                    context.startActivity(intent)
                }
            }
        }

        val cameraLauncher = rememberLauncherForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            // Handle the camera result here if needed
            // e.g., save the image, process it for OCR, etc.
        }

        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Button(
                onClick = {
                    if (hasPermission.value) {
                        // Permission already granted, launch camera directly
                        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                        if (intent.resolveActivity(context.packageManager) != null) {
                            cameraLauncher.launch(intent)
                        }
                    } else {
                        // Request camera permission
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



        viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 1"))
        viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 2"))
        viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 3"))
        viewModel.addSession(OCRSession(0, System.currentTimeMillis(), "Session 4"))
    }
}