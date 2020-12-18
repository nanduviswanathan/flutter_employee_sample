import 'package:employee_list/helper/database_helper.dart';

class Emp {

  int id;
  String name;
  String age;
  String path;

  Emp(this.id, this.name, this.age, this.path);

  Emp.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    age = map['age'];
    path = map['path'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.colId: id,
      DatabaseHelper.colName: name,
      DatabaseHelper.colAge: age,
      DatabaseHelper.colPath: path,
    };
  }



  // int _id;
  // String _name;
  // String _age;
  //
  // Emp(this._name,this._age);
  // Emp.withId(this._id,this._name,this._age);
  //
  // int get id => _id;
  // //
  //  String get name => _name;
  // //
  // String get age => _age;
  //
  // set name(String newName){
  //   if(newName.length <= 255){
  //     this._name = newName;
  //   }
  // }
  // set age(String newAge){
  //   this._age = newAge;
  // }
  //
  //
  // //Convert note object to map
  //
  // Map<String, dynamic> toMap(){
  //
  //     var map = Map<String, dynamic>();
  //     map['id'] = _id;
  //     map['name'] = _name;
  //     map['age'] = _age;
  //
  //     return map;
  // }
  //
  // // map to note
  //
  // Emp.fromMapObject(Map<String, dynamic> map) {
  //   this._id = map['id'];
  //   this._name = map['name'];
  //   this._age = map['age'];
  // }

}

