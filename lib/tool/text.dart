import 'dart:async';

import 'package:web_socket_channel/io.dart';
void main(){
//  final channel = new IOWebSocketChannel.connect('ws://47.240.121.14/carSocket/123');
//  channel.sink.add("傻凋祁俣凡");
//  channel.stream.listen((aaa){
//    print(aaa);
//  });
//  channel.sink.close();
Timer countDownTimer;
  countDownTimer = new Timer.periodic(new Duration(seconds: 2), (t)async{
    var lon = 123.456;
    var lat = 156.594;
    var str = '{"type":"uploadLocal","longitude":$lon,"dimensionality":$lat}';
    print(str);
  });
}

//class _MyHomePageState extends State<MyHomePage> {
//  Timer countDownTimer;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//          child: Text("123")),
//      floatingActionButton: FloatingActionButton(
//        onPressed: ()async{
//          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
////          print("print('Running on ${androidInfo.model}');");
//          print('Running on ${androidInfo.model}');
//          print('Running on ${androidInfo.version}');
//          print('Running on ${androidInfo.board}');
//          print('Running on ${androidInfo.bootloader}');
//          print('Running on ${androidInfo.brand}');
//          print('Running on ${androidInfo.device}');
//          print('Running on ${androidInfo.display}');
//          print('Running on ${androidInfo.fingerprint}');
//          print('Running on ${androidInfo.hardware}');
//          print('Running on ${androidInfo.host}');
//          print('Running on ${androidInfo.id}');
//          print('Running on ${androidInfo.manufacturer}');
//          print('Running on ${androidInfo.androidId}');
//        },
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}