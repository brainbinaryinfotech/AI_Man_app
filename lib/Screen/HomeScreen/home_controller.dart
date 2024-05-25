

import 'dart:io';

import 'package:ai_man_app/Service/firebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../utils/strings.dart';
import '../../utils/Assets_res.dart';
import '../../utils/Family.dart';
import '../../utils/Color.dart';

class HomeController extends GetxController {

  final nameController = TextEditingController();
  Rx<File?> _image = Rx<File?>(null);
  File? get image => _image.value;
  RxBool isLoading = false.obs;

  Future<void> getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image.value = File(pickedImage.path);
    } else {
      print('No image selected.');
    }
  }

  Future<void> getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      _image.value = File(pickedImage.path);
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImage(context) async {
    if (image == null) {
      return ; // No image selected
    }
    isLoading.value = true;
    print(isLoading.value);
    await
    FireStoreService.imageStore(nameController.text, image,context);
    isLoading.value = false;
    print(isLoading.value);
  }

  void showImagePicker() {
    Get.bottomSheet(
      Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              Get.back();
              getImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take a Picture'),
            onTap: () {
              Get.back();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );

    void showToast(String message) {
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

  void openDialog(context) {
    Get.defaultDialog(
      title: 'Add Image and Name',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Enter Name'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: showImagePicker,
            child: Text('Pick Image'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            uploadImage(context);
            Get.back();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorRes.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Your UI widgets...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.openDialog(context);
        },

        child: Icon(Icons.add),
      ),
    );
  }

}
