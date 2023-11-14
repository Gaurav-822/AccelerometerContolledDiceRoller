import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shake/shake.dart';

void main() async {
  // To make the app potrait only!
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHomePage> {
  var count = Random().nextInt(6) + 1;
  double animate = 0;
  final player = AudioPlayer();
  final audioSource = AudioSource.asset('assets/audio/onedice.mp3');
  late ShakeDetector detector;

  void music() async {
    await player.setAudioSource(audioSource);
    await player.play();
  }

  void roll() {
    setState(() {
      music();
      count = Random().nextInt(6) + 1;
      animate == 1 ? animate = 0 : animate = 1;
      detector.stopListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        roll();
      },
      minimumShakeCount: 1,
      shakeThresholdGravity: 2.5,
    );
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 251, 142, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 251, 142, 1),
        // title: const Text("Dice Roller"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("Count: $count"),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: GestureDetector(
                    onTap: () {
                      roll();
                    },
                    child: Image.asset(
                      'assets/dice/$count.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ).animate(target: animate).shake(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
