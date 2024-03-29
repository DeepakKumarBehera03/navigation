import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navigation/location_screen.dart';
import 'package:navigation/navigation_first.dart';
import 'package:navigation/navigation_second.dart';
import 'navigation_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigationSecond(),
    );
  }
}

class FuturePage extends StatefulWidget {
  @override
  _FuturePageState createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  late String result;
  late Completer completer;
  Future getNumber() {
    completer = Completer<int>();
    calculate();
    return completer.future;
  }

  calculate() async {
    await Future.delayed(const Duration(seconds: 5));
    completer.complete(42);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back from the Future'),
      ),
      body: Center(
        child: Column(children: [
          Spacer(),
          ElevatedButton(
            child: Text('GO!'),
            onPressed: () {
              returnError()
                  .then((value){
                setState(() {
                  result = 'Success';
                });
              }).catchError((onError){
                setState(() {
                  result = onError;
                });
              }).whenComplete(() => print('Complete'));
            },
          ),
          Spacer(),
          Text(result.toString()),
          Spacer(),
          CircularProgressIndicator(),
          Spacer(),
        ]),
      ),
    );
  }

  Future<int> returnOneAsync() async {
    await Future<int>.delayed(const Duration(seconds: 3));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future<int>.delayed(const Duration(seconds: 3));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future<int>.delayed(const Duration(seconds: 3));
    return 3;
  }

  Future count() async {
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }

  void returnFG() {
    FutureGroup<int> futureGroup = FutureGroup<int>();
    futureGroup.add(returnOneAsync());
    futureGroup.add(returnTwoAsync());
    futureGroup.add(returnThreeAsync());
    futureGroup.close();
    futureGroup.future.then((List <int> value) {
      int total = 0;
      value.forEach((element) {
        total += element;
      });
      setState(() {
        result = total.toString();
      });
    });
  }

  Future returnError() {
    throw ('Something terrible happened!');
  }

  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

}