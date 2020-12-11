import 'package:fliktok/variable.dart';
import 'package:flutter/material.dart';

class Addvideo extends StatefulWidget {
  @override
  _AddvideoState createState() => _AddvideoState();
}

class _AddvideoState extends State<Addvideo> {
  showoptiondialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(child: Text("Gallery", style: mystyle(17))),
              SimpleDialogOption(child: Text("Camera", style: mystyle(17))),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: mystyle(17))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
