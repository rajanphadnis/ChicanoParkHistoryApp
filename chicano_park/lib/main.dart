// First, you want to import all of the packages. Material is standard.
library mainlib;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
part 'functions.dart';
part 'shapesDrawing.dart';
part 'mainScreen.dart';
part 'historyModal.dart';
part 'timeline.dart';
part 'infoPage.dart';
part 'artist.dart';
// Next, create a list of cameras so that we know which one is the "back" one
// Start the app asynchronously because we want to make sure that the cameras are turned on and we have access to them before we show a cmera feed to the user
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

// This variable is a string that will contain a descriptor for the mural we found when scanned
var found = "";
double valueTHingy = 0.0;
String textl = "quite literally nothing";
double confidenceNumThing = 0.0;
var jsonData =
    '{ "All_The_Way_To_The_Bay" : "all_the_way", "Colossus" : "colossus", "Los_Grandes" : "grandes", "Cuauhtemoc_Aztec_Warrior" : "aztec_dude", "Varrio_Si_Yonkes_No" : "varrio", "Mujer_Cosmica" : "mujer_cosmica", "Chicano_Pinto_union" : "pinto", "Ninos_del_Mundo" : "ninos" }';
var parsedJson = json.decode(jsonData);
String data = "no error";
final double confidenceThresh = 0.2;
List<CameraDescription> cameras;
bool processing = false;
// https://www.youtube.com/watch?v=dQw4w9WgXcQ
// Create the app class and basic Material design structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // We can end up changing a bunch of values in here: https://api.flutter.dev/flutter/material/Colors-class.html
        primarySwatch: Colors.blue,
      ),
      // Tell the app that the homepage is TheMainAppHomePage()
      home: TheMainAppHomePage(),
    );
  }
}
// https://www.youtube.com/watch?v=dQw4w9WgXcQ
class TheMainAppHomePage extends StatefulWidget {
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _TheMainAppHomePageState createState() => _TheMainAppHomePageState();
}





// TODO: 
// - [Everybody] Come up with an app name. length =< 8 characters. Change the name in pubspec.yaml's "name" field (at the top)
// - [Everybody else] Update the database (add info and murals. add picture URLs). 
//    For pic URLs, put the picture in the "public" folder and 
//    run "firebase deploy". then link to the picture using the
//    url in firebase console --> hosting
//    example: garcia's picture is garcia.jpg in the public folder. I ran firebase deploy and garcia's picURL is:
//    https://programmingii-367d0.web.app/garcia.jpg
//    Note: pics can only be png of jpg. no gif or jpeg.
// - [Sloane, Elisse, Matthew?] The history section is now just standard HTML files. They
//    are in the "public" folder. change those, then run 
//    "firebase deploy"
// - [JBone] update iOS info.plist with the stuff from these links:
//    - https://pub.dev/packages/webview_flutter
//    - https://pub.dev/packages/flutter_webview_plugin
// - Play around with colors and icons
// - [Evan] Make Evan do some good flutter stuff (idk. audio, other stuff. he can get it)
// - see if IT got us a Testflite account yet and distribute?
// - [Evan] clean up variable language and permission language. Make it professional *cough cough evan
// - start documentation (i'll start at around 1:45 or 2) in "public/index.html"