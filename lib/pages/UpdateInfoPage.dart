
import 'dart:convert';
import 'package:clients/pages/DicTable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateInfoPage extends StatefulWidget {
  // 表名、ID、默认值 
  final String Table; 
  final Map WaitData; 
  final String Host; 
  final String Port; 

  UpdateInfoPage({
    Key? key, 
    this.Host="http://localhost", 
    this.Port="8888", 
    required this.Table, 
    required this.WaitData, 
  });

  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  late List tInfoList = widget.WaitData.keys.toList(); 
  List<Widget> inputBoxes = [];
  Map<String, String> data = {}; 

  void initState()
  {
    //getTableInfo();
    setState(() {
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
                  hintText: widget.WaitData[labels[i]].toString(), 
                  //hintText: labels[i],
                  //labelText: widget.WaitData[labels[i]].toString(), 
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
    data["ID"] = widget.WaitData["ID"].toString();
    print(data); 
    try{
      Dio dio = Dio(); 
      Response response = await dio.post(
        //"http://localhost:8888/update", 
        "${widget.Host}:${widget.Port}/update", 
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

      Navigator.pop(context, "修改成功！");

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
      appBar: AppBar(title: Text('数据更新')),
      body: ListView(
        children: [
          SizedBox(height: 16.0),

          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: updateData,
            child: Text('更新数据'),
          ),
          SizedBox(height: 16.0),
          Column(children: inputBoxes),
        ],
      ),
    );
  }
}
