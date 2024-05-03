import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yana_flutter/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoadOk = false;
  List<String> name = [];
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentIndex = 0;
  String? yourName;
  @override
  void initState() {
    super.initState();
    yourName = GetStorage().read("yourName");
    getForiInYourName();
    audioPlayer.play(AssetSource("music.m4a"));
    heartFunc();
  }

  getForiInYourName() {
    name.clear();
    for (int i = 0; i < yourName!.length - 1; i++) {
      name.add(yourName![i]);
    }
  }

  @override
  void dispose() {
    audioPlayerDisponse();
    super.dispose();
  }

  Future audioPlayerDisponse() async {
    await audioPlayer.dispose();
  }

  Future heartFunc() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      isLoadOk = !isLoadOk;
      currentIndex = currentIndex < name.length - 1 ? currentIndex + 1 : 0;
      if (mounted) {
        setState(() {});
        heartFunc();
      }
    });
  }

  // ignore: non_constant_identifier_names
  IconData play_PauseIcon = Icons.pause;
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    var heartSize = isLoadOk
        ? MediaQuery.of(context).size.width * 0.95
        : MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Animate(
              effects: const [
                BlurEffect(
                  curve: Curves.easeInOut,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                ),
                ScaleEffect(
                  curve: Curves.easeInOut,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                ),
                RotateEffect(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeInOut,
                ),
                AlignEffect(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeInOut,
                ),
                RotateEffect(
                  alignment: Alignment(
                    0,
                    0,
                  ),
                ),
              ],
              child: Icon(
                Icons.favorite,
                shadows: [
                  isLoadOk
                      ? Shadow(
                          color: Colors.red,
                          blurRadius: heartSize * 2,
                        )
                      : Shadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: heartSize / 2,
                        ),
                ],
                color: Colors.red,
                size: heartSize,
              ),
            ),
          ),
          Center(
            child: Animate(
              effects: const [
                ScaleEffect(),
              ],
              child: Text(
                name[currentIndex].toUpperCase(),
                style: GoogleFonts.akayaKanadaka(
                  color: Colors.white,
                  fontSize: heartSize / 3,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 30,
              blurStyle: BlurStyle.inner,
            ),
          ],
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (isPlaying) {
                  isPlaying = false;
                  play_PauseIcon = Icons.play_arrow;
                  audioPlayer.pause();
                  setState(() {});
                } else {
                  isPlaying = true;
                  play_PauseIcon = Icons.pause;
                  audioPlayer.resume();
                  setState(() {});
                }
              },
              icon: Icon(
                play_PauseIcon,
                size: 30,
                color: Colors.red,
                shadows: const [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 30,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                GetStorage().remove("yourName");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false);
              },
              icon: const Icon(
                Icons.edit,
                size: 25,
                color: Colors.red,
                shadows: [
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 30,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
