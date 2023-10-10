import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:widget_mask/widget_mask.dart';

void main(List<String> args) {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Nandan Assignment',
      color: Color.fromARGB(255, 10, 43, 225),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Your Image / Icon"),
        backgroundColor: const Color.fromARGB(255, 19, 52, 237),
      ),
      body: const BodyApp(),
    );
  }
}

class BodyApp extends StatefulWidget {
  const BodyApp({super.key});

  @override
  State<BodyApp> createState() => _BodyAppState();
}

class _BodyAppState extends State<BodyApp> {
  String imagePath = "";
  Widget? maskedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(7),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 0.8),
            ),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  // ignore: prefer_const_constructors
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 19, 52, 237)),
                  child: const Text('Choose from Device'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          (maskedImage != null)
              ? Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  child: maskedImage,
                )
              : const Text("No Image Selected")
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);
    if (selected != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: selected.path,
        aspectRatio: const CropAspectRatio(ratioX: 100, ratioY: 400),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        cropStyle: CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: const Color.fromARGB(255, 19, 52, 237),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
            showCancelConfirmationDialog: true,
          ),
        ],
      );
      if (croppedFile == null) {
        imagePath = "";
        maskedImage = null;
      } else {
        imagePath = croppedFile.path;
        maskedImage = Image.file(File(imagePath));
        openDilog();
      }
    }
    setState(() {});
  }

  Future<void> openDilog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Edit Image',
            style: TextStyle(color: Color.fromARGB(255, 10, 43, 225)),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(0),
              child: maskedImage,
            ),
          ),
          actions: [
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          imageMask(imageFrame: null);
                        },
                        // ignore: prefer_const_constructors
                        child: Text("Original",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 19, 52, 237),
                            )),
                      ),
                      IconButton(
                        onPressed: () {
                          imageMask(imageFrame: 'asset/user_image_frame_1.png');
                        },
                        icon: Image.asset(
                          'asset/user_image_frame_1.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          imageMask(imageFrame: 'asset/user_image_frame_2.png');
                        },
                        icon: Image.asset(
                          'asset/user_image_frame_2.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          imageMask(imageFrame: 'asset/user_image_frame_3.png');
                        },
                        icon: Image.asset(
                          'asset/user_image_frame_3.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          imageMask(imageFrame: 'asset/user_image_frame_4.png');
                        },
                        icon: Image.asset(
                          'asset/user_image_frame_4.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancle',
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 52, 237),
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Save',
                            style: TextStyle(
                              color: Color.fromARGB(255, 19, 52, 237),
                            ))),
                  ],
                )
              ],
            ),
          ],
        ),
      );

  imageMask({String? imageFrame}) {
    if (imageFrame != null) {
      maskedImage = WidgetMask(
        childSaveLayer: true,
        blendMode: BlendMode.srcATop,
        mask: Image.file(
          File(imagePath),
          height: 100,
          fit: BoxFit.cover,
        ),
        child: Image.asset(imageFrame),
      );
    } else {
      maskedImage = Image.file(
        File(imagePath),
        height: 300,
        fit: BoxFit.cover,
      );
    }
    setState(() {});
  }
}
