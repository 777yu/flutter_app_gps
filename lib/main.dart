import 'package:flutter/material.dart';
import 'package:flutter_app_gps/home.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
void main() async{
  runApp(MyApp());
//  WidgetsFlutterBinding.ensureInitialized();
//
//  await AmapCore.init('e9a2dcb1e238768697bd708bbb7488a1');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
