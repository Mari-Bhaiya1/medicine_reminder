import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medicinereminder/database/pill_database.dart';
import 'package:medicinereminder/models/pill_type.dart';
import 'package:medicinereminder/notifications/notifications.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Respository {
  final PillDatabase _pillDatabase = PillDatabase();
  static Database? _database;
  final FirebaseDatabase _realtimeDatabase = FirebaseDatabase.instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _pillDatabase.setDataBase();
    return _database!;
  }

  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    Database db = await database;
    try {
      return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Data insertion error: $e");
      return null;
    }
  }

  Future<int?> updateData(String table, Map<String, dynamic> data) async {
    Database db = await database;
    try {
      return await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
    } catch (e) {
      print("Data update error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAlldata(String table) async {
    Database? db = await database;
    try {
      return await db!.query(table);
    } catch (e) {
      print('Data fetching error.Please check the respository');
      return [];
    }
  }

  Future<int> deletePill(int id, int notifyId) async {
    Database? db = await database;
    try {
      final result = await db!.delete('Pills', where: 'id=?', whereArgs: [id]);
      await Notifications().cancelNotification(notifyId);
      return result;
    } catch (e) {
      print('Data deletion error: $e');
      return 0;
    }
  }

  Future<void> deleteAllPills(int groupId) async {
    Database? db = await database;
    try {
      final pills = await db!.query('Pills', where: 'groupId = ?', whereArgs: [groupId]);
      for (var pill in pills) {
        final p = Pill.fromMap(pill);
        await Notifications().cancelNotification(p.notifyId);
      }
      await db.delete('Pills', where: 'groupId = ?', whereArgs: [groupId]);
    } catch (e) {
      print('Data deletion error: $e');
    }
  }

  Future<void> clearLocalData() async {
    try {
      Database db = await database;
      await db.delete('Pills');
      print("✅ Local database cleared.");
    } catch (e) {
      print("❌ Error clearing local database: $e");
    }
  }

  Future<void> syncToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final localPills = await getAlldata('Pills');
      if (localPills.isEmpty) {
        await _realtimeDatabase.ref('users/${user.uid}/pills').remove();
        return;
      }
      
      final Map<String, dynamic> pillsMap = {
        for (var pill in localPills) pill['id'].toString(): pill
      };

      await _realtimeDatabase.ref('users/${user.uid}/pills').set(pillsMap);
      print("✅ Data successfully synced to Realtime Database");
    } catch (e) {
      print("❌ Error syncing to Realtime Database: $e");
    }
  }

  Future<void> syncFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await clearLocalData();

      final snapshot = await _realtimeDatabase.ref('users/${user.uid}/pills').get();

      if (!snapshot.exists || snapshot.value == null) {
        print("No data found in Realtime Database to sync.");
        return;
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      for (var pillData in data.values) {
        final pillMap = Map<String, dynamic>.from(pillData as Map);
        await insertData('Pills', pillMap);
      }
      print("✅ Data successfully synced from Realtime Database");
    } catch (e) {
      print("❌ Error syncing from Realtime Database: $e");
    }
  }
}
