import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nenudamye/utility/my_constant.dart';
import 'package:nenudamye/widget/authen.dart';

class MyServiceStudent extends StatefulWidget {
  @override
  _MyServiceStudentState createState() => _MyServiceStudentState();
}

class _MyServiceStudentState extends State<MyServiceStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Student'),
      ),
      drawer: Drawer(
        child: MyConstant().buildListTileSignOut(context),
      ),
    );
  }

 
}
