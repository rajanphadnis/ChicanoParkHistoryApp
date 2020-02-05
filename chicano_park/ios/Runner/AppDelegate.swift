import UIKit
import Flutter
import Firebase
import AVFoundation
import CoreML
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  // Really Raj? I have to format the code for you?
  var hasThing = false
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery", binaryMessenger: controller.binaryMessenger)
      // you have two batteryChannel call handlers. Intentional?
      // batteryChannel.setMethodCallHandler({
      //   (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      //   // Note: this method is invoked on the UI thread.
      // })
      GeneratedPluginRegistrant.register(with: self)
      batteryChannel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread.
        guard call.method == "runModel" else {
          result(FlutterMethodNotImplemented)
          return
        }
        guard let args = call.arguments else {
            result("iOS couldnt find any arguments")
            return
        }
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
        options.confidenceThreshold = 0
        let labeler = Vision.vision().onDeviceAutoMLImageLabeler(options: options)
        let image = VisionImage(image: UIImage(contentsOfFile: urlString as! String)!)
        labeler.process(image) { labels, error in
          guard error == nil, let labels = labels else { return }

          print("\(labels.first?.text as! String) - \(Double((labels.first?.confidence)!))")
          resultText = labels.first?.text as! String
          confidencetext = labels.first?.confidence as! Double
          self!.hasThing = true
          // result(labels.first?.text as! String)


          // Here you experiment with return then result (escaping) and result then return (non-escaping).
          // This situation depends on speed and whichever one XCode decides it wants to work. 
          // As you know, Flutter is still a growing language and this is one of the rough spots to iron out.
          // It's not high on our priority list right now, mainly because there are workarounds like the flip-flopping.
          // I've seen packages for this sort of thing, but if those didn't work, then this is the way to go. 
          // Couple more things: 
          // - whoever wrote the Swift code knows what they're doing. Nice Job!
          // - clever modal implementation. Might want to call database async though.
          // - generally isn't good practice to use dev_dependencies to flush out icons and assets. Remove the package when you're done
          // - did I see stress test code in here!? I removed it for you :)
          // Good luck! Let me know how it turns out.



          // add return here. void, so just 'return'
          // add your result() fxn here




        }
        // everything here is run before labeler.process because its synchronous. Were you simulating high-stress situations?
        // print("*sleeping")
        // print("\(resultText):\(confidencetext)")
        // result("\(resultText):\(confidencetext)")   
      })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  } 
}