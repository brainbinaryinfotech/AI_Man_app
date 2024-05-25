import 'dart:io';

import 'package:ai_man_app/utils/Family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'utils/Color.dart';

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  File? _imageFile;
  late FaceDetector _faceDetector;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _faceDetector = GoogleMlKit.vision.faceDetector();
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _detectFaces();
    }
  }

  Future<void> _detectFaces() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    try {
      final faces = await _faceDetector.processImage(inputImage);
      setState(() {
        _faces = faces;
        if (_faces.isEmpty) {
          showToast("No face in this image");
        } else {
          showToast("${_faces.length} face detect");
        }
      });
    } catch (e) {
      print('Face detection error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_faces.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: MediaQuery.of(context).size.height/2.5,
              child: Stack(
                children: [
                  _imageFile != null
                      ? Image.file(_imageFile!)
                      : Center(child: Text('No image selected')),
                  // for (int i = 0; i <_faces.length; i++)
                  //   Positioned(
                  //     width: _faces[i].boundingBox.width,
                  //     height: _faces[i].boundingBox.height,
                  //     left: _faces[i].boundingBox.left,
                  //     top: _faces[i].boundingBox.top,
                  //     child: Container(
                  //       width: _faces[i].boundingBox.width,
                  //       height: _faces[i].boundingBox.height,
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.blue, width: 2),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            // _imageFile != null
            //     ? CustomPaint(
            //   painter: FacePainter(_imageFile!, _faces),
            //   child: Image.file(_imageFile!),
            // )
            //     : Center(child: Text('No image selected')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image', style: TextStyle(
                  fontSize: 15,
                  fontFamily: Family.InterExtraBold,
                  color: ColorRes.appTheme))),

            SizedBox(height: 20),
            Text('Detected faces: ${_faces.length}',style: TextStyle(
                fontSize: 20,
                fontFamily: Family.InterExtraBold,
                color: ColorRes.appTheme)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _faces.length,
                itemBuilder: (context, index) {
                  final face = _faces[index];
                  return ListTile(
                    title: Text('Face ${index + 1}'),
                    subtitle: Text(
                      'Left: ${face.boundingBox.left}, '
                      'Top: ${face.boundingBox.top}, '
                      'Width: ${face.boundingBox.width}, '
                      'Height: ${face.boundingBox.height}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final File imageFile;
  final List<Face> faces;

  FacePainter(this.imageFile, this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    print(faces);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    final double scaleX =
        size.width / imageFile.readAsBytesSync().lengthInBytes;
    final double scaleY =
        size.height / imageFile.readAsBytesSync().lengthInBytes;

    for (final face in faces) {
      final Rect rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return imageFile != oldDelegate.imageFile || faces != oldDelegate.faces;
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
