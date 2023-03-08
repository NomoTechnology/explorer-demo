package com.example.explorer_demo

import io.flutter.embedding.android.FlutterActivity

import android.content.Intent
import androidx.annotation.NonNull
import br.com.nomo.explorer.service.ExplorerService
import br.com.nomo.explorer.utlis.IntentExplorerValues
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "explorer"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            val intent = Intent(this, ExplorerService::class.java)

            when (call.method) {
                "startExplorerService" -> {
                    startService(intent.putExtra(IntentExplorerValues.CUSTOM_KEY,/*MY_KEY*/))
                    result.success("Started!")
                }
                "stopExplorerService" -> {
                    startService(intent.putExtra(IntentExplorerValues.CUSTOM_KEY,/*MY_KEY*/))
                    result.success("Stopped!")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

