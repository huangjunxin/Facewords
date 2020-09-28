import 'package:facewords/models/word.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  // 获取 Database 对象
  Future<Database> get database async {
    // 使用单例模式创建 Database 对象
    // 如果已经存在 Database 则直接返回
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  // 初始化数据库
  initDB() async {
    // 获取文档目录
    return await openDatabase(join(await getDatabasesPath(), 'facewords.db'),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE wordList (
            wordId INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            language TEXT,
            pos TEXT,
            meaning TEXT,
            count INTEGER
          )
        ''');
    }, version: 1);
  }

  newWord(Word newWord) async {
    final db = await database;

    var res = await db.rawInsert('''
      INSERT INTO wordList (
        wordId, word, language, pos, meaning, count
      ) VALUES (?, ?, ?, ?, ?, ?)
    ''', [
      newWord.wordId,
      newWord.word,
      newWord.language,
      newWord.pos,
      newWord.meaning,
      newWord.count
    ]);

    return res;
  }

  // 获取整个 wordList
  Future<List<Word>> getWordList() async {
    final db = await database;
    var res = await db.query('wordList');
    if (res.length == 0) {
      return null;
    } else {
      List<Word> resWordList = (res.isNotEmpty
          ? res.map((value) => Word.fromJson(value)).toList()
          : null);
      return resWordList;
    }
  }

  // 根据 word 获取单个 word
  Future<Word> getWordByWord(String word) async {
    final db = await database;
    var res = await db.query(
      'wordList',
      where: 'word = ?',
      whereArgs: [word],
    );
    return res.isNotEmpty ? Word.fromJson(res[0]) : null;
  }

  // 根据 wordId 删除 word
  deleteWord(int wordId) async {
    final db = await database;
    return db.delete(
      'wordList',
      where: 'wordId = ?',
      whereArgs: [wordId],
    );
  }
  
  // 根据 word 修改 word
  updateWord(Word updatedWord) async {
    final db = await database;
    return db.update(
      'WordList',
      updatedWord.toJson(),
      where: 'wordId = ?',
      whereArgs: [updatedWord.wordId],
    );
  }
}
