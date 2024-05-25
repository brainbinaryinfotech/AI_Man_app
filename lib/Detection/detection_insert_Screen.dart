import 'dart:io';

import 'package:ai_man_app/Detection/detection_Display_screen.dart';
import 'package:ai_man_app/Detection/detection_insert_controller.dart';
import 'package:ai_man_app/utils/Color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/Family.dart';

class DetectionInsertScreen extends StatefulWidget {
  int? index;

  DetectionInsertScreen({super.key, this.index});

  @override
  State<DetectionInsertScreen> createState() => _DetectionInsertScreenState();
}

class _DetectionInsertScreenState extends State<DetectionInsertScreen> {


  List<XFile?> imageFiles = List.filled(3, null);
  List<bool> imageUploaded = List.filled(3, false);
  int totalImages = 0;

  Future<void> pickImage(int index) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFiles[index] = pickedFile;
    });
  }

  Future<void> uploadImageToStorage(int index) async {
    print(widget.index);
    int? event = widget.index;


    XFile? imageFile = imageFiles[index];
    if (imageFile != null) {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('detections/event_${event}/images/unknown_face_$index.jpg');
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Reference storageRef = FirebaseStorage.instance
      //     .ref()
      //     .child('detections/event_${event}/images/unknow_$index.jpg');
      // await storageRef.putFile(File(imageFile.path));
      // Future<String> downloadUrl = storageRef.getDownloadURL();
      // setState(() {
      //   imageUploaded[index] = true;
      //   print(totalImages);
      // });

      DatabaseReference dbRef =
          FirebaseDatabase.instance.reference().child('detections');
      int? id = widget.index;
      dbRef.child('event_${id}').child('metadata').push().set({
        'additional_info': 'Unauthorized person detected at this time',
        'image_url': downloadUrl,
        'timestamp': DateTime.now().toString(),
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    // print(  widget.index!++ );
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Detection ADD Screen',
            style: TextStyle(
                fontSize: 17,
                fontFamily: Family.InterExtraBold,
                color: ColorRes.appTheme),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pickImage(index);
                          },
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorRes.background),
                                    width:MediaQuery.of(context).size.width/3.6,
                                    height: MediaQuery.of(context).size.height/6,
                                    child: imageFiles[index] != null
                                        ? Image.file(
                                            File(imageFiles[index]!.path),
                                            fit: BoxFit.cover,
                                          )
                                        : Center(child: Text('ADD IMAGE')),
                                  ),
                                  imageFiles[index] != null?
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imageFiles[index] = null;
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
                                  ):      SizedBox(

                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),

                        //
                        // SizedBox(height: 8.0),
                        // ElevatedButton(
                        //   onPressed: () => uploadImageToStorage(index),
                        //   child: Text('Upload Image'),
                        // ),
                        // SizedBox(height: 8.0),
                        // if (imageUploaded[index]) Text('Image Uploaded'),
                      ],
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {

             data();

              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                color: ColorRes.white,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: Family.InterExtraBold,
                      color: ColorRes.appTheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  data(){
    for (int i = 0; i <= 2; i++) {
      uploadImageToStorage(i);

    }
    showToast("SUCESS FULL DATA ADD");
    Get.off(DisplayScreen1());

  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
