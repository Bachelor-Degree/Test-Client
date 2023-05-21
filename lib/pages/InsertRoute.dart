
import 'dart:convert';
import 'package:clients/pages/DicTable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InsertRoute extends StatefulWidget {
  // 表名、ID、默认值
  late final title; 
  final String Table;
  //final Map WaitData;
  late List tInfoList; 
  final String Host;
  final String Port;

  InsertRoute({
    Key? key,
    this.Host="http://localhost",
    this.Port="8888",
    required this.title,
    required this.Table,
    required this.tInfoList,
  });

  @override
  _InsertRouteState createState() => _InsertRouteState();
}

class _InsertRouteState extends State<InsertRoute> {
  late List tInfoList = widget.tInfoList ;// widget.WaitData.keys.toList();
  List<Widget> inputBoxes = [];
  Map<String, String> data = {};

  void initState()
  {
    //getTableInfo();
    setState(() {
      print(tInfoList);
      tInfoList.remove("ID");
      addInputBoxList(tInfoList);
    });
  }

  void addInputBoxList(List labels) {
    setState(() {
      inputBoxes = [];
      for (var i = 0; i < labels.length; i++) {
        inputBoxes.add(
          Column(
            children: [
              TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: labels[i],
                  //hintText: widget.WaitData[labels[i]].toString(),
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        );
      }
    });
  }

  void updateData() async {
    data = { "Table": widget.Table };
    for (var i = 0; i < inputBoxes.length; i += 1) {
      if (inputBoxes[i] is Column) {
        Column tmp = inputBoxes[i] as Column;
        TextField valueField = tmp.children[0] as TextField;
        print(valueField.controller?.text);
        if (valueField.controller!.text.isNotEmpty){
          data[ tInfoList[i] ] = valueField.controller!.text;
        }
      }
    }
    //data["ID"] = widget.WaitData["ID"].toString();
    print(data);
    try{
      Dio dio = Dio();
      Response response = await dio.post(
        //"http://localhost:8888/update",
        "${widget.Host}:${widget.Port}/insert",
        data: jsonEncode(data),
      );
      int len = response.data.length;
      //print( response.data );
      List<Map<String, dynamic>> info = [];
      //for (var i = 0; i < len; i++ )
      {
        print( response.data.runtimeType );
        Map<String, dynamic> tmp = response.data;
        //Map<String, dynamic> tmp = response.data[i];
        info.add( tmp );
      };

      Navigator.pop(context, "成功！");

    }
    catch(e)
    {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("提示",),
          content: Text(e.toString()),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新增${widget.title}')),
      body: ListView(
        children: [
          SizedBox(height: 16.0),

          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: updateData,
            child: Text('新增${widget.title}'),
          ),
          SizedBox(height: 16.0),
          Column(children: inputBoxes),
        ],
      ),
    );
  }
}
