import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_app_gps/qrscan.dart';
import 'package:flutter_app_gps/tool/httputil.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location _location;
  var lon;
  var lat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("小车"),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("注册成为小车"),
          shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(40)
          ),
          onPressed: ()async{
//            获取手机设备信息
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        var phoneInfo = androidInfo.androidId;
        print('Running on ${androidInfo.androidId}');
        if (await requestPermission()) {
          final location = await AmapLocation.fetchLocation(mode: LocationAccuracy.High);
//              setState(() => _location = location);
          setState((){
            _location = location;

          });
          lon =await _location.latLng.then((it) => it.longitude);
          lat =await _location.latLng.then((it) => it.latitude);
          print("lon=$lon");
          print("lat=$lat");
        }
        HttpUtil htp = new HttpUtil(header: headers);
        var re=await htp.post("/car",queryParameters: {"number":phoneInfo,"longitude":lon,"dimensionality":lat});
        if(re == 'error'){
          showDialog<Null>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text(
                    '请求错误',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('服务器地址找不到'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }).then((val) {
            print(val);
          });
        }else{
          var result = jsonDecode(re);
          String url = result["data"];
//            print(result);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return QrscanPage(url,phoneInfo);
          }));
        }
          },
        ),
      ),
    );
  }
}
Future<bool> requestPermission() async {
  final permissions =
  await PermissionHandler().requestPermissions([PermissionGroup.location]);

  if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
    return true;
  } else {
    print('需要定位权限!');
    return false;
  }
}