library lib.common.globals;
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

const ELM_EXPANDED = "Expanded";
const ELM_CENTER = "Center";
const ELM_TEXT = "Text";
const ELM_MATERIAL = "Material";
const ELM_ROW = "Row";
const ELM_COLUMN = "Column";
const ELM_CONTAINER = "Container";
const ELM_ICON_BUTTON = "IconButton";
const ELM_RAISED_BUTTON = "RaisedButton";




class GlobalLayoutXML {
  static Map<String, xml.XmlDocument> _cacheDoc = new Map<String, xml.XmlDocument>();

  static void set(String layoutPath) async {
    String storeXml = await loadXmlSchemaLayoutAsset(layoutPath);
    _cacheDoc[layoutPath] = xml.parse(storeXml);
  }

  static Future<String> loadXmlSchemaLayoutAsset(String layoutPath) async {
    return await rootBundle.loadString(layoutPath);
  }

  static Future<xml.XmlDocument> loadXmlDocumentMapLayoutAsset(String layoutPath) async {
    String storeXml = await loadXmlSchemaLayoutAsset(layoutPath);
    return xml.parse(storeXml);
  }

  static xml.XmlDocument get(String layoutPath){
    return _cacheDoc[layoutPath];
  }
}