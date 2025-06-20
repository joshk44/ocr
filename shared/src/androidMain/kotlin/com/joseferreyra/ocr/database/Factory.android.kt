/*
 * Copyright 2024 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.joseferreyra.ocr.database

import android.app.Application
import androidx.room.Room
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import com.joseferreyra.ocr_kmm.database.DATABASE_NAME
import com.joseferreyra.ocr_kmm.database.OCRDatabase
import kotlinx.coroutines.Dispatchers

actual class Factory(
    private val app: Application,
) {
    actual fun createRoomDatabase(): OCRDatabase {
        val dbFile = app.getDatabasePath(DATABASE_NAME)
        return Room
            .databaseBuilder<OCRDatabase>(
                context = app,
                name = dbFile.absolutePath,
            ).setDriver(BundledSQLiteDriver())
            .setQueryCoroutineContext(Dispatchers.IO)
            .build()
    }
}
