package com.joseferreyra.ocr.android

import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation3.runtime.NavEntry
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.rememberNavBackStack
import androidx.navigation3.ui.NavDisplay
import com.joseferreyra.ocr.android.screens.MainView
import com.joseferreyra.ocr.android.screens.ScanResult
import com.joseferreyra.ocr.android.themes.MyApplicationTheme
import kotlinx.serialization.Serializable

@Serializable
private data object MainViewRoute: NavKey

@Serializable
private data class DetailRoute (val scannedText: String): NavKey

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        setEdgeToEdgeConfig()
        super.onCreate(savedInstanceState)

        setContent {
            val backStack = rememberNavBackStack (MainViewRoute)

            NavDisplay(
                backStack = backStack,
                onBack = { backStack.removeLastOrNull() },
                entryProvider = { key ->
                    when (key) {
                        is MainViewRoute -> NavEntry(key) {
                            MyApplicationTheme {
                                Surface(
                                    modifier = Modifier.fillMaxSize(),
                                    color = MaterialTheme.colorScheme.background
                                ) {
                                    MainView(
                                        onNavigateToScanResult = { text ->
                                            backStack.add(DetailRoute(text))
                                        }
                                    )
                                }
                            }
                        }
                        is DetailRoute ->  NavEntry(key)  {
                            MyApplicationTheme {
                                Surface(
                                    modifier = Modifier.fillMaxSize(),
                                    color = MaterialTheme.colorScheme.background
                                ) {
                                    ScanResult (key.scannedText)
                                }
                            }
                        }
                        else -> error("Unknown route: $key")
                    }
                }
            )
        }
    }
}

@Composable
fun GreetingView(text: String) {
    Text(text = text)
}

@Preview
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        MainView(
            onNavigateToScanResult = { text ->
                // This is just a preview, so we won't navigate anywhere.
                println("Navigating to scan result with text: $text")
            }
        )
    }
}


fun ComponentActivity.setEdgeToEdgeConfig() {
    enableEdgeToEdge()
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        // Force the 3-button navigation bar to be transparent
        // See: https://developer.android.com/develop/ui/views/layout/edge-to-edge#create-transparent
        window.isNavigationBarContrastEnforced = false
    }
}
