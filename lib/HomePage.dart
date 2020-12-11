import 'package:fliktok/pages/ProfilePage.dart';
import 'package:fliktok/pages/addvideo.dart';
import 'package:fliktok/pages/messages.dart';
import 'package:fliktok/pages/search.dart';
import 'package:fliktok/pages/Confirmvideo.dart';
import 'package:fliktok/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:fliktok/variable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pageoptions = [
    VideoPage(),
    SearchPage(),
    Addvideo(),
    Message(),
    ProfilePage()
  ];

  int page = 0;

  pickvideo(ImageSource src) async {
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmVideo(File(video.path), video.path, src)));
  }

  showoptiondialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                  onPressed: () => pickvideo(ImageSource.gallery),
                  child: Text("Gallery", style: mystyle(17))),
              SimpleDialogOption(
                  onPressed: () => pickvideo(ImageSource.camera),
                  child: Text("Camera", style: mystyle(17))),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: mystyle(17))),
            ],
          );
        });
  }

  customicon() {
    return InkWell(
      // onTap: showoptiondialog(),
      child: GestureDetector(
        onTap: () {
          showoptiondialog();
        },
        child: Container(
          width: 45,
          height: 27,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 38,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 45, 108),
                    borderRadius: BorderRadius.circular(8)),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 38,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 32, 211, 234),
                    borderRadius: BorderRadius.circular(7)),
              ),
              Center(
                  child: Container(
                height: double.infinity,
                width: 38,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7)),
                child: Icon(Icons.add, size: 20),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: customicon(),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
        selectedItemColor: Colors.lightBlue,
        currentIndex: page,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
