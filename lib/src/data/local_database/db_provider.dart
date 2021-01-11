import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wively/src/data/local_database/message_table.dart';
import 'package:wively/src/data/local_database/room_table.dart';
import 'package:wively/src/data/local_database/user_table.dart';
import 'package:wively/src/data/models/chat.dart';
import 'package:wively/src/data/models/message.dart';
import 'package:wively/src/data/models/room.dart';
import 'package:wively/src/data/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'chat_table.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await _open();
    return _database;
  }
  

  Future _open() async {
    print("creating db");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "fala_comigo.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await RoomTable.createTable(db);
      await UserTable.createTable(db);
      await ChatTable.createTable(db);
      await MessageTable.createTable(db);
    }, onOpen: (Database db) async {
      // await UserTable.recreateTable(db);
      // await ChatTable.recreateTable(db);
      // await MessageTable.recreateTable(db);
    });
  }

  Future<User> getUser(String id) async {
    final db = await database;
    final users = await db.rawQuery('''
      SELECT tb_user._id,
             tb_user.name,
             tb_user.username
      FROM tb_user
      WHERE tb_user._id = '$id'
    ''');
    if (users.length > 0) {
      return User.fromLocalDatabaseMap(users.first);
    }
    return null;
  }

  Future<Room> getRoom(String id) async {
    final db = await database;
    final rooms = await db.rawQuery('''
      SELECT tb_room._id,
             tb_room.room_name,
             tb_room.task_board_id
      FROM tb_room
      WHERE tb_room._id = '$id'
    ''');
    if (rooms.length > 0) {
      return Room.fromLocalDatabaseMap(rooms.first);
    }
    return null;
  }

  Future<User> createUser(User user) async {
    try {
      final db = await database;
      await db.insert('tb_user', user.toLocalDatabaseMap());
      return user;
    } catch (err) {
      print("error $err");
      return user;
    }
  }
  Future<Room> createRoom(Room room) async {
    try {
      final db = await database;
      await db.insert('tb_room', room.toLocalDatabaseMap());
      return room;
    } catch (err) {
      print("error $err");
      return room;
    }
  }

  Future<User> createUserIfNotExists(User user) async {
    final _user = await getUser(user.id);
    if (_user == null) {
      await createUser(user);
    }
    return user;
  }

  Future<Room> createRoomIfNotExists(Chat chat) async {
    final _room = await getRoom(chat.room.id);
    if (_room == null) {
      await createRoom(chat.room);
    }
    return chat.room;
  }

  Future<Chat> createChatIfNotExists(Chat chat) async {
    try {
      final db = await database;
      final room_chats = await db.rawQuery('''
        SELECT * FROM tb_room_chat
        WHERE _id = '${chat.id}'
      ''');
      if (room_chats.length == 0) {
        await db.insert('tb_room_chat', chat.toLocalDatabaseMap());
      }
      return chat;
    } catch (err) {
      print("error $err");
      return chat;
    }
  }

  Future<List<Message>> getChatMessages(String roomId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT tb_message.id_message,
             tb_message._id,
             tb_message.from_user,
             tb_message.to_room,
             tb_message.message,
             tb_message.send_at,
             tb_message.unread_by_me
      FROM tb_message
      WHERE tb_message.room_id = '$roomId'
      ORDER BY tb_message.send_at DESC
      LIMIT 25
    ''');
    if (maps.length > 0) {
      return maps
          .map((message) => Message.fromLocalDatabaseMap(message))
          .toList();
    }
    return [];
  }

  Future<void> readChatMessages(String id) async {
    final db = await database;
    await db.rawQuery('''
      UPDATE tb_message
      SET unread_by_me = 0
      WHERE room_id = '$id'
    ''');
  }

  Future<List<Message>> getChatMessagesWithOffset(String roomId, int localMessageId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT tb_message.id_message,
             tb_message._id,
             tb_message.from_user,
             tb_message.to_room,
             tb_message.message,
             tb_message.send_at,
             tb_message.unread_by_me
      FROM tb_message
      WHERE tb_message.room_id = '$roomId'
      AND tb_message.id_message < $localMessageId
      ORDER BY tb_message.send_at DESC
      LIMIT 25
    ''');
    if (maps.length > 0) {
      return maps
          .map((message) => Message.fromLocalDatabaseMap(message))
          .toList();
    }
    return [];
  }

  Future<int> addMessage(Message message) async {
    final db = await database;
    final id = await db.insert('tb_message', message.toLocalDatabaseMap());
    return id;
  }


  void testAQuery()async{
    final db = await database;
    final maps=await db.rawQuery('''
    SELECT * FROM tb_room
    ''');
    Fluttertoast.showToast(msg: maps.toString());


  }


  Future<List<Chat>> getChatsWithMessages() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT tb_room_chat._id,
             tb_room._id as room_id,
             tb_room.room_name,
             tb_room.task_board_id,
             tb_message.id_message,
             tb_message._id as message_id,
             tb_message.from_user,
             tb_message.to_room,
             tb_message.message,
             tb_message.send_at,
             tb_message.unread_by_me
      FROM tb_room_chat
      INNER JOIN tb_message
        ON tb_room_chat._id = tb_message.room_id
      INNER JOIN tb_room
        ON tb_room_chat._id = tb_room._id
      ORDER BY tb_message.send_at DESC
    ''');
    if (maps.length > 0) {
      List<Chat> chats = [];

      maps.toList().forEach((map) {
        if (chats.indexWhere((chat) => chat.id == map['_id']) == -1) {
          chats.add(Chat.fromLocalDatabaseMap(map));
        }
        final chat = chats.firstWhere((chat) => chat.id == map['_id']);
        final message = Message.fromLocalDatabaseMap({
            "_id": map['message_id'],
            "from": map['from_user'],
            "to": map['to_room'],
            "message": map['message'],
            "send_at": map['send_at'],
            "unread_by_me": map['unread_by_me'],
          });
          chat.messages.add(message);

      });

      return chats;
    }

    return [];
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.rawQuery("DELETE FROM tb_message");
    await db.rawQuery("DELETE FROM tb_room_chat");
    await db.rawQuery("DELETE FROM tb_user");
    await db.rawQuery("DELETE FROM tb_room");
  }

}
