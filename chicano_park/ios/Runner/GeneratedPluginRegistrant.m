//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <camera/CameraPlugin.h>
#import <cloud_firestore/CloudFirestorePlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>
#import <firebase_livestream_ml_vision/FirebaseLivestreamMlVisionPlugin.h>
#import <firebase_storage/FirebaseStoragePlugin.h>
#import <share/SharePlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CameraPlugin registerWithRegistrar:[registry registrarForPlugin:@"CameraPlugin"]];
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseLivestreamMlVisionPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseLivestreamMlVisionPlugin"]];
  [FLTFirebaseStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseStoragePlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
}

@end
