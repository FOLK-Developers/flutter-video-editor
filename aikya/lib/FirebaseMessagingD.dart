import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingD extends StatefulWidget {
  FirebaseMessagingD() : super();
  final String title = 'Firebase Messaging Demo';

  @override
  _FirebaseMessagingDState createState() => _FirebaseMessagingDState();
}

class _FirebaseMessagingDState extends State<FirebaseMessagingD> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
    });
  }

  List<Message> _messages;

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
        _launchURL();
      },
    );

    // _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, badge: true, alert: true),
    // );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    String image = data['image'];
    String url = "https://www.aikyayouth.org/";
    // print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      Message msg = Message(
          title: title, body: body, message: mMessage, image: image, url: url);
      _messages.add(msg);
    });
  }

  @override
  void initState() {
    super.initState();
    _messages = List<Message>();
    _getToken();
    _configureFirebaseListeners();
  }

  _launchURL() async {
    const url = 'https://www.aikyayouth.org/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: null == _messages ? 0 : _messages.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        _messages[index].message,
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_messages[index].image),
                    radius: 20.0,
                  ),
                ],
              ),
              // Align(
              //   child: RaisedButton(
              //     onPressed: _launchURL,
              //     child: Text('Show Flutter homepage'),
              //   ),
              //   alignment: Alignment.bottomRight,
              // ),
            ],
          );
        },
      ),
    );
  }
}

class Message {
  String title;
  String body;
  String message;
  String image;
  String url;
  Message({this.title, this.body, this.message, this.image, this.url}) {
    // this.title = title;
    // this.body = body;
    // this.message = message;
    // this.image = image;
    // this.url=url;
  }
}
