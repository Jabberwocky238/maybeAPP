
import 'package:flutter/cupertino.dart';

import 'DatabaseToolClass.dart';
import 'MemoInfo.dart';
import 'myHome.dart';

class RealInheritWidget extends InheritedWidget{
  const RealInheritWidget({
    Key? key,
    required Widget child,
    required this.data,
  }):super(key: key,child: child);

  final _ShareMemoListState data;

  @override
  bool updateShouldNotify(RealInheritWidget oldWidget){
    return true;
  }

}


class ShareMemoList extends StatefulWidget {
  ShareMemoList({
    Key? key,
    required this.memoInfoList,
    required this.child
  }) : super(key: key);

  late List<MemoInfo> memoInfoList;
  final Widget child;

  @override
  State<ShareMemoList> createState() => _ShareMemoListState();

  static _ShareMemoListState of(BuildContext context){
    RealInheritWidget inheritConfig = context.dependOnInheritedWidgetOfExactType<RealInheritWidget>()!;
    return inheritConfig.data;
  }
}


class _ShareMemoListState extends State<ShareMemoList> {

  deleteMemo(MemoClass memo){
    setState(() {
      widget.memoInfoList.removeWhere((element) => memo.id == element.thisMemo.id);
      DBT.deleteMemo(memo.id);
      print("deleteMemo");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RealInheritWidget(
        data: this,
        child: widget.child,
    );
  }
}
