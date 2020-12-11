import 'package:firebase_auth/firebase_auth.dart';
import 'package:fliktok/variable.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final id;

  const Comment(this.id);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  String uid;
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Expanded(
            child: Text('hello'),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentcontroller,
              decoration: InputDecoration(
                  labelText: 'Comment',
                  labelStyle: mystyle(17, Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
            trailing: OutlineButton(
              onPressed: () {},
              borderSide: BorderSide.none,
              child: Text(
                "Post",
                style: mystyle(15),
              ),
            ),
          )
        ]),
      ),
    ));
  }
}
