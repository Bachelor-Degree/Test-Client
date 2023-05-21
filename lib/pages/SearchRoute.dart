
import 'dart:convert';
import 'package:clients/pages/DicTable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchRoute extends StatefulWidget {
  @override
  final String Host; 
  final String Port; 
 
  final String Table;
  final String title;
  late List tInfoList; 

  SearchRoute({
    Key? key, 
    this.title = '搜索模块', 
    required this.tInfoList,
    required this.Table, 
    required this.Host, 
    required this.Port, 
    }) : super(key: key);


  _SearchRouteState createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  List<Widget> inputBoxes = [];
  Map<String, String> data = {};
  //String table='';

  void initState()
  {
    //getTableInfo();
    setState(() {
      print(widget.tInfoList);
      //tInfoList.remove("ID");
      addInputBoxList(widget.tInfoList);
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
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        );
      }
    });
  }

  void searchData() async {
    data = { "Table": widget.Table }; 
    for (var i = 0; i < inputBoxes.length; i += 1) {
      if (inputBoxes[i] is Column) {
        Column tmp = inputBoxes[i] as Column;
        TextField valueField = tmp.children[0] as TextField;
        print(valueField.controller?.text);
        if (valueField.controller!.text.isNotEmpty){
          data[ widget.tInfoList[i] ] = valueField.controller!.text;
        }
      }
    }
    print(data);
    try{
      Dio dio = Dio();
      Response response = await dio.post(
        "${widget.Host}:${widget.Port}/search",
        data: jsonEncode(data),
        //options: Options(responseType: ResponseType.plain)
      );
      int len = response.data.length; 
      List<Map<String, dynamic>> info = [];
      print(len);
      if( len > 1 ) 
      {
        print( len.toString() );// + response.data );
        for (var i = 0; i < len; i++ )
        {
          //print( response.data.runtimeType );
          //Map<String, dynamic> tmp = response.data;
          Map<String, dynamic> tmp = response.data[i];
          info.add( tmp );
        }
      }
      else 
      {
        //List<Map<String, dynamic>> info = [];
        //for (var i = 0; i < len; i++ )
        {
          print( response.data.runtimeType );
          //Map<String, dynamic> tmp = jsonDecode( response.data[0].toString() );
          //Map<String, dynamic> tmp = jsonDecode(response.data); //[0];
          Map<String, dynamic> tmp = jsonDecode(jsonEncode(response.data[0]));
          print(tmp);
          info.add( tmp );
        }
      }
      print("搜索结果："); 
      print(info);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DicTable( title: "${widget.title}搜索成功！", dicList: info, Table: widget.Table,)
        )
      );
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

/*
  void getOrderInfo() async {
    widget.OrderList.remove("EndDate"); 
    widget.OrderList.remove("StartDate"); 

 
    if( "client" == widget.UserInfo["t"] ) { 
      data["ClientID"] = widget.UserInfo["ID"].toString(); 
      widget.OrderList.remove("ClientID"); 
    } ;
    if( "mechanic" == widget.UserInfo["t"] ) { data["MechanicID"] = widget.UserInfo["ID"].toString(); widget.OrderList.remove("MechanicID"); } ;
    addInputBoxList(widget.OrderList);
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: [
          SizedBox(height: 16.0),
          /*
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '更新数据',
              //labelText: '更新数据表',
            ),
            onChanged: (value) {
              //if (int.tryParse(value) != null) 
              {
                //addInputBox(int.parse(value)); 
                Table = value; 
                if( "客户" == value) { table=value;  Table="client"; };
                if( "订单" == value) { table=value;  Table="repair_record";}; 
              }
            },),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: getOrderInfo,
            child: Text('输入查询信息'),
          ),
          */
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: searchData,
            child: Text('开始查询！'),
          ),
          SizedBox(height: 16.0),
          Column(children: inputBoxes),
        ],
      ),
    );
  }
}

