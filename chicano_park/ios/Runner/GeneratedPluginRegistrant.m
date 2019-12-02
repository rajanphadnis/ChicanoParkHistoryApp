//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<camera/CameraPlugin.h>)
#import <camera/CameraPlugin.h>
#else
@import camera;
#endif

#if __has_include(<cloud_firestore/CloudFirestorePlugin.h>)
#import <cloud_firestore/CloudFirestorePlugin.h>
#else
@import cloud_firestore;
#endif

#if __has_include(<firebase_core/FirebaseCorePlugin.h>)
#import <firebase_core/FirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<firebase_livestream_ml_vision/FirebaseLivestreamMlVisionPlugin.h>)
#import <firebase_livestream_ml_vision/FirebaseLivestreamMlVisionPlugin.h>
#else
@import firebase_livestream_ml_vision;
#endif

#if __has_include(<firebase_storage/FirebaseStoragePlugin.h>)
#import <firebase_storage/FirebaseStoragePlugin.h>
#else
@import firebase_storage;
#endif

#if __has_include(<share/SharePlugin.h>)
#import <share/SharePlugin.h>
#else
@import share;
#endif

#if __has_include(<tflite/TflitePlugin.h>)
#import <tflite/TflitePlugin.h>
#else
@import tflite;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CameraPlugin registerWithRegistrar:[registry registrarForPlugin:@"CameraPlugin"]];
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseLivestreamMlVisionPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseLivestreamMlVisionPlugin"]];
  [FLTFirebaseStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseStoragePlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [TflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"TflitePlugin"]];
}

@end
