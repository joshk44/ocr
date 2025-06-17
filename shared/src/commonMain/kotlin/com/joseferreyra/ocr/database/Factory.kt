package com.joseferreyra.ocr.database

import com.joseferreyra.ocr_kmm.database.OCRDatabase

expect class Factory {
    fun createRoomDatabase(): OCRDatabase
}