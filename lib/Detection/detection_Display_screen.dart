// import 'package:ai_man_app/Detection/detection_insert_Screen.dart';
// import 'package:ai_man_app/utils/Family.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
//
// import '../utils/Color.dart';
//
// class ImageListScreen extends StatefulWidget {
//   @override
//   _ImageListScreenState createState() => _ImageListScreenState();
// }
//
// class _ImageListScreenState extends State<ImageListScreen> {
//   List<Map<String, dynamic>> imagesData = [];
//   int pathLength = 0;
//   int eventCount = 147;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//     calculatePathLength();
//   }
//
//   Future<void> fetchImages() async {
//     // Set the total number of events
//     for (int i = 1; i <= eventCount; i++) {
//       List<String> eventImages = await getImagesForEvent(i);
//       if (eventImages.isNotEmpty) {
//         setState(() {
//           imagesData.add({'eventNumber': i, 'images': eventImages});
//         });
//       }
//     }
//   }
//
//   Future<List<String>> getImagesForEvent(int eventNumber) async {
//          List<String> eventImages = [];
//     try {
//       Reference eventRef = FirebaseStorage.instance
//           .ref()
//           .child('detections/event_$eventNumber/images');
//       ListResult result = await eventRef.listAll();
//       for (Reference ref in result.items) {
//         String imageUrl = await ref.getDownloadURL();
//         eventImages.add(imageUrl);
//
//
//
//       }
//     } catch (e) {
//       print('Error fetching images for event $eventNumber: $e');
//     }
//     return eventImages;
//   }
//
//   Future<void> calculatePathLength() async {
//     try {
//       Reference pathRef = FirebaseStorage.instance.ref().child('/detections');
//       ListResult result = await pathRef.listAll();
//       setState(() {
//         pathLength = result.items.length;
//         print(pathLength);
//
//       });
//     } catch (e) {
//       print('Error calculating path length: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(leading: InkWell(onTap: (){
//         Get.to(DetectionInsertScreen(index:eventCount));
//       },
//           child: Icon(Icons.add)),
//           centerTitle: true,
//           title: Text('Detection Screen' , style: TextStyle(
//               fontSize: 17,
//               fontFamily: Family.InterExtraBold,
//               color: ColorRes.appTheme),)),
//       body: ListView.builder(
//         itemCount: imagesData.length,
//         itemBuilder: (context, index) {
//           int eventNumber = imagesData[index]['eventNumber'];
//           List<String> eventImages = imagesData[index]['images'];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: Text(
//                   'Event $eventNumber',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(
//                 height: 150,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: eventImages.length,
//                   itemBuilder: (context, imageIndex) {
//                     return Container(
//                       margin: EdgeInsets.all(8),
//                       child: Image.network(
//                         eventImages[imageIndex],
//                         fit: BoxFit.cover,
//                         width: 150,
//                         height: 150,
//                         errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
//                           return Text('Error loading image');
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }





import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:http/http.dart' as http;

import 'package:ai_man_app/Detection/detection_insert_Screen.dart';
import 'package:ai_man_app/utils/Color.dart';
import 'package:ai_man_app/utils/Family.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


import 'package:get/get.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';


class DisplayScreen1 extends StatelessWidget {
  int? indexs;

  // void _saveImageToGallery(String imageUrl, context) async {
  //   bool success = await ImageGallerySaver.saveImage(imageUrl as Uint8List);
  //   if (success) {
  //     _showSnackBar('Image saved to gallery', context);
  //   } else {
  //     _showSnackBar('Failed to save image', context);
  //   }
  // }
  //
  // void _showSnackBar(String message, context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.to(DetectionInsertScreen(
                  index: indexs,
                ));
              },
              child: Icon(Icons.add)),
          centerTitle: true,
          title: Text(
            'Detection Screen',
            style: TextStyle(
                fontSize: 17,
                fontFamily: Family.InterExtraBold,
                color: ColorRes.appTheme),
          )),
      body: StreamBuilder(
        stream:
            FirebaseDatabase.instance.reference().child('detections').onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<dynamic, dynamic>? eventsData = snapshot.data!.snapshot.value;
            List eventIds = eventsData?.keys.toList() ?? [];
            print(eventIds.length);
            indexs = eventIds.length + 20;

            return ListView.builder(
              itemCount: eventIds.length,
              itemBuilder: (BuildContext context, int index) {
                String eventId = eventIds[index];
                Map<dynamic, dynamic>? eventData =
                    eventsData?[eventId]['metadata'];
                int? indexs = eventData?['indexs'] as int?;
                return eventData != null
                    ? buildEventTile(eventId, eventData, context)
                    : SizedBox(); // Placeholder for handling missing or empty data
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildEventTile(
      String eventId, Map<dynamic, dynamic> eventData, context) {
    return ExpansionTile(
      title: Text('Event $eventId'), // Display the event ID
      children: eventData.keys.map<Widget>((key) {
        final dynamic data = eventData[key];
        if (data is Map<dynamic, dynamic>) {
          final imageUrl = data['image_url'];
          final additionalInfo = data['additional_info'];
          final timestamp = data['timestamp'];

          return ListTile(
            leading: InkWell(
              onTap: () {
                _showImageDialog(imageUrl, context);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl.toString()),
              ),
            ),
            title: Text(additionalInfo.toString()),
            subtitle: Text(timestamp.toString()),
          );
        } else {
          return SizedBox(); // Handle cases where data is not of type Map<dynamic, dynamic>
        }
      }).toList(),
    );
  }

  void _showImageDialog(String imageUrl, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRes.background,
          content: Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                saveImageToGallery(imageUrl);
                _downloadImage(imageUrl,context);



              },
              child: Text(
                'ADD IMAGE',
                style: TextStyle(
                    fontSize: 15,
                      fontFamily: Family.InterExtraBold,
                    color: ColorRes.appTheme),
              ),
            ),
          ],
        );
      },
    );
  }
}
Future<void> _downloadImage(imageUrl,context) async {
  Dio dio = Dio();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.path}/image.jpg';
  await dio.download(imageUrl, filePath);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Image downloaded to $filePath'),
  ));
}
Future<void> saveImageToGallery(String imageUrl) async {

  var request = await http.get(Uri.parse(imageUrl));
  if (request.statusCode == 200) {
    String dir = (await DownloadsPathProvider.downloadsDirectory)!.path;
    File file =
    File('$dir/${DateTime.now().microsecondsSinceEpoch}.jpg');
    await file.writeAsBytes(request.bodyBytes);

    print(file.path);
}}
