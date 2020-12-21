
import 'package:employee_list/helper/database_helper.dart';
import 'package:employee_list/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as Io;
import 'dart:convert';

import 'models/emp.dart';




class firstScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _firstScreen();
  }
}

class _firstScreen extends State<firstScreen>{

  final dbHelper = DatabaseHelper.instance;
  List<Emp> empList;
  int count = 0;


  @override
  Widget build(BuildContext context) {

    if (empList == null){
      empList = List<Emp>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
          actions: <Widget>[
      Container(
      padding: EdgeInsets.only(right: 10.0),
      child: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () async {
          await updateListView();
        },
      ),
     ),
          ]
      ),
      body:getListView(),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Employee',
        child: Icon(Icons.add),
        onPressed: () {
          debugPrint('add pressed');
          Navigator.push(context, MaterialPageRoute(builder:( context){
            return secondScreeen();
            updateListView();
          }));
        },
      ),
    );

  }


 ListView getListView(){

    return ListView.builder(
        itemCount: empList.length,
        itemBuilder: (BuildContext context, int position){
          final _byteImage = Base64Decoder().convert(this.empList[position].path);
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child:  new Image.memory(_byteImage),
                //Icon(Icons.account_circle_outlined),
              ),
              title: Text(this.empList[position].name ,),
              subtitle: Text(this.empList[position].age,),
            ),
          );
        }
    );
  }

  void updateListView() async{
      final allRows = await dbHelper.queryAllRows();
      empList.clear();
      allRows.forEach((row) => empList.add(Emp.fromMap(row)));
      //_showMessageInScaffold('Query done.');
      setState(() {});
    }

}

