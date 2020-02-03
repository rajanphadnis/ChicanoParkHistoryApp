import UIKit
import Flutter
import Firebase
import AVFoundation
import CoreML
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      // Handle battery messages.
    })

    GeneratedPluginRegistrant.register(with: self)
    batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // Note: this method is invoked on the UI thread.
  guard call.method == "runModel" else {
    result(FlutterMethodNotImplemented)
    return
  }
        guard let args = call.arguments else {
            result("iOS couldnt find any arguments")
            return
        }
//        args = args as!/
        let args2 = args as! [String: String]
        let urlString : String = args2["path"] as! String
        print("* url string: \(urlString as! String)")
          guard let manifestPath = Bundle.main.path(
            forResource: "manifest",
            ofType: "json",
            inDirectory: "ml"
        ) else { return }
        let localModel = AutoMLLocalModel(manifestPath: manifestPath)
        let options = VisionOnDeviceAutoMLImageLabelerOptions(localModel: localModel)
        var resultText = ""
        var confidencetext = 0.20
options.confidenceThreshold = 0  // Evaluate your model in the Firebase console
                                 // to determine an appropriate value.
let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: options)
        let image = VisionImage(image: UIImage(contentsOfFile: urlString as! String)!)
        labeler.process(image) { labels, error in
    guard error == nil, let labels = labels else { return }
            print("\(labels.first?.text as! String) - \(Double((labels.first?.confidence)!))")
            resultText = labels.first?.text as! String
            confidencetext = labels.first?.confidence as! Double
//            result(labels.first?.text as! String)
//for label in labels {labels.first?.text
//    let labelText = label.text
//    let confidence = label.confidence
//}
    // Task succeeded.
    // ...
}
        result("\(resultText):\(confidencetext)")
        
        
//  self?.receiveBatteryLevel(result: result)
        
})
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//    private func receiveBatteryLevel(result: FlutterResult) {
//  guard let manifestPath = Bundle.main.path(
//    forResource: "manifest",
//    ofType: "json",
//    inDirectory: "ml"
//) else { return true }
//let localModel = AutoMLLocalModel(manifestPath: manifestPath)
////        var im = UIImage(named: )
//
//}
    
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



// https://firebase.google.com/docs/ml-kit/ios/label-images-with-automl#configure-a-local-model-source
// https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-swift-tab#step-4-add-an-ios-platform-specific-implementation
