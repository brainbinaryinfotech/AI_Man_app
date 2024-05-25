

import 'package:ai_man_app/Detection/detection_Display_screen.dart';
import 'package:ai_man_app/Screen/Display_Screen/Display_screen.dart';
import 'package:ai_man_app/Screen/HomeScreen/Menu_Screen.dart';
import 'package:ai_man_app/Screen/HomeScreen/home_controller.dart';
import 'package:ai_man_app/utils/Assets_res.dart';
import 'package:ai_man_app/utils/Color.dart';
import 'package:ai_man_app/utils/Family.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final HomeController controller = Get.put(HomeController());

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorRes.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 26),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AssetRes.logo,
                    height: size.height / 10,
                  ),
                  Text(
                    Strings.al_man_center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: Family.InterExtraBold,
                        color: ColorRes.appTheme),
                  ),
                  InkWell(onTap: (){Get.to(MenuScreen());},
                    child: Icon(
                      Icons.menu_outlined,
                      color: ColorRes.appTheme,
                      size: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Text(
                Strings.reported,
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: Family.InterExtraBold,
                    color: ColorRes.appTheme),
              ),
              SizedBox(
                height: size.height * .009,
              ),
              InkWell(
                onTap: () {
                  Get.to(DisplayScreen1());


              },
                child: Container(
                    width: double.infinity,
                    height: size.height / 3.5,
                    child: Image(
                      image: AssetImage(
                        AssetRes.scan,
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                      height: size.height * .23,
                      image: AssetImage(
                        AssetRes.nevetive,
                      )),
                  Image(
                      height: size.height * .23,
                      image: AssetImage(AssetRes.positive)),
                ],
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap: (){
                    Get.to(DisplayScreen());
                  },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                      color: ColorRes.white,
                      child: Text(
                        Strings.remove_stuff,
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Family.InterExtraBold,
                            color: ColorRes.appTheme),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _openDialog(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      color: ColorRes.white,
                      child: Text(
                        Strings.add_stuff,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Family.InterExtraBold,
                            color: ColorRes.appTheme),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * .06),
              Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              Strings.track_real,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Family.InterExtraBold,
                                  color: ColorRes.appTheme),
                            ),
                          ),
                          Container(
                            child: Text(
                              Strings.time_video,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Family.InterExtraBold,
                                  color: ColorRes.appTheme),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: ColorRes.appTheme,
                        thickness: 2,
                      )
                    ],
                  ),
                  Center(
                      child: Container(
                    width: size.width / 7,
                    height: size.height / 10,
                    color: ColorRes.background,
                  )),
                  Center(
                      child: Image(
                          height: size.height / 12,
                          image: AssetImage(AssetRes.camera)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                controller.getImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Picture'),
              onTap: () {
                Navigator.pop(context);
                controller.getImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openDialog(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
            return     controller.isLoading.value? CircularProgressIndicator():
              AlertDialog(
              backgroundColor: ColorRes.background,
              title: Text(
                'Add Image and Name',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: Family.InterExtraBold,
                    color: ColorRes.appTheme),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(labelText: 'Enter Name'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _showImagePicker(context);
                      },
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Family.InterExtraBold,
                            color: ColorRes.appTheme),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Family.InterExtraBold,
                        color: ColorRes.appTheme),
                  ),
                ),
          TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.uploadImage(context);

                    controller.nameController.clear();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Family.InterExtraBold,
                        color: ColorRes.appTheme),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
