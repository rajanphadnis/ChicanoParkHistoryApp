import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    //let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    //let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                             // binaryMessenger: controller.binaryMessenger)
   /* batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // Note: this method is invoked on the UI thread.
  guard call.method == "getModel" else {
    result(FlutterMethodNotImplemented)
    return
  }
  //self?.receiveBatteryLevel(result: result)
})*/

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
/*private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery info unavailable",
                        details: nil))
  } else {
    result(Int(device.batteryLevel * 100))
  }
}*/
// private func runModel(result: FlutterResult) {
//   guard let manifestPath = Bundle.main.path(
//     forResource: "manifest",
//     ofType: "json",
//     inDirectory: "ml"
// ) else { return true }
// let localModel = AutoMLLocalModel(manifestPath: manifestPath)
// let options = VisionOnDeviceAutoMLImageLabelerOptions(localModel: localModel)
// options.confidenceThreshold = 0  // Evaluate your model in the Firebase console
//                                  // to determine an appropriate value.
// let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: options)
// //prep image from path. idk how to do it
// let image = VisionImage(image: UIImage(contentsOfFile: imageURL.path))
// labeler.process(image) { labels, error in
//     guard error == nil, let labels = labels else { return }
//     let labelText = labels.first.text
//     let confidence = labels.first.confidence
//     result(labelText + ":" + confidence + ";")
// }
// }
// }


// https://firebase.google.com/docs/ml-kit/ios/label-images-with-automl#configure-a-local-model-source
// https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-swift-tab#step-4-add-an-ios-platform-specific-implementation
