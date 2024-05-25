import 'dart:io';

import 'package:ai_man_app/utils/Color.dart';
import 'package:ai_man_app/utils/Family.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(centerTitle: true,
          title: Text('Display Screen' , style: TextStyle(
              fontSize: 17,
              fontFamily: Family.InterExtraBold,
              color: ColorRes.appTheme),)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('people_faces')
                    .onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.snapshot.value != null) {

                    Map<dynamic, dynamic> data = snapshot.data!.snapshot.value;

                    List<dynamic> messageList = data.values.toList();

                    return ListView.builder(
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        var message = messageList[index];

                        return Column(
                          children: [
                            ListTile(contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),

                              trailing: InkWell(onTap: (){
                                FirebaseDatabase.instance
                                    .reference()
                                    .child('people_faces')
                                    .child(message['person_face'] ?? '')
                                    .remove();
                                FirebaseStorage.instance.refFromURL(message['local_file_path']).delete();
                                showToast('Remove Data');



                              },
                                  child: Icon(Icons.delete,color: Colors.red,size: 25,)),
                              tileColor: ColorRes.background,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              leading: CircleAvatar(
                                radius:35 ,
                                backgroundImage:
                                    NetworkImage(message['local_file_path'] ?? '',scale: 1),
                              ),
                              title: Text(message['person_face'] ?? '',style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: Family.InterExtraBold,
                                  color: ColorRes.appTheme),),
                            ),
                            SizedBox(height: 10 ,)
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  static void showToast(String message) {
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
}
