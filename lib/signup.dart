import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'variable.dart';
import 'NavigationPage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  navigateToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();

  registerUser() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailcontroller.text, password: passwordcontroller.text)
        .then((signeduser) {
      usercollection.doc(signeduser.user.uid).set({
        'username': usernamecontroller.text,
        'email': emailcontroller.text,
        'uid': signeduser.user.uid,
        'profilepic':
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vectorstock.com%2Froyalty-free-vector%2Ficon-of-user-avatar-for-web-site-or-mobile-app-vector-3125199&psig=AOvVaw1A4ObjoOsqNq9Hri-_S6XP&ust=1604749166607000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNjSyNLq7ewCFQAAAAAdAAAAABAD'
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('FEFEFE'),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Signup", style: mystyle(25, Colors.black, FontWeight.w700)),
          SizedBox(height: 80),
          // Text('Login',style:mystyle(25 ,Colors.black ,FontWeight.w500)),
          // SizedBox(height : 10),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: usernamecontroller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: mystyle(17),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  labelStyle: mystyle(17),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: passwordcontroller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: mystyle(17),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),

          SizedBox(height: 30),
          InkWell(
            onTap: () {
              registerUser();
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text("SignUp",
                      style: mystyle(20, Colors.white, FontWeight.w700))),
            ),
          ),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Already a User"),
            Padding(padding: EdgeInsets.only(left: 5)),
            InkWell(
                onTap: () {
                  navigateToLogin();
                },
                // onTap: navigateTosignup(),
                child: Text("Login", style: TextStyle(color: Colors.purple))),
          ])
        ]),
      ),
    );
  }
}
