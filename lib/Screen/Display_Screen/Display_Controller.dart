// import 'package:get/get.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class DataController extends GetxController {
//   DatabaseReference _dbRef =
//   FirebaseDatabase.instance.reference().child('people_faces');
//
//   RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _dbRef.onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         Object? values = event.snapshot.value;
//         List<Map<String, dynamic>> dataList = [];
//         var forEach = values?.forEach((key, value) {
//           dataList.add({
//             'id': key,
//             'person_face': value['person_face'],
//             'local_file_path': value['local_file_path'],
//           });
//         });
//         data.value = dataList;
//       } else {
//         data.value = [];
//       }
//     });
//   }
//
//   void deleteData(String id) {
//     _dbRef.child(id).remove();
//   }
// }
