import 'dart:convert';

// import 'package:bubble/bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bot/BotResponseModel.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter&Python'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePage createState() => new _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  String BOT_URL="http://localhost:5005/webhooks/rest/webhook";

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }


  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Promise",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    displayResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Flutter and Dialogflow"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  void displayResponse(String text) async{
    _textController.clear();
    final http.Response response = await http.post(BOT_URL, body: jsonEncode(<String,String>{
      "sender":"test_user",
      "message" : text
    }),


        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    print(response.body);
    ChatMessage message = new ChatMessage(
      text: response.body.isEmpty ? "NO data":BotResponse.fromJson(jsonDecode(response.body)).response[0].text,
          // new Future<BotResponse>(response.getListMessage()[0]).title,
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
    // return BotResponse.fromJson(jsonDecode(response.body)).response;

    // if (response.statusCode == 201) {
    //   // If the server did return a 201 CREATED response,
    //   // then parse the JSON.
    //   return BotResponse.fromJson(jsonDecode(response.body));
    // } else {
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.
    //   throw Exception('Failed to load response');
    // }
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Text('B')),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
            child: new Text(
              this.name[0],
              style: new TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   Future<BotResponse> _futureBotResponse;
//
//
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey();
//   List<String> _data = [];
//   static const String BOT_URL = "http://localhost:5005/webhooks/rest/webhook";
//         TextEditingController _queryController = TextEditingController();
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orangeAccent.withOpacity(.7) ,
//         centerTitle: true,
//         title: Text("Flutter & Python"),
//       ),
//       backgroundColor: Colors.orangeAccent,
//       body: Stack(
//         children: <Widget>[
//           AnimatedList(
//             // key to call remove and insert from aanywhere
//               key: _listKey,
//               initialItemCount: _data.length,
//               itemBuilder: (BuildContext context, int index, Animation animation){
//                 return FutureBuilder<BotResponse> (
//                   future: _futureBotResponse,
//                   builder: (context,snapshot){
//
//                     if(snapshot.hasData){
//                       _insertSingleItem(snapshot.data.response.toString()+"<bot>");
//
//                       return _buildItem(_data[index], animation, index);
//                     }
//                     else if (snapshot.hasError) {
//                       return Text("${snapshot.error}");
//                     }
//                     return CircularProgressIndicator();
//
//                   },
//                 );
//
//               }
//           ),
//
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: ColorFiltered(
//                   colorFilter: ColorFilter.linearToSrgbGamma(),
//                   child: Container(
//                       color: Colors.white.withOpacity(.7),
//                       child: Padding(
//                           padding: EdgeInsets.only(left: 20, right: 20),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               icon: Icon(Icons.message, color: Colors.orange,),
//                               hintText: "Hello",
//                               fillColor: Colors.white12,
//                             ),
//                             controller: _queryController,
//                             textInputAction: TextInputAction.send,
//                             onSubmitted: (msg){
//                               this._insertSingleItem(_queryController.text);
//
//                               setState(() {
//
//                                 if (_queryController.text.length>0) {
//       _futureBotResponse = displayResponse(_queryController.text);
//
//     }
//                               });
//                                                       },
//
//                           )
//                       )
//                   )
//               )
//           )
//         ],
//       )
//       ,
//     );
//   }






  // void _insertSingleItem(String message){
  //
  //   _data.add(message); //insert(_data.length-1, message);
  //   _listKey.currentState.insertItem(_data.length-1);
  // }
  // Widget _buildItem(String item, Animation animation,int index){
  //   bool mine = item.endsWith("<bot>");
  //   return SizeTransition(
  //       sizeFactor: animation,
  //       child: Padding(padding: EdgeInsets.only(top: 10),
  //         child: Container(
  //             alignment: mine ?  Alignment.topLeft : Alignment.topRight,
  //
  //             child : Bubble(
  //               child: Text(item.replaceAll("<bot>", "")),
  //               color: mine ? Colors.deepOrangeAccent : Colors.white,
  //               padding: BubbleEdges.all(10),
  //
  //
  //             )),
  //       )
  //
  //   );
  // }
// }