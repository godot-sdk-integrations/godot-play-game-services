package com.jacobibanez.plugin.android.godotplaygameservices.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import com.google.android.gms.common.images.ImageManager
import com.jacobibanez.plugin.android.godotplaygameservices.BuildConfig
import com.jacobibanez.plugin.android.godotplaygameservices.signals.HelperSignals
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin.emitSignal
import java.util.concurrent.Executors

private val ioExecutor = Executors.newSingleThreadExecutor()
const val USER_DIR = "user://"

fun savePngToDevice(godot: Godot, uri: Uri, fileName: String) {
    val context = godot.getActivity()!!.baseContext
    ImageManager.create(context).loadImage({ _, drawable, isRequestedDrawable ->
        if (!isRequestedDrawable || drawable !is BitmapDrawable) return@loadImage

        val bitmap = drawable.bitmap
        ioExecutor.execute {
            context.openFileOutput(fileName, Context.MODE_PRIVATE).use { out ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 90, out)
            }
            godot.runOnHostThread {
                emitSignal(
                    godot,
                    BuildConfig.GODOT_PLUGIN_NAME,
                    HelperSignals.imageStored,
                    buildFilePath(fileName)
                )
            }
        }
    }, uri)
}

fun Uri.toStringAndSave(godot: Godot, propertyName: String, key: String): String {
    val fileName = "${propertyName}_${key}.png"
    savePngToDevice(godot, this, fileName)
    return buildFilePath(fileName)
}

private fun buildFilePath(fileName: String): String = "$USER_DIR${fileName}"