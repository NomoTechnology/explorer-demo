package com.example.flutter_native_library

import android.content.Intent
import androidx.annotation.NonNull
import br.com.nomo.explorer.service.ExplorerService
import explorer.src.
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "explorer"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            when (call.method) {
                "startExplorerService" -> {
                    startService(Intent(this, ExplorerService::class.java))
                    result.success("Started!")
                }
                "stopExplorerService" -> {
                    stopService(Intent(this, ExplorerService::class.java))
                    result.success("Stopped!")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
