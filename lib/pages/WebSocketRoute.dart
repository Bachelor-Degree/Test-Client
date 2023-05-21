
import 'package:clients/main.dart';
//import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';


class WebSocketRoute extends StatefulWidget 
{
  const WebSocketRoute({super.key});

  @override
  State<WebSocketRoute> createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> 
{
  //TextEditingController _controller = TextEditingController(); 
  late WebSocketChannel channel = WebSocketChannel.connect( Uri.parse('ws://localhost:1234')); 
  String ntext = '' ; 

/*
  @override
  void ininState()
  {
    channel = WebSocketChannel.connect('127.0.0.1');
  }
  */

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                onChanged: (newValue) {
                  ntext = newValue; 
                },
                decoration: InputDecoration(labelText: "Send Message"),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) 
              {
                if (snapshot.hasError)
                {
                  ntext = "Connection Error"; 
                }
                else if (snapshot.hasData)
                {
                  ntext = "echo:\n" + snapshot.data; 
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0,),
                  child: Text(ntext),
                );
              },
            ),
            ElevatedButton(onPressed: (){}, child: Text('Test'),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_sendMessage(ntext);} , //_sendMessage(ntext), 
        tooltip: 'Send Message',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _sendMessage(String data)
  {
    //if(_controller.text.isNotEmpty)
    //if(ntext != null)
    {
      channel.sink.add(data); 
      //channel.sink.add(_controller.text); 
    }
  }

  @override 
  void dispose()
  {
    channel.sink.close();
    super.dispose();
  }
}
