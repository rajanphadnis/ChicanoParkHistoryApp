library mainlib;

import 'package:animations/animations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chicano_park/game/game_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:vibration/vibration.dart';
part 'audioTour.dart';
part 'functions.dart';
part 'shapesDrawing.dart';
part 'mainScreen.dart';
part 'historyModal.dart';
part 'infoPage.dart';
part 'artist.dart';
part 'muralGallery.dart';
part 'credits.dart';
part 'muralInfo.dart';
part 'customTransition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

final key = new GlobalKey<_MainPageState>();
var found = "All_The_Way_To_The_Bay";
double valueTHingy = 0.0;
String textl = "quite literally nothing";
double confidenceNumThing = 0.0;
var jsonData =
    '{ "All_The_Way_To_The_Bay" : "All_The_Way_To_The_Bay", "Colossus" : "Colossus", "Los_Grandes" : "Los_Grandes", "Cuauhtemoc_Aztec_Warrior" : "Cuauhtemoc_Aztec_Warrior", "Varrio_Si_Yonkes_No" : "Varrio_Si_Yonkes_No", "Mujer_Cosmica" : "Mujer_Cosmica", "Chicano_Pinto_union" : "Chicano_Pinto_union", "Ninos_del_Mundo" : "Ninos_del_Mundo" }';
var parsedJson = json.decode(jsonData);
String data = "no error";
final double confidenceThresh = 0.2;
List<CameraDescription> cameras;
bool processing = false;
class ScreenArguments {
  final String found;
  ScreenArguments(this.found);
}
class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: SplashScreen.navigate(
        name: 'assets/Chicano.flr',
        next: (_) => MainPage(),
        until: () => availableCameras(),
        startAnimation: 'Intro',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}
