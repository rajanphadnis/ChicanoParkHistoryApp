package com.example.c_p

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // Note: this method is invoked on the main thread.
      // TODO
      val localModel = FirebaseAutoMLLocalModel.Builder()
        .setAssetFilePath("manifest.json")
        .build()
        val options = FirebaseVisionOnDeviceAutoMLImageLabelerOptions.Builder(localModel)
    .setConfidenceThreshold(0)  // Evaluate your model in the Firebase console
                                // to determine an appropriate value.
    .build()
val labeler = FirebaseVision.getInstance().getOnDeviceAutoMLImageLabeler(options)
val image: FirebaseVisionImage
val stringToReturn
try {
    image = FirebaseVisionImage.fromFilePath(context, call)
} catch (e: IOException) {
    e.printStackTrace()
}
labeler.processImage(image)
        .addOnSuccessListener { labels ->
            // Task completed successfully
            // ...
            for (label in labels) {
    val text = label.text
    val confidence = label.confidence
    stringToReturn = stringToReturn.plus(text).plus(":").plus(confidence).plus(";")
}
return stringToReturn
        }
        .addOnFailureListener { e ->
            // Task failed with an exception
            // ...
            return e
        }
        
    }
    }
}
