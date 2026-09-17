package com.example.guruji

import android.content.Intent
import android.net.Uri
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "guruji/whatsapp_share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "shareImageToWhatsApp" -> {
                        val filePath = call.argument<String>("filePath")
                        val text = call.argument<String>("text").orEmpty()

                        if (filePath.isNullOrBlank()) {
                            result.error("invalid_path", "File path is required.", null)
                            return@setMethodCallHandler
                        }

                        try {
                            shareImageToWhatsApp(filePath, text)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("share_failed", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun shareImageToWhatsApp(filePath: String, text: String) {
        val file = File(filePath)
        if (!file.exists()) {
            throw IllegalArgumentException("Shared file does not exist.")
        }

        val uri: Uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.fileprovider",
            file
        )

        val extension = file.extension.lowercase()
        val mimeType = MimeTypeMap.getSingleton()
            .getMimeTypeFromExtension(extension)
            ?: "image/*"

        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = mimeType
            `package` = "com.whatsapp"
            putExtra(Intent.EXTRA_STREAM, uri)
            putExtra(Intent.EXTRA_TEXT, text)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            clipData = android.content.ClipData.newRawUri("shared_image", uri)
        }

        val packageManager = applicationContext.packageManager
        if (shareIntent.resolveActivity(packageManager) == null) {
            throw IllegalStateException("WhatsApp is not installed.")
        }

        applicationContext.grantUriPermission(
            "com.whatsapp",
            uri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION
        )

        startActivity(shareIntent)
    }
}
