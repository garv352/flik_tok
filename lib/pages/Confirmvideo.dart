import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fliktok/pages/video.dart';
import 'package:fliktok/variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:video_compress/video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

class ConfirmVideo extends StatefulWidget {
  final File videoFile;
  final String videopath_astring;
  final ImageSource imageSource;

  ConfirmVideo(this.videoFile, this.videopath_astring, this.imageSource);

  @override
  _ConfirmVideoState createState() => _ConfirmVideoState();
}

class _ConfirmVideoState extends State<ConfirmVideo> {
  VideoPlayerController controller;
  TextEditingController musiccontroller = TextEditingController();
  TextEditingController captioncontroller = TextEditingController();
  bool isUploading = false;
  FlutterVideoCompress flutterVideocompress = FlutterVideoCompress();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  compressvideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videoFile;
    } else {
      final compressvideo = await flutterVideocompress.compressVideo(
          widget.videopath_astring,
          quality: VideoQuality.MediumQuality);
      return File(compressvideo.path);
    }
  }

  getpreviewimage() async {
    final previewimage = await flutterVideocompress
        .getThumbnailWithFile(widget.videopath_astring);
    return previewimage;
  }

  videostorage(String id) async {
    StorageUploadTask storageUploadTask =
        videosFolder.child(id).putFile(widget.videoFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  imagestorage(String id) async {
    StorageUploadTask storageUploadTask =
        imagesFolder.child(id).putFile(await getpreviewimage());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadVideo() async {
    setState(() {
      isUploading = true;
    });
    try {
      var firebaseuseruid = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot userdoc =
          await usercollection.doc(firebaseuseruid).get();
      var alldocs = await videocollection.get();
      int length = alldocs.docs.length;
      String video = await videostorage("video $length");
      String previewimage = await imagestorage("IMAGE $length");
      videocollection.doc("video $length").set({
        'username': userdoc.data()['username'],
        'uid': firebaseuseruid,
        'profilepic': userdoc.data()['profilepic'],
        'id': "video $length",
        'likes': [],
        'commentcount': 0,
        'sharecount': 0,
        'songname': musiccontroller.text,
        'caption': captioncontroller.text,
        'videourl': video,
        'previewimage': previewimage
      });
      Navigator.pop(context);
    } catch (e) {
      showError(e.message);
    }
  }

  showError(String errorMessage) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isUploading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Uploading.."),
                    SizedBox(height: 20),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: VideoPlayer(controller),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: musiccontroller,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "song Name",
                                  labelStyle: mystyle(17),
                                  prefixIcon: Icon(Icons.music_note)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: captioncontroller,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Caption",
                                  labelStyle: mystyle(17),
                                  prefixIcon: Icon(Icons.text_fields)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            uploadVideo();
                          },
                          color: Colors.black,
                          child: Text(
                            "upload Video",
                            style: mystyle(20, Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.black,
                          child: Text(
                            "Cancel",
                            style: mystyle(20, Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
  }
}
