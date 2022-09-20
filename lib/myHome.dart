
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'MemoInfo.dart';
import 'MemoMenu.dart';
import 'DatabaseToolClass.dart';
import 'MemoMenu.dart';

DBTool DBT = DBTool();

class myHome extends StatefulWidget {
  const myHome({Key? key}) : super(key: key);

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  int _counter = 0;
  bool _isInit = false;

  @override
  initState(){
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
    _isInit = true;
    return;
  }

  Future<File> _getLocalFile()async{
    String dirPath = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dirPath/counter.text");
    if(file.existsSync()){
      return file;
    }
    else{
      file.create(recursive: true);
      return file;
    }
  }

  Future<int>_readCounter()async{
    try{
      var file = await _getLocalFile();
      var counter = await file.readAsString();
      return int.parse(counter);
    }catch(e){
      print(e);
      return 0;
    }
  }

  _writeCounter()async{
    var file = await _getLocalFile();
    var ioSink = file.openWrite();
    ioSink.write("$_counter");
    await ioSink.flush();
    await ioSink.close();
  }


  String debugText = "NULL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("counter = $_counter"),
        actions: [
          IconButton(
            onPressed: (){
              if(!_isInit){
                initState();
              }
              setState((){
                _counter++;
              });
              _writeCounter();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                if(!_isInit){
                  initState();
                }
                setState((){
                  _counter=0;

                });
                _writeCounter();
              },
              icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: MemoMenu(),
    );
  }
}
