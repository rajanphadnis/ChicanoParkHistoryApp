// First, you want to import all of the packages. Material is standard.
library mainlib;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
// import 'package:automl_mlkit/automl_mlkit.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:permission_handler/permission_handler.dart';
part 'functions.dart';
part 'shapesDrawing.dart';
part 'mainScreen.dart';
part 'historyModal.dart';
part 'modal.dart';
part 'timeline.dart';
part 'infoPage.dart';

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
// num _defaultValue = 0;
String textl = "quite literally nothing";
double confidenceNumThing = 0.0;
bool differentMural = true;
var jsonData =
    '{ "All_The_Way_To_The_Bay" : "Mural1", "Colossus" : "Mural2", "Los_Grandes" : "grandes", "Cuauhtemoc_Aztec_Warrior" : "aztec_dude" }';
var parsedJson = json.decode(jsonData);
String data = "no error";
final double confidenceThresh = 0.2;
List<CameraDescription> cameras;
// String _modelLoadStatus = 'unknown';
bool processing = false;

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

class TheMainAppHomePage extends StatefulWidget {
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _TheMainAppHomePageState createState() => _TheMainAppHomePageState();
}