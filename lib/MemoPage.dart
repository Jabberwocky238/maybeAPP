import 'package:flutter/material.dart';
import 'DatabaseToolClass.dart';
import 'EventBus.dart';
import 'myHome.dart';

class MemoPage extends StatelessWidget {
  MemoPage({Key? key,required this.thisMemo}) : super(key: key);

  final MemoClass thisMemo;
  final TextEditingController controlTitle = TextEditingController();
  final TextEditingController controlText = TextEditingController();
  final FocusNode focusNodeTitle = FocusNode();
  final FocusNode focusNodeText = FocusNode();

  _readMemo(){
    controlTitle.text = thisMemo.title;
    controlText.text = thisMemo.context;
    print("_readMemo");
  }
  _writeMemo(String title,String context){
    thisMemo.title = title;
    thisMemo.context = context;
    DBT.updateMemo(thisMemo);
    print("_writeMemo");
  }

  @override
  Widget build(BuildContext context) {
    _readMemo();
    return Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("TEXT"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackButton(
                  onPressed: (){
                    eventBus.fire(Refresh());
                    Navigator.of(context).pop();
                    print("pop");
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: (){
                        print("checked?");
                        focusNodeText.unfocus();
                        focusNodeTitle.unfocus();
                        _writeMemo(controlTitle.text,controlText.text);
                        print("checked!");
                      },
                      icon: const Icon(Icons.check,size: 30,)
                  ),
                )
              ],
            ),
            body: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 80,
                      width: double.maxFinite,
                      child: TextField(
                        style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        focusNode: focusNodeTitle,
                        controller: controlTitle,
                      ),
                    ),
                    SingleChildScrollView(
                      child: TextField(
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none
                        ),
                        focusNode: focusNodeText,
                        controller: controlText,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
