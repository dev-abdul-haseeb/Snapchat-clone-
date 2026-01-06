import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBManager {
  //Singleton
  DBManager._();
  static DBManager getInstance() {
    return DBManager._();
  }

  Database? myDB;

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  // db open (path-> if exists else create)

  Future<Database> openDB() async {
    Directory appdir = await getApplicationDocumentsDirectory();

    String dbPath = join(
      appdir.path,
      "users.db",
    ); //Path where to create db, Name of db

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE ACCOUNTS (
        firstName TEXT NOT NULL,
        lastName TEXT,
        day INTEGER NOT NULL,
        month TEXT NOT NULL,
        year INTEGER NOT NULL,
        username TEXT PRIMARY KEY,
        password TEXT NOT NULL
      )
    ''');

        await db.execute('''
      CREATE TABLE MESSAGES (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender TEXT NOT NULL,
        receiver TEXT NOT NULL,
        message TEXT NOT NULL,
        FOREIGN KEY(sender) REFERENCES ACCOUNTS(username),
        FOREIGN KEY(receiver) REFERENCES ACCOUNTS(username),
        CHECK (sender != receiver)
      )
    ''');

        await db.execute('''
      CREATE TABLE FRIENDS (
        user1 TEXT NOT NULL,
        user2 TEXT NOT NULL,
        status INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (user1, user2),
        FOREIGN KEY(user1) REFERENCES ACCOUNTS(username),
        FOREIGN KEY(user2) REFERENCES ACCOUNTS(username),
        CHECK (user1 != user2)
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute(
            'ALTER TABLE FRIENDS ADD COLUMN status INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<bool> createUser({
    required String Username,
    required String Password,
    required String fName,
    required String lName,
    required int Day,
    required int Year,
    required String Month,
  }) async {
    var db = await getDB();
    var result = await db.query(
      'ACCOUNTS',
      where: 'username = ?',
      whereArgs: [Username],
    );
    if (result.isNotEmpty) return false; // username already exists
    int id = await db.insert('ACCOUNTS', {
      'username': Username,
      'password': Password,
      'firstName': fName,
      'lastName': lName.isEmpty ? null : lName,
      'day': Day,
      'month': Month,
      'year': Year,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return id > 0;
  }

  Future<bool> createMessage({
    required String sender,
    required String receiver,
    required String message,
  }) async {
    if (sender == receiver) {
      return false;
    }
    final db = await getDB();
    final users = await db.query(
      'ACCOUNTS',
      where: 'username = ? OR username = ?',
      whereArgs: [sender, receiver],
    );
    if (users.length < 2) {
      return false;
    }
    int id = await db.insert('MESSAGES', {
      'sender': sender,
      'receiver': receiver,
      'message': message,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return id > 0;
  }

  Future<bool> createFriend({
    required String user1,
    required String user2,
  }) async {
    if (user1 == user2) return false;
    final db = await getDB();

    final users = await db.query(
      'ACCOUNTS',
      where: 'username = ? OR username = ?',
      whereArgs: [user1, user2],
    );
    if (users.length < 2) return false;

    final existing = await db.query(
      'FRIENDS',
      where: 'user1 = ? AND user2 = ?',
      whereArgs: [user1, user2],
    );
    if (existing.isNotEmpty) return false;

    int id = await db.insert('FRIENDS', {
      'user1': user1,
      'user2': user2,
      'status': 1, // request sent
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    return id > 0;
  }

  Future<List<Map<String, dynamic>>> getMessagesBetweenUsers(
    String user1,
    String user2,
  ) async {
    final db = await getDB();

    final result = await db.query(
      'MESSAGES',
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'rowid ASC', // orders messages in insertion order
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getFriendsOf(String user) async {
    final db = await getDB();

    final result = await db.rawQuery('''
    SELECT a.username, a.firstName, a.lastName
    FROM FRIENDS f
    JOIN ACCOUNTS a 
      ON (f.user1 = a.username AND f.user2 = ?) 
      OR (f.user2 = a.username AND f.user1 = ?)
    WHERE f.status = 2
  ''', [user, user]);

    return result;
  }


  Future<bool> loginUser(String username, String password) async {
    final db = await getDB();

    final result = await db.query(
      'ACCOUNTS',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getNonFriendsOf(String username) async {
    final db = await getDB();

    final result = await db.rawQuery(
      '''
    SELECT username, firstName, lastName FROM ACCOUNTS
    WHERE username != ?
      AND username NOT IN (
        SELECT user2 FROM FRIENDS WHERE user1 = ? AND status IN (1, 2)
        UNION
        SELECT user1 FROM FRIENDS WHERE user2 = ? AND status IN (1, 2)
      )
  ''',
      [username, username, username],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getSentFriendRequests(
    String username,
  ) async {
    final db = await getDB();

    final result = await db.rawQuery(
      '''
    SELECT ACCOUNTS.username, ACCOUNTS.firstName, ACCOUNTS.lastName
    FROM FRIENDS
    JOIN ACCOUNTS ON FRIENDS.user2 = ACCOUNTS.username
    WHERE FRIENDS.user1 = ? AND FRIENDS.status = 1
  ''',
      [username],
    );

    return result;
  }

  Future<bool> acceptFriendRequest({
    required String sender,
    required String receiver,
  }) async {
    final db = await getDB();
    int count = await db.update(
      'FRIENDS',
      {'status': 2},
      where: 'user1 = ? AND user2 = ? AND status = 1',
      whereArgs: [sender, receiver],
    );
    return count > 0;
  }

  Future<List<Map<String, dynamic>>> getReceivedFriendRequests(
      String currentUsername,
      ) async {
    final db = await getDB();

    return await db.rawQuery(
      '''
    SELECT ACCOUNTS.username, ACCOUNTS.firstName, ACCOUNTS.lastName
    FROM FRIENDS
    JOIN ACCOUNTS ON FRIENDS.user1 = ACCOUNTS.username
    WHERE FRIENDS.user2 = ? AND FRIENDS.status = 1
    ''',
      [currentUsername],
    );
  }

}
