import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:firstproject/common/globals.dart';

abstract class BaseStatelessWidget extends StatelessWidget {

  BaseStatelessWidget({Key key})
      : super(key: key){
    mapProperty = new Map();
    mapFunction = new Map();
  }


  String layoutPath;
  xml.XmlDocument layoutDoc;

  void setLayoutPath(String layout){
    this.layoutPath = layout;
  }

  Map mapProperty = new Map();
  Map mapFunction = new Map();
  Object callProperty(String propertyName){
     return mapProperty["{{"+propertyName+"}}"]==null?propertyName:mapProperty["{{"+propertyName+"}}"];
  }
  void setProperty(String propertyName, Object value){
    mapProperty["{{"+propertyName+"}}"] = value;
  }

  void setFunction(String funcName,Function func){
    mapFunction[funcName] = func;
  }

  void callFunction(String funcName){
    print("CALL :"+funcName);
    print(mapFunction[funcName]);
    (mapFunction[funcName] as Function)();
  }

  String callPropertyText(String text){
    void iterateMapEntry(key, value) {
      if(value is String){
        print('$key:$value');
        text = text.replaceAll(key, value);
      }
    }
    mapProperty.forEach(iterateMapEntry);
    return text;
  }

  Widget buildWidget(){
    print("LAYOUT NAME:"+layoutPath);
    return constructFromXML(GlobalLayoutXML.get(layoutPath));
  }

  Widget constructFromXML(xml.XmlDocument doc){

    Widget widget;
    Iterable<xml.XmlElement> rootNodes =  doc.children.where((node) => node is xml.XmlElement).map((node) => node as xml.XmlElement);
    xml.XmlElement rootElement = rootNodes.elementAt(0);
    widget = createWidgetList([rootElement]);
    Iterable<xml.XmlElement> nodes =  rootElement.children.where((node) => node is xml.XmlElement).map((node) => node as xml.XmlElement);
    for(xml.XmlElement node in nodes){
      print(node.name);
      if(node.nodeType==xml.XmlNodeType.TEXT){
        xml.XmlElement xmlText = node;
        print(xmlText.name);
      }
    }
    return widget;
  }
  Object createWidgetList(List<xml.XmlElement> elements){

    if(elements.length==0){
      return null;
    }else {
      List<Object> list = new List();
      Object obj;
      for (xml.XmlElement element in elements) {
        //print(element.name.toString());
        Iterable<xml.XmlElement> nodes = element.children.where((
            node) => node is xml.XmlElement).map((node) =>
        node as xml.XmlElement);

        switch (element.name.toString()) {
          case ELM_EXPANDED:
            obj = new Expanded(child: createWidgetList(nodes.toList()),);
            list.add(obj);
            break;
          case ELM_CENTER:
            obj = new Center(child: createWidgetList(nodes.toList()),);
            list.add(obj);
            break;
          case ELM_TEXT:
            obj = new Text(callPropertyText(element.text));
            list.add(obj);
            break;
          case ELM_RAISED_BUTTON:
            var onPressedAttr = "";
            print("ATTRIBUTE RAISED BUTTON");
            for(xml.XmlAttribute attr in element.attributes){
              print(attr.name.toString()+":"+attr.value);
              if(attr.name.toString()=="onPressed"){
                print("MASUK");
                onPressedAttr = attr.value;
              }
            }
            print("ON PRESSED:"+onPressedAttr);
            obj = new RaisedButton(child:createWidgetList(nodes.toList()) , onPressed:() {
              // Perform some action
              callFunction(onPressedAttr);
            } ,);
            list.add(obj);
            break;
          case ELM_MATERIAL:
            obj = new Material(child:createWidgetList(nodes.toList()));
            list.add(obj);
            break;
          case ELM_ROW:
            obj = new Row(children:createWidgetList(nodes.toList()));
            list.add(obj);
            break;
          case ELM_COLUMN:
            obj = new Column(children:createWidgetList(nodes.toList()));
            list.add(obj);
            break;
          case ELM_CONTAINER:
            var height = 56.0;
            var padding = const EdgeInsets.symmetric(horizontal: 8.0);
            var decoration = new BoxDecoration(color: Colors.blue[500]);
            obj = new Container(
                height: height,padding: padding,decoration: decoration,  child:createWidgetList(nodes.toList())
            );
            list.add(obj);
            break;
          case ELM_ICON_BUTTON:
            var key = "1";
            var icon = new Icon(Icons.menu);
            var tooltip = "";
            for(xml.XmlAttribute attr in element.attributes){
              if(attr.name.toString()=="icon"){
                if(attr.value=="search"){
                  icon = new Icon(Icons.search);
                }
              }
              if(attr.name.toString()=="tooltip"){
                tooltip = attr.value;
              }
              if(attr.name.toString()=="key"){
                key = attr.value;
              }
            }
            obj = new IconButton(icon:icon,tooltip:tooltip,onPressed: null,);
//          return new IconButton(icon:icon,tooltip:tooltip,onPressed: null,);
            list.add(obj);
            break;
          default:
            obj = new Text(element.text);
            list.add(obj);
        }
      }
      return list.length>1?list:obj;
    }
  }
}

