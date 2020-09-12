import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nenudamye/models/type_model.dart';
import 'package:nenudamye/utility/my_style.dart';
import 'package:nenudamye/utility/normal_dialog.dart';

import '../utility/my_style.dart';

class EditInformationTeacher extends StatefulWidget {
  @override
  _EditInformationTeacherState createState() => _EditInformationTeacherState();
}

class _EditInformationTeacherState extends State<EditInformationTeacher> {
  List<String> educates = ['ปวส', 'ปริญญาตรี', 'ปริญญาโท', 'ปริญญาเอก'];

  String educatChoose,
      name = '',
      address = '',
      phone = '',
      website = '',
      urlAvatar,
      uid;

  File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Teacher Information'),
        backgroundColor: MyStyle().primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildRow(),
              buildTextFieldName(),
              buildDropdownButton(),
              buildTextFieldAddress(),
              buildTextFieldPhone(),
              buildTextFieldWebsite(),
              buildRaisedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildRaisedButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: MyStyle().primaryColor,
          onPressed: () {
            if (file == null) {
              if (urlAvatar == null) {
                normalDialog(context, 'Please Choose Image');
              } else {
                checkEducateAndEmtry();
              }
            } else {
              checkEducateAndEmtry();
            }
          },
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
          ),
          label: Text(
            'Save Data',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

  DropdownButton buildDropdownButton() => DropdownButton<String>(
        value: educatChoose,
        items: educates
            .map(
              (e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            educatChoose = value;
          });
        },
        hint: Text('Please Choose Education'),
      );

  Container buildTextFieldName() => Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        width: 250,
        child: TextFormField(
          key: Key(name.toString()),
          initialValue: name,
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Display Name : ',
            suffixIcon: Icon(Icons.account_circle),
          ),
        ),
      );

  Container buildTextFieldAddress() => Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        width: 250,
        child: TextFormField(
          key: Key(address.toString()),
          initialValue: address,
          onChanged: (value) => address = value.trim(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Address : ',
            suffixIcon: Icon(Icons.home),
          ),
        ),
      );

  Container buildTextFieldPhone() => Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        width: 250,
        child: TextFormField(
          keyboardType: TextInputType.phone,
          key: Key(phone.toString()),
          initialValue: phone,
          onChanged: (value) => phone = value.trim(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone : ',
            suffixIcon: Icon(Icons.phone),
          ),
        ),
      );

  Container buildTextFieldWebsite() => Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        width: 250,
        child: TextFormField(
          key: Key(website.toString()),
          initialValue: website,
          onChanged: (value) => website = value.trim(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Website : ',
            suffixIcon: Icon(Icons.web),
          ),
        ),
      );

  Row buildRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 16),
            width: 180,
            height: 180,
            child: file == null
                ? urlAvatar == null
                    ? Image.asset('images/teacher.png')
                    : Image.network(urlAvatar)
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Future<Null> readData() async {
    Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uid = event.uid;
        print('uid User login ==>> $uid');

        await FirebaseFirestore.instance
            .collection('Type')
            .doc(uid)
            .snapshots()
            .listen((event) {
          TypeModel model = TypeModel.fromJson(event.data());
          setState(() {
            name = model.name;
            address = checkNull(model.address);
            phone = checkNull(model.phone);
            website = checkNull(model.website);
            urlAvatar = model.pathImage;
            educatChoose = model.education;
            // print('urlAvatar ==>> $urlAvatar');
          });
        });
      });
    });
  }

  void checkEducateAndEmtry() {
    if (educatChoose == null) {
      normalDialog(context, 'Please specify your education');
    }
    if (name.isEmpty || address.isEmpty || phone.isEmpty || website.isEmpty) {
      normalDialog(context, 'Please fill all blank');
    } else {
      if (file == null) {
        insertValueToFirestore();
      } else {
        uploadImageToFirebase();
      }
    }
  }

  String checkNull(String string) {
    if (string == null) {
      return '';
    } else {
      return string;
    }
  }

  Future<Null> uploadImageToFirebase() async {
    int i = Random().nextInt(1000000);
    String nameImage = 'teacher$i.jpg';
    StorageReference reference =
        FirebaseStorage.instance.ref().child('Teacher/$nameImage');
    StorageUploadTask uploadTask = reference.putFile(file);

    await (await uploadTask.onComplete).ref.getDownloadURL().then((value) {
      urlAvatar = value;
      print('urlAvatar new ==>> $urlAvatar');
      insertValueToFirestore();
    });
  }

  Future<Null> insertValueToFirestore() async {
    TypeModel model = TypeModel(
      name: name,
      type: 'Teacher',
      pathImage: urlAvatar,
      education: educatChoose,
      address: address,
      phone: phone,
      website: website,
    );
    Map<String, dynamic> map = model.toJson();
    await FirebaseFirestore.instance.collection('Type').doc(uid).set(map).then(
          (value) => Navigator.pop(context),
        );
  }
}
