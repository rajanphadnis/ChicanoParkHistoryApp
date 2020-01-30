package com.example.chicano_park;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.ml.common.FirebaseMLException;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.automl.FirebaseAutoMLLocalModel;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabel;
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabeler;
import com.google.firebase.ml.vision.label.FirebaseVisionOnDeviceAutoMLImageLabelerOptions;

import java.io.IOException;
import java.util.List;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("runModel")) {
                                //FirebaseApp.initializeApp(this);
                                FirebaseAutoMLLocalModel localModel = new FirebaseAutoMLLocalModel.Builder()
                                        .setAssetFilePath("ml/manifest.json")
                                        .build();
                                FirebaseVisionImageLabeler labeler;
                                try {
                                    FirebaseVisionOnDeviceAutoMLImageLabelerOptions options =
                                            new FirebaseVisionOnDeviceAutoMLImageLabelerOptions.Builder(localModel)
                                                    .setConfidenceThreshold(0.2f)  // Evaluate your model in the Firebase console
                                                    // to determine an appropriate value.
                                                    .build();
                                    labeler = FirebaseVision.getInstance().getOnDeviceAutoMLImageLabeler(options);

                                    FirebaseVisionImage image;
                                    try {
                                        image = FirebaseVisionImage.fromFilePath(this, Uri.parse("file://" + call.argument("path").toString()));

                                        labeler.processImage(image)
                                                .addOnSuccessListener(new OnSuccessListener<List<FirebaseVisionImageLabel>>() {
                                                    public String texet;
                                                    public float conf;
                                                    @Override
                                                    public void onSuccess(List<FirebaseVisionImageLabel> labels) {
                                                        texet = labels.get(0).getText();
                                                        conf = labels.get(0).getConfidence();
                                                        result.success(texet + ":" + conf);
                                                    }
                                                })
                                                .addOnFailureListener(new OnFailureListener() {
                                                    @Override
                                                    public void onFailure(@NonNull Exception e) {
                                                        // Task failed with an exception
                                                        // ...
                                                        result.error("MODELFAIL", e.toString(), null);
                                                    }
                                                });
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                        result.error("FILEFAIL", e.toString(), null);
                                    }
                                } catch (FirebaseMLException e) {
                                    // ...
                                    result.error("LABELFAIL", e.toString(), null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
