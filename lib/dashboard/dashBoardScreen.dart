import 'package:bulk_email/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dragAndDrop/FilesPicker.dart';
import '../utils/font_style.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool indexButton = false;
  bool newMessageButton = true;
  bool draftButton = false;
  // bool archiveButton = false;
  bool trashButton = false;

  void newMessageFunction() {
    setState(() {
      newMessageButton = true;
      indexButton = false;
      draftButton = false;
      // archiveButton = false;
      trashButton = false;
    });
  }

  void indexFunction() {
    setState(() {
      newMessageButton = false;
      indexButton = true;
      draftButton = false;
      // archiveButton = false;
      trashButton = false;
    });
  }

  void draftFunction() {
    setState(() {
      newMessageButton = false;
      indexButton = false;
      draftButton = true;
      // archiveButton = false;
      trashButton = false;
    });
  }

  void trashFunction() {
    setState(() {
      newMessageButton = false;
      indexButton = false;
      draftButton = false;
      // archiveButton = false;
      trashButton = true;
    });
  }

  // void archiveFunction() {
  //   setState(() {
  //     newMessageButton = false;
  //     indexButton = false;
  //     draftButton = false;
  //     // archiveButton = true;
  //     trashButton = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Responsive.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Row(
        children: [
          Container(
            height: Responsive.setHeight(value: 812),
            width: Responsive.setWidth(value: 75),
            // color: Colors.blue,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40)),
                color: Colors.grey[350]),
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: newMessageFunction,
                    child: FittedBox(
                      child: Container(
                          height: Responsive.setHeight(value: 40),
                          width: Responsive.setWidth(value: 50),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10)),
                            color: Colors.indigo,
                          ),
                          child: Center(
                            child: getTextStyle("New Message", FontWeight.bold,
                                Colors.white, 20),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.setHeight(value: 10),
                  ),
                  TextButton(
                    onPressed: indexFunction,
                    child: FittedBox(
                      child:
                          dashBoardOptions(Icons.inbox_outlined, 32, "Inbox"),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.setHeight(value: 10),
                  ),
                  TextButton(
                    onPressed: draftFunction,
                    child: FittedBox(
                      child:
                          dashBoardOptions(Icons.drafts_outlined, 32, "Drafts"),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.setHeight(value: 10),
                  ),
                  TextButton(
                    onPressed: trashFunction,
                    child: dashBoardOptions(
                          FontAwesomeIcons.trashCan, 25, "Trash"),
                  ),
                  // SizedBox(
                  //   height: Responsive.setHeight(value: 10),
                  // ),
                  // TextButton(
                  //   onPressed: archiveFunction,
                  //   child: dashBoardOptions(
                  //         Icons.archive_outlined, , "Archive"),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            height: Responsive.setHeight(value: 812),
            width: Responsive.setWidth(value: 300),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
              color: Colors.white,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                newMessageButton == true ? FilesPicker() : const SizedBox(),
                indexButton == true ? noDataHere() : const SizedBox(),
                draftButton == true ? noDataHere() : const SizedBox(),
                trashButton == true ? noDataHere() : const SizedBox(),
                // archiveButton == true ? noDataHere() : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FittedBox noDataHere() {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.only(top: Responsive.setHeight(value: 250)),
        child: Column(
          children: [
            FittedBox(
              child: Container(
                height: Responsive.setHeight(value: 260),
                width: Responsive.setWidth(value: 80),
                decoration: const BoxDecoration(
                  // color: Colors.amber,
                  image: DecorationImage(
                      image: AssetImage("assets/no-result.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                height: Responsive.setHeight(value: 65),
                width: Responsive.setWidth(value: 70),
                child: Center(
                  child: getTextStyle(
                      "No Data Here.", FontWeight.bold, Colors.black12, 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container dashBoardOptions(IconData icon, double iconSize, String iconName) {
    return Container(
      height: Responsive.setHeight(value: 30),
      width: Responsive.setWidth(value: 50),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: Colors.black,
            ),
            SizedBox(
              width: Responsive.setWidth(value: 3),
            ),
            getTextStyle(iconName, FontWeight.bold, Colors.black, 22)
          ],
        ),
      ),
    );
  }
}
