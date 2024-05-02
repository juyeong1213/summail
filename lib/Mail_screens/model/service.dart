import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/api_points.dart';
import 'mail.dart';


class Services{
  static const String url = 'https://jsonplaceholder.typicode.com/Mails';

  static Future<List<Mail>> getInfo() async{
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode ==200){
        /*final List<Mail> Mail = MailFromJson(response.body);
        return Mail;*/
        final List<Mail> Mails = (json.decode(response.body) as List).map((i) => Mail.fromJson(i)).toList();
        return Mails;
      }else{
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <Mail>[];
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString());
      return <Mail>[];
    }
  }
}
