package com.joseferreyra.ocr_kmm.data.local

import com.joseferreyra.ocr_kmm.database.OCRDatabase
import com.joseferreyra.ocr_kmm.database.getOCRDatabase

actual class DatabaseFactory ()
{
    actual fun create(): OCRDatabase {
        return getOCRDatabase( )
    }
}