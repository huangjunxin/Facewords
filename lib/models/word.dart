import 'dart:convert';

Word wordFromJson(String str) => Word.fromJson(jsonDecode(str));
String wordToJson(Word data) => jsonEncode(data.toJson());

class Word {
  int wordId;
  String word;
  String language;
  String pos;
  String meaning;
  int count;

  Word({
    this.wordId,
    this.word,
    this.language,
    this.pos,
    this.meaning,
    this.count,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    wordId: json['wordId'],
    word: json['word'],
    language: json['language'],
    pos: json['pos'],
    meaning: json['meaning'],
    count: json['count'],
  );

  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'word': word,
    'language': language,
    'pos': pos,
    'meaning': meaning,
    'count': count,
  };
}
