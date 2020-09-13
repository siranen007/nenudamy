import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nenudamye/models/dateday_model.dart';
import 'package:nenudamye/utility/my_style.dart';
import 'package:nenudamye/widget/add_queue.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  String uidTeacher;
  bool statusNoHaveData = true;
  List<DateDayModel> dateDayModels = List();
  List<String> documentNames = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readQueue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyStyle().primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddQueue(),
          ),
        ).then(
          (value) => readQueue(),
        ),
        child: Icon(Icons.add),
      ),
      body: statusNoHaveData
          ? Text('No Data')
          : dateDayModels.length == 0
              ? MyStyle().showProgress()
              : buildListQueue(),
    );
  }

  Widget buildListQueue() => ListView.builder(
        itemCount: dateDayModels.length,
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(dateDayModels[index].dateDay),
                Text(dateDayModels[index].hour),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Map<String, dynamic> map = Map();
                    map['Booked'] = 'StudentID';
                    Firebase.initializeApp().then((value) async {
                      await FirebaseFirestore.instance
                          .collection('Product')
                          .doc('Queue')
                          .collection(uidTeacher)
                          .doc(documentNames[index]).update(map).then((value) => readQueue());
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    // print('index= $index');
                    Firebase.initializeApp().then((value) async {
                      await FirebaseFirestore.instance
                          .collection('Product')
                          .doc('Queue')
                          .collection(uidTeacher)
                          .doc(documentNames[index])
                          .delete()
                          .then((value) => readQueue());
                    });
                  },
                )
              ],
            ),
          ),
        ),
      );

  Future<Null> readQueue() async {
    if (dateDayModels.length != 0) {
      dateDayModels.clear();
      documentNames.clear();
    }
    Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uidTeacher = event.uid;
        // print('UidTeach ==>> $uidTeacher');
        await FirebaseFirestore.instance
            .collection('Product')
            .doc('Queue')
            .collection(uidTeacher)
            .snapshots()
            .listen((event) {
          // print('event ==>> $event');
          String string = event.docs.toString();
          // print('string ==>> $string');
          if (string != '[]') {
            //Have Queue
            // print('Have Data');
            setState(() {
              for (var snapshot in event.docs) {
                DateDayModel dateDayModel =
                    DateDayModel.fromJson(snapshot.data());
                String documentName = snapshot.documentID;
                // print('doc name ==>> $documentName');
                setState(() {
                  statusNoHaveData = false;
                  dateDayModels.add(dateDayModel);
                  documentNames.add(documentName);
                });
              }
            });
          }
        });
      });
    });
  }
}
