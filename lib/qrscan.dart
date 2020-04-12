import 'package:flutter/material.dart';
import 'package:flutter_app_gps/tool/httputil.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'dart:convert';
class QrscanPage extends StatefulWidget {
  //
  String url;
  //手机的序列号
  String phoneInfo;

  QrscanPage(this.url, this.phoneInfo);

  @override
  _QrscanPageState createState() => _QrscanPageState();
}

class _QrscanPageState extends State<QrscanPage> {
  Timer countDownTimer;
  Location _location;
  var lo;
  var wo;
  @override
  String CarInfo = "车已锁";
  var style1 = TextStyle(fontSize: 24, color: Colors.red);
  var style2 = TextStyle(fontSize: 24, color: Colors.blue);
  var channel;

  void initState() {
    channel = new IOWebSocketChannel.connect(
        'ws://47.240.121.14/carSocket/' + widget.phoneInfo);
    channel.stream.listen((value) {
      setState(() {
        CarInfo = value;
      });
    });
    yzmGet();
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("快车"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
//              color: Colors.blue,
              child: Image.network(
                "http://" + widget.url,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              CarInfo,
              style: CarInfo == "车已锁" ? style1 : style2,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("锁车"),
              color:  CarInfo == "车已锁"?Colors.grey:Colors.blue,
              textColor: Colors.white,
              onPressed: CarInfo == "车已锁"?null:()async{
                HttpUtil htp = new HttpUtil(header: headers);
                var re =await htp.post("/car/endUserCar/"+widget.phoneInfo);
                var huancheresult = json.decode(re);
                var isSuccess = huancheresult["code"];
                print("isSucccess=$isSuccess");

//                var isSuccess ='0';
                if(isSuccess=='0'){
                    setState(() {
                      CarInfo="车已锁";
                    });
                }else{
                  showDialog<Null>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text(
                            '锁车失败',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: new SingleChildScrollView(
                            child: new ListBody(
                              children: <Widget>[
                                new Text('锁车失败，请重试'),
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
                }
              },
            )
          ],
        ),
      ),
    );
  }

  //向服务器发送，位置信息
  yzmGet() async {
    if (await requestPermission()) {
      await for (final location in AmapLocation.listenLocation(mode: LocationAccuracy.High,needAddress:false)) {
        setState(() => _location = location);
        lo = await _location.latLng.then((it) => it.longitude);
        wo = await _location.latLng.then((it) => it.latitude);
        var str =
            '{"type":"uploadLocal","longitude":"$lo","dimensionality":"$wo"}';
        channel.sink.add(str);
        print(str);
      }
    }
  }
}

//检查权限
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
