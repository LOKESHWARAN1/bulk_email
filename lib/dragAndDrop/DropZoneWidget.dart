import 'package:bulk_email/utils/font_style.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'File_Data_Model.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<File_Data_Model> onDroppedFile;

  const DropZoneWidget({
    Key? key,
    required this.onDroppedFile,
  }) : super(key: key);

  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  //controller to hold data of file dropped by user
  late DropzoneViewController controller;

  // a variable just to update UI color when user hover or leave the drop zone
  bool highlight = false;

  @override
  Widget build(BuildContext context) {

    final colorButton =
        highlight ? Colors.blue.shade300 : Colors.green.shade300;
    return Padding(
        padding: const EdgeInsets.all(30),
        child: buildDecorattion(child: Stack(
          children: [
            DropzoneView(
                onCreated: (controller) => this.controller = controller,
                onHover: () => setState(() => highlight == true),
                onLeave: () => setState(() => highlight == false),
                onDrop: UploadedFile),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    size: 80,
                    color: Colors.white,
                  ),
                  getTextStyle(
                    "Drag file here",
                    FontWeight.normal,
                    Colors.white,
                    24
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FittedBox(child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 23),
                      primary: colorButton,
                      // side: RoundedRectangleBorder(borderRadius: Radius.circular(20))
                    ),
                    icon: const Icon(
                      Icons.search,
                      size: 32,
                    ),
                    label: getTextStyle(
                      "Choose Files",
                      FontWeight.normal,
                        Colors.white,
                      30
                    ),
                    onPressed: () async {
                      final events = await controller.pickFiles();
                      if (events.isEmpty) return;

                      UploadedFile(events.first);
                    },
                  )
                  )
                ],
              ),
            ),
          ],
        )
        ));
    // child: Stack(
    //   children: [
    //     // dropzone area
    //     DropzoneView(
    //       // attach an configure the controller
    //       onCreated: (controller) => this.controller = controller,
    //       // call UploadedFile method when user drop the file
    //       onDrop: UploadedFile,
    //       // change UI when user hover file on dropzone
    //       onHover: () => setState(() => highlight = true),
    //       onLeave: () => setState(() => highlight = false),
    //       onLoaded: () => print('Zone Loaded'),
    //       onError: (err) => print('run when error found : $err'),
    //     ),
    //     Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const Icon(
    //             Icons.cloud_upload_outlined,
    //             size: 80,
    //             color: Colors.white,
    //           ),
    //           const Text(
    //             'Drop Files Here',
    //             style: TextStyle(color: Colors.white, fontSize: 24),
    //           ),
    //           const SizedBox(
    //             height: 16,
    //           ),
    //           // a button to pickfile from computer
    //           ElevatedButton.icon(
    //             onPressed: () async {
    //               final events = await controller.pickFiles();
    //               if (events.isEmpty) return;
    //               UploadedFile(events.first);
    //             },
    //             icon: const Icon(Icons.search),
    //             label: const Text(
    //               'Choose File',
    //               style: TextStyle(color: Colors.white, fontSize: 15),
    //             ),
    //             style: ElevatedButton.styleFrom(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 20
    //                 ),
    //                 primary: highlight ? Colors.blue : Colors.green
    //                     .shade300,
    //                 shape: const RoundedRectangleBorder()
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // ));
  }

  Widget buildDecorattion({required Widget child}) {
    final colorBackGround = highlight ? Colors.blue : Colors.green;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
        child: Container(
          color: colorBackGround,
          padding: EdgeInsets.all(10),
          child: DottedBorder(
            borderType: BorderType.RRect,
            color: Colors.white,
            padding: EdgeInsets.zero,
            strokeWidth: 3,
            dashPattern: [8,4],
            radius: Radius.circular(10),
            child: child,
          )),
    );
  }

  // Future

  Future UploadedFile(dynamic event) async {
    // this method is called when user drop the file in drop area in flutter

    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final byte = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    print('Name : $name');
    print('Mime: $mime');
    print('Size : ${byte / (1024 * 1024)}');
    print('URL: $url');

    final droppedFile = File_Data_Model(
      name: name,
      mime: mime,
      bytes: byte,
      url: url,
    );

    widget.onDroppedFile(droppedFile);
    // update the data model with recent file uploaded
    // final droppedFile = File_Data_Model
    //   (name: name, mime: mime, bytes: byte, url: url);
    // //Update the UI
    // widget.onDroppedFile(droppedFile);
    // setState(() {
    //   highlight = false;
    // });
  }
//
// Widget buildDecoration({required Widget child}) {
//   final colorBackground = highlight ? Colors.blue : Colors.green;
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(12),
//     child: Container(
//       padding: const EdgeInsets.all(10),
//       color: colorBackground,
//       child: DottedBorder(
//           borderType: BorderType.RRect,
//           color: Colors.white,
//           strokeWidth: 3,
//           dashPattern: const [8, 4],
//           radius: const Radius.circular(10),
//           padding: EdgeInsets.zero,
//           child: child
//       ),
//     ),
//   );
// }
}
