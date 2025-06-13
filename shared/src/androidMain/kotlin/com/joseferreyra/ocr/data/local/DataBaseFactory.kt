package com.joseferreyra.ocr_kmm.data.local

import android.content.Context
import com.joseferreyra.ocr_kmm.database.OCRDatabase
import com.joseferreyra.ocr_kmm.database.getOCRDatabase

actual class DatabaseFactory (
    private val context: Context)
{
    actual fun create(): com.joseferreyra.ocr_kmm.database.OCRDatabase {
        return getOCRDatabase(context )
    }
}

