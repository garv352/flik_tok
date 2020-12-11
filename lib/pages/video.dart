import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../variable.dart';
import '../widgets/circleanimation.dart';
import 'comment.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  buildmusicalalbum(String url) {
    return Container(
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(11.0),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[800], Colors.grey[700]],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                      image: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/330px-Image_created_with_a_mobile_phone.png'),
                      fit: BoxFit.cover)),
            )
          ],
        ));
  }

  Stream mystream;
  String uid;

  initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    mystream = videocollection.snapshots();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   mystream = videocollection.snapshots();
  // }

  likevideo(String id) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot doc = await videocollection.doc(id).get();
    if (doc['likes'].contains(uid)) {
      videocollection.doc(id).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      videocollection.doc(id).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  navigatetoComment(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comment(id);
    }));
    // super.dispose();
    // mystream = videocollection.snapshots(); //////////
  }

  sharevideo(String video, String id) async {
    var request = await HttpClient().getUrl(Uri.parse(video));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('Fliktok', 'Video.mp4', bytes, 'video/mp4');
    DocumentSnapshot docshare = await videocollection.doc(id).get();
    videocollection.doc(id).update({'sharecount': docshare['sharecount'] + 1});
  }

  buildProfile(url) {
    return Container(
        width: 60,
        height: 30,
        child: Stack(
          children: [
            Positioned(
                left: (60 / 2) - (30 / 2),
                child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/330px-Image_created_with_a_mobile_phone.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
              bottom: 15,
              left: (60 / 2) - (35 / 2),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 12),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder(
            stream: mystream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else
                return PageView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot videos = snapshot.data.docs[index];
                      return Stack(
                        children: [
                          //VIDEO
                          // Container(
                          //   decoration: BoxDecoration(color: Colors.black),
                          // ),
                          //
                          VideoPlayerItem(videos["videourl"]),

                          Column(
                            //TOP
                            children: [
                              // Container(
                              //   height: 100,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.end,
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Text("Following",
                              //           style: mystyle(
                              //               17, Colors.white, FontWeight.bold)),
                              //       SizedBox(width: 15),
                              //       Text("For You",
                              //           style: mystyle(
                              //               17, Colors.white, FontWeight.bold))
                              //     ],
                              //   ),
                              // ),
                              //MIDDLE
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              videos["username"],
                                              style: mystyle(17, Colors.white,
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              videos["caption"],
                                              style: mystyle(15, Colors.white,
                                                  FontWeight.w500),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.music_note,
                                                    size: 15,
                                                    color: Colors.white),
                                                Text(videos["songname"],
                                                    style: mystyle(
                                                        13,
                                                        Colors.white,
                                                        FontWeight.w300))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      margin: EdgeInsets.only(top: 150),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildProfile(videos["profilepic"]),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  likevideo(videos["id"]);
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 30,
                                                  color: videos["likes"]
                                                          .contains(uid)
                                                      ? Colors.red
                                                      : Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              Text(
                                                  videos['likes']
                                                      .length
                                                      .toString(),
                                                  style:
                                                      mystyle(15, Colors.white))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  navigatetoComment(
                                                      videos['id']);
                                                },
                                                child: Icon(
                                                  Icons.comment,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              Text("10",
                                                  style:
                                                      mystyle(15, Colors.white))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  sharevideo(videos['videourl'],
                                                      videos['id']);
                                                },
                                                child: Icon(
                                                  Icons.reply,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              Text(
                                                  videos['sharecount']
                                                      .toString(),
                                                  style:
                                                      mystyle(15, Colors.white))
                                            ],
                                          ),
                                          CircleAnimation(buildmusicalalbum(
                                              videos["profilepic"]))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //RIGHT SECTION
                            ],
                          )
                        ],
                      );
                    });
            }));
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videourl;
  VideoPlayerItem(this.videourl);
  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videourl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: VideoPlayer(videoPlayerController),
    ));
  }
}
