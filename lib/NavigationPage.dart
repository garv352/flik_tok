import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'variable.dart';
import 'signup.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? Login() : HomePage(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSigned = false;

  navigateTosignup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Signup();
    }));
  }

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  // login() {
  //   FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailcontroller.text, password: passwordcontroller.text);
  // }

  login() async {
    try {
      //User is FirebaseUser
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text,
          password: passwordcontroller.text); // string _email

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
      backgroundColor: HexColor('FEFEFE'),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Login", style: mystyle(25, Colors.black, FontWeight.w700)),
          SizedBox(height: 80),
          // Text('Login',style:mystyle(25 ,Colors.black ,FontWeight.w500)),
          // SizedBox(height : 10),
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
              login();
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text("Login",
                      style: mystyle(20, Colors.white, FontWeight.w700))),
            ),
          ),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account"),
            Padding(padding: EdgeInsets.only(left: 5)),
            InkWell(
                onTap: () {
                  navigateTosignup();
                },
                // onTap: navigateTosignup(),
                child:
                    Text("Register", style: TextStyle(color: Colors.purple))),
          ])
        ]),
      ),
    );
  }
}
