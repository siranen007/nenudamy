import 'package:flutter/material.dart';
import 'package:nenudamye/models/type_model.dart';

class AppointmentTeacher extends StatefulWidget {
  final TypeModel model;
  AppointmentTeacher({Key key, this.model}) : super(key: key);

  @override
  _AppointmentTeacherState createState() => _AppointmentTeacherState();
}

class _AppointmentTeacherState extends State<AppointmentTeacher> {
  TypeModel model;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      model = widget.model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Appointment schedule for ${model.name}'),
    );
  }
}
