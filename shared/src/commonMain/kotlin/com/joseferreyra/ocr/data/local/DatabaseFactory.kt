package com.joseferreyra.ocr_kmm.data.local

import com.joseferreyra.ocr_kmm.database.OCRDatabase

expect class DatabaseFactory {

    fun create(): OCRDatabase
}