import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FireStoreService {
  static imageStore(name, image,context) async {



    Reference storageRef =
        FirebaseStorage.instance.ref().child('faces/${name}.jpg');
    UploadTask uploadTask = storageRef.putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('people_faces');
    String id = name;
    dbRef.child(id).set({
      'person_face': name,
      'local_file_path': downloadUrl,
    });

    showToast('Successfully added data');
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
