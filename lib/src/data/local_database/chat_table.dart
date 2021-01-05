import 'package:sqflite/sqflite.dart';

class ChatTable {
  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_room_chat
        ''');
    await ChatTable.createTable(db);
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table tb_room_chat (
            id_chat integer primary key autoincrement,
            _id text not null,
            constraint tb_room_chat_id_fk foreign key (_id) references tb_room (_id))
          ''');
    await db.execute('''
      create unique index idx_id_chat
      on tb_room_chat (_id)
    ''');
  }
}
