import 'dart:io';
import 'dart:async';
import 'package:employee_list/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'models/emp.dart';
import 'dart:io' as Io;
import 'dart:convert';




class secondScreeen  extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return _second();
  }
}


class _second extends State<secondScreeen> {

  DatabaseHelper helper = DatabaseHelper.instance;

  Emp emp;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File _image;
  String _imageData;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    // nameController.text = emp.name;
    // ageController.text = emp.age;


    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add New Employee'),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 35, left: 10, right: 10),
                     child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Color(0xFFFFFFFF),
                            child: _image != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 35, right: 10),
                    child: Container(
                      height: 50.0,
                      child: TextField(
                        controller: nameController,
                        onChanged: (value) {
                          debugPrint(nameController.text);
                         // _updateName();
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        )
                        ,
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: Container(
                      height: 50.0,
                      child: TextField(
                        controller: ageController,
                        onChanged: (value) {
                          debugPrint(ageController.text);
                         // _updateAge();
                        },
                        decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: 'Enter Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 80, right: 80, top: 20),
                    child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Save', textScaleFactor: 1.5,),
                        onPressed: () {
                          setState(() {
                            debugPrint('save Pressed');
                            _save(nameController.text, ageController.text,_imageData);
                          });

                        }
                    ),
                  ),
                ],
              ),),

          )
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 100,maxHeight: 150,
    );

    final bytes = Io.File(image.path).readAsBytesSync();

    String img64 = base64Encode(bytes);

    setState(() {
      _image = image;
      _imageData = img64;
     //encImg();
    });


   // print("Image picker file path - $_imagePath");

  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50,maxWidth: 100,maxHeight: 150,
    );
    // final bytes = Io.File('$image').readAsBytesSync();
    //
    // _imageData = await base64Encode(bytes);
    // print(_imageData.substring(0, 100));

    final bytes = Io.File(image.path).readAsBytesSync();

    String img64 = base64Encode(bytes);
  //  print(img64);

    setState(() {
      _image = image;
      _imageData = img64;
    });
   // encImg();

   // print("Image picker file path - $_imagePath");
  }

  // encImg() {
  //   final bytes = Io.File('$_image').readAsBytesSync();
  //
  //   _imageData = base64Encode(bytes);
  //   print(_imageData.substring(0, 100));
  // }


  void _save(name, age ,path) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.colName: name,
      DatabaseHelper.colAge: age,
      DatabaseHelper.colPath: path,

    };
    Emp emp = Emp.fromMap(row);
    final id = await helper.insertEmp(emp);
    //_showMessageInScaffold('inserted row id: $id');
    _showAlertDialog('Saved', 'Sucessfully');
  }

  // void moveToLastscreen(){
  //   Navigator.pop(context, true);
  // }


  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
