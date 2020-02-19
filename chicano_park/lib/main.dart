// First, you want to import all of the packages. Material is standard.
library mainlib;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
part 'functions.dart';
part 'shapesDrawing.dart';
part 'mainScreen.dart';
part 'historyModal.dart';
part 'timeline.dart';
part 'infoPage.dart';
part 'artist.dart';
part 'muralGallery.dart';

// Next, create a list of cameras so that we know which one is the "back" one
// Start the app asynchronously because we want to make sure that the cameras are turned on and we have access to them before we show a camera feed to the user
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}
// void main() => runApp(MyApp());

final key = new GlobalKey<_MainPageState>();
// This variable is a string that will contain a descriptor for the mural we found when scanned
var found = "all_the_way";
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

// Create the app class and basic Material design structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // We can end up changing a bunch of values in here: https://api.flutter.dev/flutter/material/Colors-class.html
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      // Tell the app that the homepage is MainPage()
      home: 
      // MainPage()
      SplashScreen.navigate(
        name: 'assets/Chicano.flr',
        next: (_) => MainPage(),
        until: () => availableCameras(),
        startAnimation: 'Intro',
      ),
    );
  }
}
class MainPage extends StatefulWidget {
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _MainPageState createState() => _MainPageState();
}
