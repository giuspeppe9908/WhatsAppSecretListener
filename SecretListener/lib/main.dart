import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Listener v.1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Secret Listener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilePickerResult? result;
  AudioPlayer audioPlayer = AudioPlayer();
  double playBackRate = 1;
  IconData icon = Icons.play_arrow;
  bool isPlay = false;
  String? latestAudio;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlay = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      Center(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/hearing.png', height:200, width:200),
                const Text(
                  'Secret Listener è l\'app che ti permette di ascoltare l\'ultimo vocale su WhatsApp',
                  textAlign: TextAlign.center,
                ),
                result == null ? const Text('Seleziona Audio...') : Text('Selezionato : '+result!.files.single.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: playAudio,
                      child: isPlay == false ? Icon(icon, color: Colors.green) : Icon(Icons.pause, color: Colors.blue)
                  ),
                  TextButton(onPressed: upDownVelocity, child: Text("x$playBackRate")),
                ],
              )
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: filePicker,
        child: const Icon(Icons.file_open),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void filePicker() async{
    result = await FilePicker.platform.pickFiles(
        initialDirectory: '/',
        type: FileType.custom,
          allowedExtensions: ['opus', 'ogg', 'mp3', 'm4a'],
          allowMultiple: false,
        );
    setState(() {});
  }

  void playAudio() {
    if(result != null){
      setState(() {
        isPlay = true;
      });
      audioPlayer.play(DeviceFileSource(result!.files.single.path!));
    }

  }

  void upDownVelocity() {
    playBackRate = playBackRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playBackRate);
    setState(() {
    });
  }
}
