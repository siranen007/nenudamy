import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nenudamye/utility/my_style.dart';
import 'package:nenudamye/utility/normal_dialog.dart';
import 'package:nenudamye/widget/my_service_student.dart';
import 'package:nenudamye/widget/my_service_teacher.dart';
import 'package:nenudamye/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool status = true; // true => wait for check user login
  String user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    Firebase.initializeApp().then((value) {
      print('initializeApp OK');

      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          print('SignOut Status ');
          setState(() {
            status = false; // Show login page
          });
        } else {
          String uid = event.uid;

          print('SignIn Stutus uid ==>> $uid');

          checkType(uid);
        }
      });
    });
  }

  Future<Null> checkType(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('Type')
        .document(uid)
        .snapshots()
        .listen((event) {
      print('event ==>> ${event.data()}');
      String type = event.data()['Type'];
      print('Type ==>> $type');

      routeToService(type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, MyStyle().primaryColor],
          radius: 1,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildContainer(),
              //buildText(),
              buildTextFieldUser(),
              buildTextFieldPassword(),
              buildRaisedButton(),
              buildFlatButton(),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton buildFlatButton() => FlatButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          )),
      child: Text(
        'New Reginster',
        style: TextStyle(color: Colors.pink[600]),
      ));

  Container buildRaisedButton() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: RaisedButton(
          color: MyStyle().darkColor,
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'Please fill every blank');
            } else {
              checkUserPassword();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Container buildTextFieldUser() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Container buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password :',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Text buildText() => Text(
        'Judqueue',
        style: TextStyle(
          fontSize: 30,
          color: MyStyle().darkColor,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      );

  Container buildContainer() {
    return Container(
      width: 350,
      child: Image.asset('images/logoq.png'),
    );
  }

  void routeToService(String type) {
    switch (type) {
      case 'Teacher':
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyServiceTeacher(),
            ),
            (route) => false);
        break;
      case 'Student':
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyServiceStudent(),
            ),
            (route) => false);
        break;
      default:
    }
  }

  Future<Null> checkUserPassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((value) async {
      String uid = value.user.uid;
      await FirebaseFirestore.instance
          .collection('Type')
          .document(uid)
          .snapshots()
          .listen((event) {
            String type = event.data()['Type'];
            routeToService(type);
          });
    }).catchError((response) {
      String string = response.message;
      normalDialog(context, string);
    });
  }
}
