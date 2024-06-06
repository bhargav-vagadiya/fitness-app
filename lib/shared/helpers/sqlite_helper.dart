import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  Future<String> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    return "$databasesPath/workout.db";
  }

  Future deleteData(String table, String? where) async {
    var db = await createDatabase();
    return await db.rawDelete("Delete from $table where $where");
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
            'CREATE TABLE exercise (id Varchar(100) primary key, name text,w_id int,reorder_no int,foreign key(w_id) references Workout(id))');
        await db.execute(
            'CREATE TABLE Sets (id integer PRIMARY KEY autoincrement,kg int,reps int,e_id int,foreign key(e_id) references exercise(id))');
      },
    );
  }

  Future<List<int>> insertData(
      String table, List<Map<String, dynamic>> values) async {
    var db = await createDatabase();
    List<int> ids = [];
    await db.transaction((txn) async {
      await Future.forEach(
        values,
        (element) async {
          var id = await txn.insert(
            table,
            element,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          ids.add(id);
        },
      );
    });
    return ids;
  }

  Future<List<int>> updateData(
      String table, List<Map<String, dynamic>> values, int wid) async {
    var db = await createDatabase();
    List<int> ids = [];
    await db.transaction((txn) async {
      await Future.forEach(
        values,
        (element) async {
          var id = await txn.update(
            table,
            element,
            where: "id = ?",
            whereArgs: [wid],
            conflictAlgorithm: ConflictAlgorithm.abort,
          );
          ids.add(id);
        },
      );
    });
    return ids;
  }

  Future<List<Map<String, Object?>>> readData(String table) async {
    var db = await createDatabase();
    return await db.query(table);
  }

  Future<List<Map<String, Object?>>> readDataByRawQuery(String query) async {
    var db = await createDatabase();
    return await db.rawQuery(query);
  }
}
