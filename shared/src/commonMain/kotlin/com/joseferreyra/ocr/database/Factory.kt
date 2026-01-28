package com.joseferreyra.ocr.database

import com.joseferreyra.ocr.database.OCRDatabase

expect class Factory {
    fun createRoomDatabase(): OCRDatabase
}