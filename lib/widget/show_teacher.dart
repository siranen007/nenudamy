import 'package:flutter/material.dart';
import 'package:nenudamye/models/type_model.dart';
import 'package:nenudamye/utility/my_style.dart';
import 'package:nenudamye/widget/appoint_teacher.dart';
import 'package:nenudamye/widget/main_show_teacher.dart';

class ShowTeacher extends StatefulWidget {
  final TypeModel typeModel;
  ShowTeacher({Key key, this.typeModel}) : super(key: key);

  @override
  _ShowTeacherState createState() => _ShowTeacherState();
}

class _ShowTeacherState extends State<ShowTeacher> {
  TypeModel model;
  Widget currentWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      model = widget.typeModel;
      currentWidget = MainShowTeacher(
        model: model,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model == null ? 'Teacher' : model.name),
        backgroundColor: MyStyle().primaryColor,
        actions: [
          buildIconButtonMainShow(),
          buildIconButtonAppoint(),
        ],
      ),
      body: model == null ? MyStyle().showProgress() : currentWidget,
    );
  }

  Widget buildIconButtonMainShow() => IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
         setState(() {
            currentWidget = MainShowTeacher(
            model: model,
          );
         });
        },
      );

  Widget buildIconButtonAppoint() => IconButton(
        icon: Icon(Icons.schedule),
        onPressed: () {
         setState(() {
            currentWidget = AppointmentTeacher(
            model: model,
          );
         });
        },
      );
}
