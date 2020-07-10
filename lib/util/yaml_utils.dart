import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlUtils {
  static Map loadFile(String path) {
    var file = File(path);
    var configs = loadYaml(
      file.readAsStringSync(),
      sourceUrl: path,
    );
    return json.decode(json.encode(configs));
  }

  static Future<bool> dumpFile(String jsonStr, String target) async {
    return await dump(json.decode(jsonStr), target);
  }

  static Future<bool> dump(Map data, String target) async {
    var file = File(target);
    if (await file.exists()) {
      return false;
    }
    await file.create(recursive: true);
    await file.writeAsString(convert(data));
    return true;
  }

  static String convert(Map data, [String prefix = '', String intent = '  ']) {
    return _convert(data, prefix, intent).trim();
  }

  static String _convert(dynamic data, [String prefix = '', String intent = '  ']) {
    var buffer = StringBuffer();
    if (data is Map) {
      for (var key in data.keys) {
        buffer.writeln();
        var value = data[key];
        buffer.write(prefix);
        buffer.write(['$key:', _convertValue(value, prefix, intent)].join(' '));
      }
    } else if (data is List) {
      for (var value in data) {
        buffer.writeln();
        buffer.write(prefix);
        buffer.write(['-', _convertValue(value, prefix, intent)].join(' '));
      }
    } else {
      buffer.write(data);
    }
    return buffer.toString();
  }

  static String _convertValue(dynamic value, [String prefix = '', String intent = '  ']) {
    var newPrefix = prefix;
    if (value is List || value is Map) {
      newPrefix += intent;
    }
    return _convert(value, newPrefix, intent);
  }
}
