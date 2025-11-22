import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PillDatabase {
  setDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "pills_db");
    Database database = await openDatabase(
      path,
      version: 2, // Incremented database version
      onCreate: (Database db, int version) async {
        // Original table creation
        await db.execute(
          "CREATE TABLE Pills(id INTEGER PRIMARY KEY, name TEXT, amount TEXT, type TEXT, howManyDays INTEGER, medicineForm TEXT, time INTEGER, notifyId INTEGER, groupId INTEGER)",
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // Logic to handle database schema changes
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE Pills ADD COLUMN groupId INTEGER DEFAULT 0");
        }
      },
    );
    return database;
  }
}
