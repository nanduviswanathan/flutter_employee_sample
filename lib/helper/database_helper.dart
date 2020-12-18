import 'package:employee_list/models/emp.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper {

  static final _databaseName = "empdb.db";
  static final _databaseVersion = 1;

  static final table = 'cars_table';

  static final colId = 'id';
  static final colName = 'name';
  static final colAge = 'age';
  static final colPath = 'path';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colName TEXT NOT NULL,
            $colAge TEXT NOT NULL,
            $colPath TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertEmp(Emp emp) async {
    Database db = await instance.database;
    return await db.insert(table, {'name': emp.name, 'age': emp.age, 'path': emp.path});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$colName LIKE '%$name%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateEmp(Emp emp) async {
    Database db = await instance.database;
    int id = emp.toMap()['id'];
    return await db.update(table, emp.toMap(), where: '$colId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEmp(int id) async {
    Database db = await instance.database;
    return await db.delete('DELETE FROM $table');
  }
}


// class DatabaseHelper {
//
//   static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
//   static Database _database;                // Singleton Database
//
//   String noteTable = 'note_table';
//   String colId = 'id';
//   String colName = 'name';
//   String colAge =  'age';
//
//   DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper
//
//   factory DatabaseHelper() {
//
//     if (_databaseHelper == null) {
//       _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
//     }
//     return _databaseHelper;
//   }
//
//   Future<Database> get database async {
//
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }
//
//   Future<Database> initializeDatabase() async {
//     // Get the directory path for both Android and iOS to store database.
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = directory.path + 'emps.db';
//
//     // Open/create the database at a given path
//     var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
//     return notesDatabase;
//   }
//
//   void _createDb(Database db, int newVersion) async {
//
//     await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colAge INTEGER)');
//   }
//
//   // Fetch Operation: Get all note objects from database
//   Future<List<Map<String, dynamic>>> getEmpMapList() async {
//     Database db = await this.database;
//
// //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//     var result = await db.query(noteTable, orderBy: '$colName ASC');
//     return result;
//   }
//
//   // Insert Operation: Insert a Note object to database
//   Future<int> insertEmp(Emp emp) async {
//     Database db = await this.database;
//     var result = await db.insert(noteTable, emp.toMap());
//     return result;
//   }
//
//   // Update Operation: Update a Note object and save it to database
//   // Future<int> updateEmp(Emp emp) async {
//   //   var db = await this.database;
//   //   var result = await db.update(noteTable, emp.toMap(), where: '$colId = ?', whereArgs: [emp.id]);
//   //   return result;
//   // }
//
//   // Delete Operation: Delete a Note object from database
//   Future<int> deleteEmp(int id) async {
//     var db = await this.database;
//     int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
//     return result;
//   }
//
//   // Get number of Note objects in database
//   Future<int> getCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
//     int result = Sqflite.firstIntValue(x);
//     return result;
//   }
//
//   // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
//   Future<List<Emp>> getEmpList() async {
//
//     var empMapList = await getEmpMapList(); // Get 'Map List' from database
//     int count = empMapList.length;         // Count the number of map entries in db table
//
//     List<Emp> empList = List<Emp>();
//     // For loop to create a 'Note List' from a 'Map List'
//     for (int i = 0; i < count; i++) {
//       empList.add(Emp.fromMapObject(empMapList[i]));
//     }
//
//     return empList;
//   }
//
// }
