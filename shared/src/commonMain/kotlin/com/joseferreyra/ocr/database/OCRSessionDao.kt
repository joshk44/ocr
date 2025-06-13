package com.joseferreyra.ocr_kmm.database

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.MapColumn
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface OCRSessionDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(session: OCRSession)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(session: List<OCRSession>)

    @Query("SELECT * FROM ocr_session")
    fun getAllAsFlow(): Flow<List<OCRSession>>

    @Query("SELECT COUNT(*) as count FROM ocr_session")
    suspend fun count(): Int
}
