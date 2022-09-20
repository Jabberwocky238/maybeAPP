
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'DatabaseToolClass.dart';
import 'EventBus.dart';
import 'MemoInfo.dart';
import 'myHome.dart';

List<MemoInfo>memoInfoList = [];

class MemoMenu extends StatefulWidget {
  const MemoMenu({Key? key}) : super(key: key);
  @override
  State<MemoMenu> createState() => _MemoMenuState();
}

class _MemoMenuState extends State<MemoMenu> {

  var bus = eventBus;

  _readMemo()async{
     memoInfoList = await DBT.readAsColomn();
     print("readMemo");
  }

  _createMemo() async {
    var memoClass = await DBT.insertMemo(MemoClass());
    MemoInfo memoInfo = MemoInfo(
      key: ValueKey(memoClass.id),
      thisMemo: memoClass,
    );
    setState(() {
      memoInfoList.add(memoInfo);
      print("_createMemo");
    });
  }

  @override
  Widget build(BuildContext context) {

    _readMemo();

    bus.on<Refresh>().listen((event) {
      _readMemo();
      setState(() {
        print("listen");
      });
    });

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.blue,
      strokeWidth: 4.0,
      onRefresh: ()async{
        bus.fire(Refresh());
        return Future.delayed(const Duration(milliseconds: 400));
      },
      child: Scrollbar(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ListView(
              children: memoInfoList,
            ),
            Positioned(
                bottom: 40,
                right: 40,
                child: FloatingActionButton(
                    onPressed: _createMemo,
                    child: const Icon(Icons.add)
                )
            )
          ],
        ),
      ),
    );
  }
}





