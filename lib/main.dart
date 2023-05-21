
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'pages/UserRoute.dart';
import 'pages/DetailScreen.dart';
import 'package:clients/pages/DicTable.dart';
import 'package:clients/pages/LoginRoute.dart';
import 'package:clients/pages/SearchRoute.dart';
import 'package:clients/pages/HostPortEditorWidget.dart';

//import 'package:clients/pages/Update.dart';
//import 'package:clients/pages/UpdateRoute.dart';
//import 'package:clients/pages/InsertRoute.dart';
//import 'package:clients/pages/InsertOrderRoute.dart';
//import 'package:clients/pages/FormPage.dart';

import 'package:clients/pages/ManageRoute.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key, 
    this.Host="http://localhost", 
    this.Port="8888", 
    required this.title
    }) : super(key: key);

  final String title;
  String Host; 
  String Port; 

  final Map<String, dynamic> info = {};
  Map<String, dynamic> UserInfo = {"Table": "null", "ID": -1, "Name": "Guest", "t": "游客",};

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<dynamic> _products = [];

  Future<void> fetchProducts() async {
    try {
      final Dio dio = Dio();
      final Response<dynamic> response =
          await dio.get('${widget.Host}:${widget.Port}/service');
      setState(() {
        _products = jsonDecode(jsonEncode(response.data)) as List<dynamic>;
      });
    } catch (e) {
      print(e);
    }
  }

  void _navigateToDetails(BuildContext context, dynamic detail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(detail: detail),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  var UserName = const Text( 
    "游客", 
    //widget.UserInfo["Name"],
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );

  void showAlert(BuildContext context, String message, {String title="提示"})
  {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }), 
              child: Text("我理解~~~"))
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                leading: const Icon(Icons.tab),
                title: Text(_products[index]['Name'] as String),
                subtitle: Text(_products[index]['Description'] as String),
                trailing: Text('\$${_products[index]['Price']}'),
                onTap: (() {
                  _navigateToDetails(context, _products[index]);
                })),
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      drawer: //MyDrawer(UserInfo: widget.UserInfo,),
          Drawer(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ClipOval(
                        child: Image.network(
                          "https://cdn3.iconfinder.com/data/icons/logos-brands-in-colors/512/pornhub-512.png",
                          //"https://www.iconfinder.com/icons/7150904/download/svg/4096",
                          width: 80,
                        ),
                      ),
                    ), 
                    UserName,
                    /*
                    Text(
                      widget.UserInfo["Name"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    */
                    //
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.person),
                      title: Text("我的主页"),
                      onTap: () {
                        if ("Guest" == widget.UserInfo["Name"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginRoute(Host: widget.Host, Port: widget.Port,);
                          })).then((value) { 
                            widget.UserInfo=value; 
                            setState(() {
                              UserName = Text(
                                "${widget.UserInfo["table"]}-${widget.UserInfo["Name"]}", 
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            });
                          } );
                        }
                        else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserRoute(UserInfo: widget.UserInfo,);
                          })); //.then((value) => widget.UserInfo); 
                        };
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("我的账户"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == widget.UserInfo["Name"]) {
                        if (true) {
                          print(widget.UserInfo);
                          print("OK");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                // This just a Test!
                                return DicTable(title: "我的账户信息", dicList: [widget.UserInfo], Table: "client", Host: widget.Host, Port: widget.Port, );
                            //return DicTable(title: "历史维修数据", dicList: i);
                          }));
                        }
                        ;
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("统计数据"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == UserInfo["Name"]) {
                        if (true) {
                          var info = [{'ID': 1, 'CarMake': 'Audi', 'CarModel': 'A4', 'CarYear': 2018, 'CarVIN': 'WBAZN33454P132347', 'StartDate': '2021-01-01 08:30:00', 'EndDate': '2021-01-02 16:30:00', 'TotalCost': 2500, 'MechanicID': 1, 'RepairID': 5, 'ClientID': 1}, {'ID': 2, 'CarMake': 'BMW', 'CarModel': '335i', 'CarYear': 2015, 'CarVIN': 'WBAPH73443E299558', 'StartDate': '2021-01-02 09:00:00', 'EndDate': '2021-01-03 17:30:00', 'TotalCost': 3500, 'MechanicID': 3, 'RepairID': 4, 'ClientID': 3}, {'ID': 3, 'CarMake': 'Mercedes', 'CarModel': 'E350', 'CarYear': 2017, 'CarVIN': 'WBALM7C51BE899832', 'StartDate': '2021-01-03 10:00:00', 'EndDate': '2021-01-04 15:30:00', 'TotalCost': 1800, 'MechanicID': 2, 'RepairID': 2, 'ClientID': 2}, {'ID': 4, 'CarMake': 'Toyota', 'CarModel': 'Camry', 'CarYear': 2014, 'CarVIN': 'WDAVP8ET4FA043456', 'StartDate': '2021-01-04 11:00:00', 'EndDate': '2021-01-05 14:30:00', 'TotalCost': 1000, 'MechanicID': 4, 'RepairID': 1, 'ClientID': 4}, {'ID': 5, 'CarMake': 'Lexus', 'CarModel': 'NX300', 'CarYear': 2020, 'CarVIN': 'WBAAK4809CC431256', 'StartDate': '2021-01-05 08:30:00', 'EndDate': '2021-01-06 16:30:00', 'TotalCost': 6000, 'MechanicID': 5, 'RepairID': 3, 'ClientID': 5}, {'ID': 6, 'CarMake': 'Audi', 'CarModel': 'A4', 'CarYear': 2018, 'CarVIN': 'WBAZN33454P132347', 'StartDate': '2021-01-01 08:30:00', 'EndDate': '2021-01-02 16:30:00', 'TotalCost': 2500, 'MechanicID': 1, 'RepairID': 5, 'ClientID': 1}, {'ID': 7, 'CarMake': 'BMW', 'CarModel': '335i', 'CarYear': 2015, 'CarVIN': 'WBAPH73443E299558', 'StartDate': '2021-01-02 09:00:00', 'EndDate': '2021-01-03 17:30:00', 'TotalCost': 3500, 'MechanicID': 3, 'RepairID': 4, 'ClientID': 3}, {'ID': 8, 'CarMake': 'Mercedes', 'CarModel': 'E350', 'CarYear': 2017, 'CarVIN': 'WBALM7C51BE899832', 'StartDate': '2021-01-03 10:00:00', 'EndDate': '2021-01-04 15:30:00', 'TotalCost': 1800, 'MechanicID': 2, 'RepairID': 2, 'ClientID': 2}, {'ID': 9, 'CarMake': 'Toyota', 'CarModel': 'Camry', 'CarYear': 2014, 'CarVIN': 'WDAVP8ET4FA043456', 'StartDate': '2021-01-04 11:00:00', 'EndDate': '2021-01-05 14:30:00', 'TotalCost': 1000, 'MechanicID': 4, 'RepairID': 1, 'ClientID': 4}, {'ID': 10, 'CarMake': 'Lexus', 'CarModel': 'NX300', 'CarYear': 2020, 'CarVIN': 'WBAAK4809CC431256', 'StartDate': '2021-01-05 08:30:00', 'EndDate': '2021-01-06 16:30:00', 'TotalCost': 6000, 'MechanicID': 5, 'RepairID': 3, 'ClientID': 5}];
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DicTable(title: "历史维修数据", dicList: info, Table: "repair_record", Host: widget.Host, Port: widget.Port,);
                            //return DicTable(title: "历史维修数据", dicList: i);
                          }));
                        };
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("订单管理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        if( "mechanic" == widget.UserInfo["Table"] || "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "订单", Table: "repair_record", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else 
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),

                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("配件表管理"),
                      onTap: () {
                        //if (true) {
                        if( "warehouse_keeper" == widget.UserInfo["Table"] || "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "配件表", Table: "partID", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("配件管理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        if( "warehouse_keeper" == widget.UserInfo["Table"] || "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "配件", Table: "part", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("客户管理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "mechanic" == widget.UserInfo["Table"] || "global_admin" == widget.UserInfo["Table"]) {
                        if( "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "客户", Table: "client", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("维修员管理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == UserInfo["Name"]) {
                        if( "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "维修员", Table: "mechanic", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("仓管员管理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == UserInfo["Name"]) {
                        //if (true) {
                        if( "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "仓管员", Table: "warehouse_keeper", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("门店管理"),
                      onTap: () {
                        if( "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "门店", Table: "shop", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                   ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text("管理员设置"),
                      onTap: () {
                        //if (true) {
                        if( "global_admin" == widget.UserInfo["Table"]) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ManageRoute(title: "管理员", Table: "global_admin", Host: widget.Host, Port: widget.Port,); 
                          }));
                        }
                        else
                        {
                          showAlert(context, "你没有权限进行本操作");
                        }
                      }),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("网络设置"),
                      onTap: () {
                        if (true) {
                          HostPortEditor(
                            context, 
                            (host, port) { 
                              print('Host: $host, Port: $port'); 
                              setState(() {
                                widget.Host = host; 
                                widget.Port = port; 
                              });
                            } );
                        //if( "global_admin" == widget.UserInfo["Table"]) {
                          /*
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return HostPortEditor; //(initialHost: widget.Host, initialPort: widget.Port,) ;
                                //return HostPortInput(initialHost: widget.Host, initialPort: widget.Port,) ;
                          }));
                          */
                        }
                      }),
 
                      /*
                  ListTile(
                      leading: Icon(Icons.airplane_ticket),
                      title: Text("新增订单"),
                      onTap: () {
                        //if(info.isEmpty) {
                        if( "Guest" != widget.UserInfo["Name"]) {
                        //if (true) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return InsertOrderRoute(UserInfo: widget.UserInfo,); 
                            //return InsertRoute(); 
                            //return DicTable(title: "历史维修数据", dicList: i);
                          }));
                        }
                        else {
                          showDialog(
                            context: context, 
                            builder: (context) => AlertDialog(
                              title: Text("快去登录啦！",),
                              content: Text("你还没有登录呀！"),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('去开启大冒险吧'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    },
                                  )
                              ]
                            )
                          );
                        }
                        ;
                      }),
                  ListTile(
                      leading: Icon(Icons.upgrade),
                      title: Text("更新数据"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == UserInfo["Name"]) {
                        if (true) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UpdateRoute() ;
                            //return DicTable(title: "历史维修数据", dicList: [widget.UserInfo]);
                          }));
                        }
                        ;
                      }),
                    ListTile(
                      leading: Icon(Icons.upgrade),
                      title: Text("订单处理"),
                      onTap: () {
                        //if(info.isEmpty) {
                        //if( "Guest" == UserInfo["Name"]) {
                        if (true) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FormPage( formList: ["Hi" , "HIO"]) ;
                            //return DicTable(title: "历史维修数据", dicList: [widget.UserInfo]);
                          }));
                        }
                        ;
                      }),
                  ListTile(
                      leading: Icon(Icons.search),
                      title: Text("搜索查询"),
                      //onTap: () {},
                      onTap: () {
                        //if(info.isEmpty) {
                        if (true) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SearchRoute(UserInfo: widget.UserInfo,); 
                            //return SearchScreen();
                          }));
                        }
                        ;
                      }),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("历史记录"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("设置"),
                    onTap: () {},
                  ),
                  */
                ],
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchProducts();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'UserPage',
            backgroundColor: Colors.purple,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Implement page 1 logic here
    } else if (index == 1) {
      // Implement page 2 logic here
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return UserRoute(
            UserInfo: widget.UserInfo,
          );
        }),
      );
    }
  }
}
