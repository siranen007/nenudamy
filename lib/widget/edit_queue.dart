import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nenudamye/models/dateday_model.dart';
import 'package:nenudamye/utility/my_style.dart';
import 'package:nenudamye/utility/normal_dialog.dart';

class EditQueue extends StatefulWidget {
  final DateDayModel dateDayModel;
  EditQueue({Key key, this.dateDayModel}) : super(key: key);
  
  @override
  _EditQueueState createState() => _EditQueueState();
}

class _EditQueueState extends State<EditQueue> {
  String chooseDate = 'Please Choose Date';
  String chooseStart = 'Please choose Start Hour';
  String chooseEnd = 'Please choose End Hour';
  bool dateDayBol = true, startBol = true, endBol = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Queue'),
        backgroundColor: MyStyle().primaryColor,
      ),
      body: Stack(
        children: [
          buildRaisedButton(),
          Center(
            child: Column(
              children: [
                buildDateDay(),
                buildStartHour(),
                buildEndHour(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRaisedButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            onPressed: () {
              if (dateDayBol || startBol || endBol) {
                normalDialog(context, 'Please choose Day, Start, End');
              } else {
                insertQueueToFirebase();
              }
            },
            icon: Icon(Icons.cloud_upload),
            label: Text('Save Queue'),
          ),
        ),
      ],
    );
  }

  Widget buildDateDay() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chooseDate),
          IconButton(
            icon: Icon(Icons.card_travel),
            onPressed: () async {
              dateDayBol = false;
              DateTime result = await dialogChooseDay();
              setState(() {
                chooseDate = DateFormat('dd-MM-yyyy').format(result);
              });
            },
          ),
        ],
      );

  Widget buildStartHour() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chooseStart),
          IconButton(
            icon: Icon(Icons.straighten),
            onPressed: () async {
              startBol = false;
              TimeOfDay result = await chooseHour();
              DateTime datetime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  result.hour,
                  result.minute);
              setState(() {
                // chooseStart = '${result.hour}:${result.minute}';
                chooseStart = DateFormat('HH:mm').format(datetime);
              });
            },
          ),
        ],
      );
  Widget buildEndHour() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chooseEnd),
          IconButton(
            icon: Icon(Icons.call_end),
            onPressed: () async {
              endBol = false;
              TimeOfDay result = await chooseHour();
              DateTime datetime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  result.hour,
                  result.minute);
              setState(() {
                // chooseStart = '${result.hour}:${result.minute}';
                chooseEnd = DateFormat('HH:mm').format(datetime);
              });
            },
          ),
        ],
      );

  Future<DateTime> dialogChooseDay() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
  }

  Future<TimeOfDay> chooseHour() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 00),
    );
  }

  Future<Null> insertQueueToFirebase() async {
    bool confirm = false;
    DateDayModel model = DateDayModel(
      dateDay: chooseDate,
      hour: '$chooseStart-$chooseEnd',
      booked: '',
      confirmed: confirm,
    );
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidTeacher = event.uid;
        await FirebaseFirestore.instance
            .collection('Product')
            .doc('Queue')
            .collection(uidTeacher)
            .add(model.toJson())
            .then(
              (value) => Navigator.pop(context),
            );
      });
    });
  }
}

// CalendarCarousel<EventInterface> buildCalendarCarousel() => CalendarCarousel();
