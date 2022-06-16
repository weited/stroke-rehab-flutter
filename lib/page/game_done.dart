import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';

//add for download/upload
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stroke_rehab/constants.dart';
import 'package:stroke_rehab/exercise.dart';
import 'package:stroke_rehab/widgets/display_detail_card.dart';
import 'package:stroke_rehab/widgets/large_action_button.dart';

class GameDone extends StatefulWidget {
  final String id;

  const GameDone({Key? key, required this.id}) : super(key: key);

  @override
  State<GameDone> createState() => _GameDoneState();
}

class _GameDoneState extends State<GameDone> {
  File? pictureToshow;
  late bool _uploading;
  late final ExerciseModel exerciseModel;

  @override
  void initState() {
    super.initState();
    _uploading = false;
    exerciseModel = Provider.of<ExerciseModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final Exercise exercise =
        Provider.of<ExerciseModel>(context, listen: false).get(widget.id);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Congratulations! \nYou have finished the exercise.',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            Expanded(flex: 0, child: DisplayDetailCard(exercise: exercise)),
            SizedBox(
              // width: 150,
              // height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        // shape: RoundedRectangleBorder(),
                        fixedSize: const Size(140, 35),
                      ),
                      onPressed: () {
                        takePhoto();
                      },
                      label: Center(
                        child: Text('Take Photo'),
                      ),
                      icon: Icon(Icons.camera_alt),
                    ),                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        // shape: RoundedRectangleBorder(),
                        fixedSize: const Size(140, 35),
                      ),
                      onPressed: () {
                        pickImage();
                      },
                      label: Center(
                        child: Text('Pick Image'),
                      ),
                      icon: Icon(Icons.photo),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: pictureToshow != null
                    ? Image.file(pictureToshow!)
                    : const Center(
                        child: Text('Upload a photo to record your effort!')),
              ),
            ),
            Container(
              height: kBottomContainerHeight,
              child: LargeSelectionButton(
                buttonTitle: _uploading ? 'Saving ...' : 'Save',
                onPressed: () async {
                  if (pictureToshow != null) {
                    setState(() {
                      _uploading = true; //visual feedback of upload
                    });
                    await uploadPicture();
                    setState(() {
                      _uploading = false; //visual feedback of upload
                    });
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ));
  }

  // https://www.youtube.com/watch?v=MSv38jO4EJk
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        pictureToshow = File(image.path);
      });
    }
    catch (e){
      print('Something wrong: $e');
    }
  }

  Future takePhoto() async {
    // 2. Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    //use the TakePictureScreen to get an image. This is like doing a startActivityForResult
    var picture = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: firstCamera)));
    setState(() {
      pictureToshow = picture;
    });
  }

  Future uploadPicture() async {
    //now do the upload
    String imgPath = 'uploads/stroke-rehab' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.jpeg';
    try {
      await FirebaseStorage.instance.ref(imgPath).putFile(pictureToshow!);

      await exerciseModel.addImgPath(widget.id, imgPath);
    } on FirebaseException {
      // e.g, e.code == 'canceled'
      setState(() {
        //force rebuild of list
        _uploading = false;
      });
    } catch (e) {
      print('failed error $e');
      setState(() {
        _uploading = false;
      });
    }
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            final picture = File(image.path);
            Navigator.pop(context, picture);
            return;
          } catch (e) {
            // If an error occurs, log the error to the console.
            print('Some thing wrong: $e');
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
