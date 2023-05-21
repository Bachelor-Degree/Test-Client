
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:clients/WSFunction.dart'; 
import 'package:clients/pages/UserRoute.dart';
import 'package:dio/dio.dart';

class LoginRoute extends StatefulWidget 
{
  LoginRoute({
    Key? key, 
    this.Port="8888", 
    this.Host="http://localhost", 
  }); //, required this.HOST,});

  final String Host; 
  final String Port; 
  static String tag = 'login-page';

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  String Data = ''; 
  var LIL = [];
  //Map LoginInfo = {"ac":'', "ID":'', "PW":""}; 
  Map<String,dynamic> LoginInfo = {"Table":"client", "ID":-1, "Name":"null"}; 
  String LoginJSON = '';
  bool _isLoading = false;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), onPressed: (){},  ), 
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.black, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: Image.network(
              //"https://cdn.pixabay.com/photo/2016/11/29/05/45/astronomy-1867616_960_720.jpg",
              //"https://cdn.pixabay.com/photo/2014/03/25/16/32/user-297330_960_720.png",
              "https://cdn.pixabay.com/photo/2016/11/08/15/21/user-1808597_960_720.png",
              width: 200,
              height: 200,
            ),
          ),
          TextFormField(
            onChanged: (value) 
            { 
              //LoginInfo["Table"] = value.toString(); 
              if( "0" == value.toString() ) LoginInfo["Table"] = "global_admin"; 
              //if( "1" == value.toString() ) LoginInfo["Table"] = "client"; 
              if( "2" == value.toString() ) LoginInfo["Table"] = "mechanic"; 
              if( "3" == value.toString() ) LoginInfo["Table"] = "warehouse_keeper"; 
            },
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Account", 
              //hintText: "管理员为0，客户为1，维修员为2，仓管员为3",
              hintText: "管理员为0，维修员为2，仓管员为3",
              prefix: Icon(Icons.account_circle)
              ),
          ),

          TextField(
            //onChanged:(value) => { print(value),} ,//accountID=value, }, 低效，但有效 
            onChanged: (value) 
            { 
              LoginInfo["ID"] = value.toString();
            },
            autofocus: true,
            decoration: const InputDecoration(  
              labelText: "ID", 
              hintText: "Input here", 
              prefix: Icon(Icons.person)
            ),
          ),
          TextField(
            onChanged: (value) { 
              // 加密部分，请暂时取消，便于测试 
              //var byte = utf8.encode(value);
              //var byte2= sha256.convert(byte);
              //LoginInfo['PW'] = byte2;// sha256.convert(byte);
              LoginInfo['PW'] = value;// sha256.convert(byte);
            },
            autofocus: true,
            decoration: const InputDecoration(  
              labelText: "Password", 
              hintText: "Input here", 
              prefix: Icon(Icons.lock)
            ),
            obscureText: true,
          ), 

          SizedBox(height: 24.0,),
          ElevatedButton(
            child: const Text("登录"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(256, 60),
            ),
            onPressed: () async
            { 
              try{
                Dio dio = Dio(); 
                Response resp = await dio.post(
                  'http://localhost:8888/login',
                  data: jsonEncode({
                    "Table": LoginInfo["Table"] ,
                    "ID": LoginInfo["ID"], 
                    "Password": LoginInfo["PW"], 
                  }
                ));
                Map<String, dynamic> info = jsonDecode(resp.toString());
                //Map info = jsonDecode(resp); 
                if(info["success"]) {
                  print(resp); 
                  if( "client" == LoginInfo["Table"] ) { info["Table"]=LoginInfo["Table"]; info["table"] = "客户"; info["t"] = "client"; };
                  if( "mechanic" == LoginInfo["Table"] ) { info["Table"]=LoginInfo["Table"]; info["table"] = "维修员"; info["t"] = "mechanic"; }; 
                  if( "warehouse_keeper" == LoginInfo["Table"] ) { info["Table"]=LoginInfo["Table"]; info["table"] = "仓管员"; info["t"] = "warehouse_keeper"; }; 

                  if( "global_admin" == LoginInfo["Table"] ) { info["Table"]=LoginInfo["Table"]; info["table"] = "管理员"; };
                  //if( "shop_admin" == LoginInfo["Table"] ) { info["T"]=LoginInfo["Table"]; info["Table"] = info["ShopID"].toString() + "号门店管理员"; };
                  Navigator.of(context).pop(info);
                  //Navigator.of(context).pop(LoginInfo);
                };
              }
              catch(e)
              {
                print(e);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('提示'),
                    content: Text(e.toString()),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          },
                      ),
                    ],
                  ),
                );
              };
           },
          ),
          SizedBox(height: 24.0,),
          /*
          ElevatedButton(
            child: const Text("注册"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(256, 60),
            ),
            onPressed: (){ 
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) {
                  return RegisterPage();//channel:channel);
                }),
              );
            },
          ),
          */
          SizedBox(height: 24.0,),
          ElevatedButton(
            child: const Text("Test"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(256, 60),
            ),
            onPressed: ()
            {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) { return UserRoute(UserInfo: LoginInfo ,);}),
                  //builder: (context) { return UserRoute(LoginInfo: ["管理员","张三","PW"],);}),
                  //builder: (context) { return WebSocketRoute();}),
              );
            },
          ),
          SizedBox(height: 24.0,),
          /*
          ElevatedButton(
            child: const Text("TestReturn"),
            onPressed: ()
            {
              Navigator.pop(context);
            }
          ),*/
          /*
          */
        ],
      ) ,
    );
  }

}


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  static String tag = 'register-page';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 用户注册信息
  var _regInfo = {"Table":"", "Phone": "", "Password":"" ,};
  var _regList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          title: const Text(
            'Register',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
      */
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
    child: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: const Text(
        '注册',
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    ),
  ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 160.0,
            child: Stack(
              children: [
                Positioned(
                  top: 16.0,
                  left: 60.0,
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                        'https://picsum.photos/id/1005/200/200'),
                  ),
                ),
                // 更新按钮
                Positioned(
                  top: 16.0,
                  right: 60.0,
                  child: IconButton(
                    onPressed: () {},
                    iconSize: 40.0,
                    icon: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          // 用户名
          TextFormField(
            enabled: false,
            decoration: const InputDecoration(
              labelText: "Customer",
              prefix: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
            ),
          ),
          // 手机号输入
          TextField(
            onChanged: (value) {
              _regInfo["Phone"] = value;
            },
            style: const TextStyle(fontSize: 16.0),
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Phone",
              hintText: "Input here",
              prefix: Icon(Icons.person, color: Colors.grey),
            ),
          ),
          // 密码输入
          TextField(
            onChanged: (value) {
              //var byte = utf8.encode(value);
              //_regInfo['PW'] = sha256.convert(byte); 
              _regInfo["Password"] = value.toString(); 
            },
            style: const TextStyle(fontSize: 16.0),
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Input here",
              prefix: Icon(Icons.lock, color: Colors.grey),
            ),
            obscureText: true,
          ),
          SizedBox(height: 24.0,),
          ElevatedButton(
            child: const Text("Test"),
            style: ElevatedButton.styleFrom(
              //minimumSize: Size(520, 100),
              minimumSize: Size(256, 60),
            ),
            onPressed: ()
            {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  //builder: (context) { return UserRoute(LoginInfo: ["管理员","张三","PW"],);}),
                  builder: (context) { return UserRoute(UserInfo: _regInfo ,);}),
                  //builder: (context) { return WebSocketRoute();}),
              );
            },
          ),
          SizedBox(
            height: 24.0,
          ),

          ElevatedButton(
          //CupertinoButton.filled(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(256, 60),
              //minimumSize: Size(520, 100),
              //minimumSize: Size(120, 100),
              //maximumSize: Size(120, 200),
            ),
            child: const Text(
              "注册",
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: () {
              _regList.clear();
              _regList.add("Register");
              _regList.add(_regInfo["ID"]);
              _regList.add(_regInfo["PW"]);

              print(_regInfo);
            },
          ),
        ],
      ),
    );
  }
}

/*
              LIL.clear();
              LIL.add("Login");
              LIL.add(LoginInfo["ac"]);
              LIL.add(LoginInfo["ID"]);
              LIL.add(LoginInfo["PW"]);
              //print(LoginJSON);
              //print(LIL); 
              String resp = await postHttp(LoginInfo); 
              //postHttp(LoginInfo, PATH: "login").then( (value) => resp = value); 
              print(resp); 
              Map info = jsonDecode(resp); 
              if(info["success"]) {
                print(resp); 
              };
 
*/
