
import 'dart:convert';
import 'package:clients/pages/DicTable.dart';
import 'package:clients/pages/InsertRoute.dart';
import 'package:clients/pages/LoginRoute.dart';
import 'package:clients/pages/SearchRoute.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ManageRoute extends StatefulWidget { 
  late final title; 
  late final Table; 
  final String Host; 
  final String Port; 
 
  ManageRoute({
    Key? key, 
    this.Host="http://localhost", 
    this.Port="8888", 
    required this.title, 
    required this.Table, 
  }) :  super(key: key);

  @override
  State<ManageRoute> createState() => _ManageRouteState();
}

class _ManageRouteState extends State<ManageRoute> { 
  late List tInfoList ;

  void getTableInfo() async { 
    Dio dio = Dio(); 
    Response response = await dio.get(
      "${widget.Host}:${widget.Port}/table", 
      data: jsonEncode(
        { "Table": widget.Table, }
      )
    );
    tInfoList = response.data; 
    print(tInfoList);
    //addInputBoxList(tInfoList);
  }

  void getData() async
  {
    Dio dio = Dio(); 
    Response response = await dio.post(
      "${widget.Host}:${widget.Port}/search", 
      data: { "Table" : widget.Table },
    );

    int len = response.data.length; 
      List<Map<String, dynamic>> info = [];
      print("The len of xxx is");
      print(len);
      if( len > 1 ) 
      {
        print( len.toString() );// + response.data );
        for (var i = 0; i < len; i++ )
        {
          print( response.data.runtimeType );
          //Map<String, dynamic> tmp = response.data;
          Map<String, dynamic> tmp = response.data[i];
          info.add( tmp );
        }
      }
      else 
      {
        List<Map<String, dynamic>> info = [];
        //for (var i = 0; i < len; i++ )
        {
          //print( response.data.runtimeType );
          //Map<String, dynamic> tmp = jsonDecode( response.data[0].toString() );
          //Map<String, dynamic> tmp = jsonDecode(response.data); //[0];
          Map<String, dynamic> tmp = jsonDecode(jsonEncode(response.data[0]));
          print(tmp);
          //Map<String, dynamic> tmp = response.data;
          //Map<String, dynamic> tmp = response.data[i];
          info.add( tmp );
        }
      }

    setState(() {
      //_currentWidget = Text(response.data.toString());
      _currentWidget = Center( child: DicTableBody(dicList: info, context: context, Table: widget.Table, Port: widget.Port, Host: widget.Host, ), );
      //_currentWidget = Center( child: DicTableBody(dicList: [{"ID":1, "Name":2}],) );
    });
  }

  //var _currentWidget = DicTableBody(dicList: [{"ID":1}],) ;
  var _currentWidget = Center( child: Text("请载入数据") );//DicTableBody(dicList: [{"ID":1}] , context: context,) );


  @override
  Widget build(BuildContext context) {
    //return Container();
      return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + "管理"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () { 
                  getTableInfo();
                  getData();
                },
                child: Text( '载入' + widget.title),
              ),
              // 新增 
              ElevatedButton(
                onPressed: () {
                  getTableInfo();
                  print(tInfoList); 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) { 
                        return InsertRoute(
                          title: widget.title,
                          Table: widget.Table,
                          tInfoList: tInfoList,
                          Port: widget.Port, 
                          Host: widget.Host,
                        );
                        //return SearchRoute(UserInfo: );
                      }
                    )
                  );
                },
                child: Text( '新增' + widget.title),
              ),
              // 搜索 
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) { 
                        return SearchRoute(
                          title: widget.title,
                          tInfoList: tInfoList,
                          Table: widget.Table, 
                          Host: widget.Host,
                          Port: widget.Port, 
                        );
                        //return SearchRoute(UserInfo: );
                      }
                    )
                  );
                },
                child: Text( '搜索' + widget.title),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(child: _currentWidget),
        ],
      ),
    );
  }
}