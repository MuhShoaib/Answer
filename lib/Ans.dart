

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;

class Answer {

  String? ans;


  Answer({this.ans});

  factory Answer.fromJson(dynamic json) {
    return Answer(
     ans: "${json['ans']}",
    );
  }




}

