import 'package:sqflite/sqflite.dart';
class RoomTable {

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_user
        ''');
    await RoomTable.createTable(db);
  }


  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table tb_room (
            id_room integer primary key autoincrement, 
            _id text not null,
            room_name text not null,
            )
          ''');
    await db.execute('''
      CREATE UNIQUE INDEX idx_id_room
      ON tb_room (_id)
    ''');
  }

}
