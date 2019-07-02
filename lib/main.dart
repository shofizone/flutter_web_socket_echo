import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  TextEditingController textEditingController = TextEditingController();
  List<String> list = ["hi", "hi", "hi"];

  WebSocketChannel channel;

  @override
  void initState() {
    channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
    channel.stream.listen((data){
      setState(() {
        list.add("Server: "+data);
      });
    });

    super.initState();
  }



  void _handelSend() {
    if (textEditingController.text.isNotEmpty) {
      channel.sink.add(textEditingController.text);
      textEditingController.text = "";
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            child:  ListView.builder(
                key: _animatedListKey,
                itemCount: list.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  return _myListItem(index);
                }),
          ),
          Container(
            height: 70.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type here",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _handelSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _myListItem(index) {
    bool isEven = index % 10 == 0;
    return Padding(
      padding: isEven
          ? EdgeInsets.only(left: 8, right: 80, top: 4, bottom: 4)
          : EdgeInsets.only(left: 80, right: 8, top: 4, bottom: 4),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: !isEven ? Colors.green : Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            list[index],
            style: TextStyle(color: Colors.white, fontSize: 18,),
            softWrap: true,
            textAlign: !isEven ?TextAlign.end:TextAlign.start,
          ),
        ),
      ),
    );
  }
}
