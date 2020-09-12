import 'package:flutter/material.dart';

class MyStyle {
  Color primaryColor = Color(0xff004d40);
  Color darkColor = Color(0xff00251a);

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errImage() {
    return Container(
      width: 120,
      child: Image.asset('image/teacher.png'),
    );
  }

  MyStyle();
}
