package com.joseferreyra.ocr

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform