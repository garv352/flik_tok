import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mystyle(double size, [Color color, FontWeight fw = FontWeight.w700]) {
  return GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: fw);
}

var usercollection = FirebaseFirestore.instance.collection('users');
var videocollection = FirebaseFirestore.instance.collection('videos');

StorageReference videosFolder = FirebaseStorage.instance.ref().child('videos');
StorageReference imagesFolder = FirebaseStorage.instance.ref().child('images');
