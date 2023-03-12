import 'package:bulk_email/dragAndDrop/DropZoneWidget.dart';
import 'package:bulk_email/dragAndDrop/DroppedFile.dart';
import 'package:flutter/material.dart';

import 'dashboard/dashBoardScreen.dart';
import 'dragAndDrop/File_Data_Model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: DashBoard()
    );
  }
}

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  File_Data_Model? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DroppedFileWidget(file: file),
            const SizedBox(height: 16,),
            Container(
              height: 300,
              child: DropZoneWidget(
                onDroppedFile: (file) => setState(() {
                  this.file = file;
                }),
              ),)
          ],
        )
      ),
    );
  }
}


//
//
// class MyHomePage extends StatefulWidget {
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String dropzoneState = '';
//   String dropzoneState2 = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             DropZone(
//               onDragEnter: () {
//                 print('drag enter');
//                 setState(() {
//                   dropzoneState = 'drag enter';
//                 });
//               },
//               onDragExit: () {
//                 print('drag exit');
//                 setState(() {
//                   dropzoneState = 'drag exit';
//                 });
//               },
//               onDrop: (files) {
//                 print('files dropped');
//                 print(files);
//                 setState(() {
//                   dropzoneState = 'files dropped $files';
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all()),
//                 width: 300,
//                 height: 300,
//               ),
//             ),
//             Text(dropzoneState),
//             DropZone(
//               onDragEnter: () {
//                 print('drag enter');
//                 setState(() {
//                   dropzoneState2 = 'drag enter';
//                 });
//               },
//               onDragExit: () {
//                 print('drag exit');
//                 setState(() {
//                   dropzoneState2 = 'drag exit';
//                 });
//               },
//               onDrop: (files) {
//                 print('files dropped');
//                 print(files);
//                 setState(() {
//                   dropzoneState2 = 'files dropped $files';
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all()),
//                 width: 300,
//                 height: 300,
//               ),
//             ),
//             Text(dropzoneState2),
//           ],
//         ),
//       ),
//     );
//   }
// }