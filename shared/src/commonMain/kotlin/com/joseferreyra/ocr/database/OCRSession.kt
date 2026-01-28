package com.joseferreyra.ocr.database

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "ocr_session")
data class OCRSession(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val dateTime: Long,
    val values: String
)

