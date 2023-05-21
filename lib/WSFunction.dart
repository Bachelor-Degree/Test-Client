
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:clients/main.dart';
import 'package:flutter/material.dart';

//void getHttp() async 
// return JSONString 
//Future<String> getHttp({String PATH='', String HOST='http://localhost', int POST=1234}) async
Future<String> getHttp({String PATH='', String HOST='http://localhost', int POST=1234}) async
{
  try {
    Dio d = Dio(); 
    Response resp = await d.get("$HOST:$POST/$PATH"); 
    print(resp.toString());
    //var user = jsonDecode(resp.data.toString());
    var user = jsonDecode(resp.toString());
    print(user['success']); 
    return resp.toString();
  }
  catch(e)
  {
    print(e);
    print("Error"); 
    Map info = {"success": 0}; 
    print(info.toString());
    return info.toString(); 
  }
}

//void postHttp() async 
Future<String> postHttp(Map info, {String PATH='', String HOST='http://localhost', int POST=1234}) async
{
  try {
    Dio dio = new Dio(); 
    String url = "$HOST:$POST/$PATH"; 
    Response resp = await dio.post(url, data: info); 
    //var data = resp.data; 
    print("RESP: "); 
    //print(resp.toString()); 
    //print(data); 
    return "Good"; 
  } 
  catch(e)
  {
    print(e); 
    print("Error");
    return "Error"; 
  }
}

Future<String> postHttpJSON(Map info, {String PATH='', String HOST='http://localhost', int POST=1234}) async
{
  try {
    Dio dio = new Dio(); 
    String url = "$HOST:$POST/$PATH"; 
    Response resp = await dio.post(url, data: info); 
    //var data = resp.data; 
    print("RESP: "); 
    //print(resp.toString()); 
    //print(data); 
    return "Good"; 
  } 
  catch(e)
  {
    print(e); 
    print("Error");
    return "Error"; 
  }
}