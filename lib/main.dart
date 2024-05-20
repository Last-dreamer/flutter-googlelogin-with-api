
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_login/profile.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'My App',
      home: HomeScreen(),
      navigatorObservers: [
        MyUrlNavigatorObserver(navigatorKey),
      ],
      routes: {
        // '/': (context)=> HomeScreen(),
        '/profile': (context) =>  const Profile(),
      },
    );
  }
}

class MyUrlNavigatorObserver extends NavigatorObserver {
  final GlobalKey<NavigatorState> navigatorKey;

  MyUrlNavigatorObserver(this.navigatorKey);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    handleIncomingLinks();
  }

  Future<void> handleIncomingLinks() async {
    log("testing logs initial logs");

    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleRedirectUrl(initialLink);
    }

    final sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleRedirectUrl(uri.toString());
      }
    });
  }

  void handleRedirectUrl(String url) async {

    final uri = Uri.parse(url);
    final accessToken = uri.queryParameters['state'];
    log("testing uri ${uri.path}:: ${uri}");
    // if (uri.path == '/getUserDetail' && accessToken != null) {
      if (uri.path == '/auth/google/callback' && accessToken != null) {
      // Navigate to the desired screen or page and pass the access token
      // navigatorKey.currentState?.pushReplacementNamed(
      //   '/profile',
      //   // arguments: {'email': accessToken},
      // );
      var res = await http.get(Uri.parse("http://192.168.1.115:8080/getUserDetail"));

      var body =  json.decode(res.body);
      log("testing data ${body}");
       // navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (index)=>   Profile(email: body["user"]["RawData"]["email"],)));
    }
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String>? credentials;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null) {
      setState(() {
        credentials = args;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = credentials?['accessToken'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(child: MaterialButton(onPressed: () async {

        const url = 'http://192.168.1.115:8080/auth/google?provider=google';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
     }, child: const Text("Sign In"),),)
    );
  }
}