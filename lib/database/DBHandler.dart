import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import '../contacts/model/ContactsModel.dart';

class DBHandler {
  //database name
  static const dbName = "iCRM5.db";

  static const callPopUpTable = "call_pop_up";

  //Call log table
  static const callLogTable = "call_log";
  static const phoneNumber = "phone_number";
  static const name = "name";

  //call log details table
  static const callLogDetailsTable = "call_log_details";
  static const id = "id";
  static const type = "type";
  static const dateTime = "date";
  static const time = "time";
  static const duration = "duration";

  //call log details table
  static const leadContactsTable = "lead_contacts";

  //App package name
  static const appPackageName = "com.example.dialercall";

  static const dbVersion = 1;

  static final DBHandler instance = DBHandler();

  Future<Database?> get database async {
    return await initDB();
  }

  initDB() async {
    //Android database path
    String path = "/data/data/$appPackageName/databases/$dbName";

    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE $callLogTable(
                $phoneNumber TEXT PRIMARY KEY,
                $name TEXT(50),
                $type TEXT(15) ,
                $dateTime DATETIME,
                $time TEXT(15)
                )''');

      await db.execute('''
      CREATE TABLE $callLogDetailsTable(
                $id INTEGER PRIMARY KEY AUTOINCREMENT ,
                $type TEXT(15) ,
                $dateTime TEXT(15) ,
                $time TEXT(15) ,
                $duration TEXT(10) ,
                $phoneNumber TEXT(16)
      )''');

      await db.execute('''
      CREATE TABLE $callPopUpTable(
                $id INTEGER PRIMARY KEY AUTOINCREMENT ,
                call_status TEXT(15) ,
                note TEXT(15) ,
                reminder TEXT(16)
      )''');

      await db.execute('''
      CREATE TABLE $leadContactsTable(
                $id INTEGER PRIMARY KEY,
                customer_name TEXT ,
                phone_number TEXT(20) ,
                company TEXT
      )''');
    } catch (e) {
      log("Database create error : $e");
    }
  }

  //Insert new call log
  updateLastCallLogs(Map<String, dynamic> row, String phoneNumber) async {
    try {
      Database? db = await instance.database;
      await db!.update(callLogTable, row,
          where: "phone_number = ?", whereArgs: [phoneNumber]);
    } catch (e) {}
  }

  //Insert new call log
  insertANewRecord(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      await db!.insert(callLogTable, row);
    } catch (e) {}
  }

  // Read call logs list
  Future<List<Map<String, dynamic>>> getCallLogs() async {
    Database? db = await instance.database;
    return await db!.query(callLogTable, orderBy: "$dateTime DESC");
  }

  // Insert a new call history
  insertACallHistory(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      await db!.insert(callLogDetailsTable, row);
    } catch (e) {}
  }

  //Call history
  Future<List<Map<String, dynamic>>> getCallHistory(String phoneNumber) async {
    Database? db = await instance.database;
    return await db!.query(callLogDetailsTable,
        where: "phone_number = ?",
        whereArgs: [phoneNumber],
        orderBy: "$id DESC");
  }

  //Date a call history
  deleteCallHistory(String phoneNumber) async {
    try {
      Database? db = await instance.database;
      await db!.delete(callLogTable,
          where: "phone_number = ?", whereArgs: [phoneNumber]);
      await db!.delete(callLogDetailsTable,
          where: "phone_number = ?", whereArgs: [phoneNumber]);
    } catch (e) {}
  }

  //DialPad search
  Future<List<Map<String, dynamic>>> getDialPadSearch(String keyword) async {
    Database? db = await instance.database;
    return await db!
        .query(callLogTable, where: "$phoneNumber LIKE '%$keyword%'");
  }

  //Call Pop Up data
  Future<List<Map<String, dynamic>>> getCallPopUpInfo() async {
    Database? db = await instance.database;
    return await db!.query(callPopUpTable);
  }

  //Delete all call pop up record
  deleteAllCallPopUP() async {
    try {
      Database? db = await instance.database;
      await db!.delete(callPopUpTable);
    } catch (e) {}
  }

  //Store lead contacts
  storeLeadContacts(List<ContactsModel> contacts) async {
    try {
      Database? db = await instance.database;
      await db!.delete(leadContactsTable);
      for (var element in contacts) {
        await db!.insert(leadContactsTable, element.toMap());
      }
    } catch (e) {}
  }

  // Get lead contacts list
  Future<List<Map<String, dynamic>>> leadContacts() async {
    Database? db = await instance.database;
    return await db!.query(leadContactsTable);
  }
}
