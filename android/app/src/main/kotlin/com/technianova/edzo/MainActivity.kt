package com.technianova.edzo

import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter/secure"

    private var initialLink: String? = null

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intent.data?.toString()?.let {
            initialLink = it
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("onDeepLink", it)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Capture initial link if launched from deep link
        intent?.data?.toString()?.let {
            initialLink = it
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialLink" -> {
                        result.success(initialLink)
                        initialLink = null // Clear after first retrieval
                    }
                    "setSecure" -> {
                        val enable = call.argument<Boolean>("enable") ?: false
                        if (enable) {
                            window.setFlags(
                                WindowManager.LayoutParams.FLAG_SECURE,
                                WindowManager.LayoutParams.FLAG_SECURE
                            )
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    "takeScreenshot" -> {
                        captureScreenshot(result)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun captureScreenshot(result: MethodChannel.Result) {
        val window = this.window
        val bitmap = Bitmap.createBitmap(window.decorView.width, window.decorView.height, Bitmap.Config.ARGB_8888)
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PixelCopy.request(window, bitmap, { copyResult ->
                if (copyResult == PixelCopy.SUCCESS) {
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    result.success(stream.toByteArray())
                } else {
                    result.error("ERROR", "PixelCopy failed with code $copyResult", null)
                }
            }, Handler(Looper.getMainLooper()))
        } else {
            // Fallback for older devices (API < 26)
            try {
                val canvas = android.graphics.Canvas(bitmap)
                window.decorView.draw(canvas)
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                result.success(stream.toByteArray())
            } catch (e: Exception) {
                result.error("ERROR", e.message, null)
            }
        }
    }
}