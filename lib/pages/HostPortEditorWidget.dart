
import 'package:flutter/material.dart';

Future<void> HostPortEditor(BuildContext context, void Function(String host, String port) onConfirm) async {
  String host = '';
  String port = '';

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('请输入Host和Port'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Host',
              ),
              onChanged: (value) {
                host = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Port',
              ),
              onChanged: (value) {
                port = value;
              },
            ),
          ],
        ),
        actions: [
          //FlatButton(
          ElevatedButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('确定'),
            onPressed: () {
              onConfirm(host, port);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("成功设置 $host:$port！"))
              );
            },
          ),
        ],
      );
    },
  );
}
