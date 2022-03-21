

import 'dart:convert';
import 'package:http/http.dart'as http;
import 'dart:convert' as convert;

class Answer {

  String? ans;


  Answer({ this.ans});

  factory Answer.fromJson(dynamic json) {
    return Answer(
     ans: "${json['ans']}",
    );
  }




}

class Alarm{
  String? alarm;

  Alarm({this.alarm});

  factory Alarm.fromJson(dynamic json) {
    return Alarm(
      alarm: "${json['alarm']}",
    );
  }


}

