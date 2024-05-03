// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yana_flutter/home/home.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final getStorage = GetStorage();
  String? getName;

  @override
  void initState() {
    super.initState();
    getName = getStorage.read("yourName");
    print(getName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getName != null ? const HomePage() : const AddNamePage(),
    );
  }
}

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  @override
  void initState() {
    super.initState();
    getFloatingActionButton();
  }

  TextEditingController nameController = TextEditingController();

  Color floatingActionColor = Colors.grey.shade100;
  Color floatingActionIconColor = Colors.grey.shade200;

  Future getFloatingActionButton() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      if (nameController.text.length > 3) {
        floatingActionColor = Colors.blueAccent;
      } else if (nameController.text.length <= 3) {
        floatingActionColor = Colors.grey.shade100;
      }
    });
    if (mounted) {
      setState(() {});
      getFloatingActionButton();
    }
  }

  getSaveName() {
    if (nameController.text.length > 3) {
      GetStorage().write("yourName", nameController.text.trim());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (route) => false);
    }
  }

  bool getLoadingName = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Ismingizni kiriting",
              style: GoogleFonts.akayaKanadaka(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: nameController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(35),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getSaveName();
        },
        backgroundColor: floatingActionColor,
        child: Icon(
          Icons.arrow_right_alt_sharp,
          size: 30,
          color: floatingActionIconColor,
        ),
      ),
    );
  }
}
