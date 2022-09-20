
import 'package:flutter/material.dart';
import 'MemoMenu.dart';
import 'DatabaseToolClass.dart';
import 'MemoPage.dart';
import 'myHome.dart';

class MemoInfo extends StatelessWidget {
  MemoInfo({Key? key,
    required this.thisMemo,
  }) : super(key: key);

  final MemoClass thisMemo;

  deleteMemo(MemoClass memo){
    memoInfoList.removeWhere((element) => memo.id == element.thisMemo.id);
    DBT.deleteMemo(memo.id);
    print("deleteMemo");
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red,),
      confirmDismiss: (dir)async{
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context){
              return AlertDialog(
                  title: Text("删除？"),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                          deleteMemo(thisMemo);
                          print("_deleteMmeo");
                        },
                        child: Text("YES")
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                        child: Text("NO")
                    ),
                  ]
              );
            }
        );
      },
      key: key!,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return MemoPage(
                  key: key!,
                  thisMemo: thisMemo,
                );
              }));
        },
        child: ListTile(
          title: Text(thisMemo.title),
          subtitle: Text(thisMemo.context, maxLines: 1),
        ),
      ),
    );
  }
}
