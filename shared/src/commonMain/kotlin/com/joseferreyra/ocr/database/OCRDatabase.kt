package com.joseferreyra.ocr.database

import androidx.room.ConstructedBy
import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.RoomDatabaseConstructor
import com.joseferreyra.ocr.database.OCRSession


@Database(
    entities = [OCRSession::class],
    version = 1,
    exportSchema = false
)
@ConstructedBy(AppDatabaseConstructor::class)
abstract class OCRDatabase : RoomDatabase() {

    abstract fun ocrSessionDao(): OCRSessionDao

}

// The Room compiler generates the `actual` implementations.
@Suppress("NO_ACTUAL_FOR_EXPECT")
expect object AppDatabaseConstructor : RoomDatabaseConstructor<OCRDatabase> {
    override fun initialize(): OCRDatabase
}

const val DATABASE_NAME = "ocr_database.db"
