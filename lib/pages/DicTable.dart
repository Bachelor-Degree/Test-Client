
//import 'dart:ui';

import 'package:clients/pages/UpdateInfoPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void _defaultAction() {
    print('默认的左侧按钮动作');
}

class DicTable extends StatefulWidget {

  List<Map<String, dynamic>> dicList = [];
  String title = "数据查询";
  final String Host; 
  final String Port; 
  final String Table; 
  final bool isDisplayButton;

  DicTable({
    Key? key, 
    required this.Table, 
    this.Host="http://localhost", 
    this.Port="8888", 
    this.dicList = const [], 
    this.title = '历史数据查询',
    this.isDisplayButton = false, 
    }) : super(key: key);

  @override
  _DicTableState createState() => _DicTableState(); 
}

class _DicTableState extends State<DicTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.title ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: DicTableBody(dicList: widget.dicList, context: context, Table: widget.Table, isDisplayButton: widget.isDisplayButton, Host: widget.Host, Port: widget.Port,),
      ),
    );
  }
}


class DicTableBody extends StatelessWidget {
  final List<Map<String, dynamic>> dicList;
  final String Table;
  final Function leftButtonAction;
  final Function rightButtonAction;
  final BuildContext _context;
  final bool isDisplayButton;
  final String Host; 
  final String Port; 

  DicTableBody({
    required this.dicList,
    required this.Table,
    required BuildContext context,
    this.Host="http://localhost", 
    this.Port="8888", 
    this.leftButtonAction = _defaultAction,
    this.rightButtonAction = _defaultAction,
    //this.isDisplayButton = false, // 默认不显示按钮
    this.isDisplayButton = true, 
  }) : _context = context;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _getColumns(),
        rows: _getRows(),
      ),
    );
  }


  List<DataColumn> _getColumns() {
    List<DataColumn> columns = [];
    if (dicList.isNotEmpty) {
      // 最左侧添加“修改”按钮
      if (isDisplayButton) { // 判断是否显示按钮
        columns.add(
          DataColumn(
            label: ElevatedButton(
              onPressed: () {
                leftButtonAction();
              },
              child: Text('修改'),
            ),
          ),
        );
      }
      // 中间添加每个属性的列
      dicList.first.keys.forEach((key) {
        columns.add(DataColumn(label: Text(key)));
      });
      // 最右侧添加“删除”按钮
      if (isDisplayButton) { // 判断是否显示按钮
        columns.add(
          DataColumn(
            label: ElevatedButton(
              onPressed: () {
                rightButtonAction();
              },
              child: Text('删除'),
            ),
          ),
        );
      }
    }
    return columns;
  }

List<DataRow> _getRows() {
  return dicList.map((dictionary) {
    List<DataCell> cells = [];
    // 最左侧添加当前行的“修改”按钮
    if (isDisplayButton) {
      cells.add(
        DataCell(
          ElevatedButton(
            onPressed: () {
              print('当前行数据：$dictionary');
              print('当前行数据：${dictionary["ID"]}');
              Navigator.push(
                  _context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return UpdateInfoPage(
                        WaitData: dictionary,
                        Table: Table,
                        Port: Port,
                        Host: Host,
                      );
                    }),
                  ));
            },
            child: Icon(Icons.edit),
          ),
        ),
      );
    }
    // 添加每一行的属性
    dictionary.entries.forEach((entry) {
      cells.add(DataCell(Text('${entry.value}')));
    });
    // 最右侧添加当前行的“删除”按钮
    if (isDisplayButton) {
      cells.add(
        DataCell(
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: _context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('确定删除当前数据吗？'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          // 执行删除操作
                          print('即将删除{$Table}数据：$dictionary');
                          // Delete Function 
                          Dio dio = Dio(); 
                          Response response = await dio.post(
                            //"http://localhost:8888/delete", 
                            "${Host}:${Port}/delete", 
                            data: { 
                              "ID": dictionary["ID"], 
                              "Table": Table,
                            } //dictionary["ID"],
                          ); 
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text("是的！我是说，是的！我确定！"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("我再考虑考虑"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.delete),
          ),
        ),
      );
    }
    return DataRow(cells: cells);
  }).toList();
}
}

