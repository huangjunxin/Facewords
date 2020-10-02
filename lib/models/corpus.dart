import 'dart:convert';

Corpus wordFromJson(String str) => Corpus.fromJson(jsonDecode(str));
String wordToJson(Corpus data) => jsonEncode(data.toJson());

class Corpus {
  int corpusId;
  String corpus;
  String language;
  int wordId;

  Corpus({
    this.corpusId,
    this.corpus,
    this.language,
    this.wordId,
  });

  factory Corpus.fromJson(Map<String, dynamic> json) => Corpus(
    corpusId: json['corpusId'],
    corpus: json['corpus'],
    language: json['language'],
    wordId: json['wordId'],
  );

  Map<String, dynamic> toJson() => {
    'corpusId': corpusId,
    'corpus': corpus,
    'language': language,
    'wordId': wordId,
  };
}
