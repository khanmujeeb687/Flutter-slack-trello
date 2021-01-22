import 'package:sqflite/sqflite.dart';

class MessageTable {

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table tb_message (
            id_message integer primary key autoincrement, 
            _id text,
            chat_id text not null,
            message text not null,
            from_username text not null,
            from_user text not null,
            to_room text,
            to_user text,
            file_urls text,
            file_upload_state text,
            send_at int not null,
            unread_by_me bool default 1,
            constraint tb_message_chat_id_fk foreign key (chat_id) references tb_room_chat (_id),
            constraint tb_message_from_user_fk foreign key (from_user) references tb_user (_id),
            constraint tb_message_to_room_fk foreign key (to_room) references tb_room (_id),
            constraint tb_message_to_user_fk foreign key (to_user) references tb_chat (_id)
          )
          ''');
    await db.execute('''
      CREATE INDEX idx_id_message
      ON tb_message (_id)
    ''');
  }
  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_message
          ''');
    await MessageTable.createTable(db);
  }


}
