import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  Future<String> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    return "$databasesPath/workout.db";
  }

  Future<Database> createDatabase() async {
    return await openDatabase(
      await initDatabase(),
      version: 1,
      onCreate: (db, version) async {
        await db
            .execute('CREATE TABLE Muscles (id TEXT PRIMARY KEY, name TEXT)');
        await db
            .execute('CREATE TABLE Equipment (id TEXT PRIMARY KEY, name TEXT)');
        await db.execute(
            'CREATE TABLE Workout (id INTEGER primary key autoincrement, name text)');
        await db.execute(
            'CREATE TABLE exercise (id TEXT, name text,w_id int,reorder_no int,foreign key(w_id) references Workout(id))');
        await db.execute(
            'CREATE TABLE Sets (kg int,reps int,e_id int,foreign key(e_id) references exercise(id))');
      },
    );
  }

  Future<void> insertData(
      String table, List<Map<String, dynamic>> values) async {
    var db = await createDatabase();
    await db.transaction((txn) async {
      await Future.forEach(
        values,
        (element) async {
          int id = await txn.insert(
            table,
            element,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        },
      );
    });
  }

  Future<List<Map<String, Object?>>> readData(String table) async {
    var db = await createDatabase();
    return await db.query(table);
  }
}
