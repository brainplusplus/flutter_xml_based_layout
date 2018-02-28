import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firstproject/common/globals.dart';
import 'package:firstproject/common/base_stateless_widget.dart';


class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => new _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  DateTime time = new DateTime.now();
  String timeStr = "";

  void _handleTapboxChanged(String val) {
    setState(() {
      time = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
      timeStr = formatter.format(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new TestWidget(
        timeStr: timeStr,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}


class TestWidget extends BaseStatelessWidget {

  @override
  final String layoutPath = "layouts/complex.xml";

  TestWidget({Key key, String timeStr, this.onChanged})
      : super(key: key){
    timeStr = timeStr == "" ?"Start state":timeStr;
    setProperty("timeStr", timeStr);
    setFunction("raisedButtonAction", raisedButtonAction);
  }


  final ValueChanged<String> onChanged;

  void raisedButtonAction() {
    onChanged("");
  }

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece of paper on which the UI appears.
    return super.buildWidget();
  }
}


void main() async {
  String dir = "";

  await GlobalLayoutXML.set("layouts/complex.xml");

  runApp(new MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: new ParentWidget(),
  ));
}