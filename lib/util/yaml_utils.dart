import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

class YamlUtils {
  static Future<bool> dumpFile(String data, String target) async {
    var file = File(target);
    if (await file.exists()) {
      return false;
    }
    await file.create(recursive: true);
    await file.writeAsString(_convertYaml(json.decode(data)));
    return true;
  }

  static String dump(Map data, [String prefix = '', String intent = '  ']) {
    return _convertYaml(data, prefix, intent).trim();
  }

  static Map loadFile(String path) {
    var file = File(path);
    var configs = loadYaml(
      file.readAsStringSync(),
      sourceUrl: path,
    );
    return json.decode(json.encode(configs));
  }

  static String _convertYaml(dynamic data, [String prefix = '', String intent = '  ']) {
    var buffer = StringBuffer();
    if (data is Map) {
      for (var key in data.keys) {
        buffer.writeln();
        var value = data[key];
        buffer.write(prefix);
        buffer.write(['$key:', _convertYamlValue(value, prefix, intent)].join(' '));
      }
    } else if (data is List) {
      for (var value in data) {
        buffer.writeln();
        buffer.write(prefix);
        buffer.write(['-', _convertYamlValue(value, prefix, intent)].join(' '));
      }
    } else {
      buffer.write(data);
    }
    return buffer.toString();
  }

  static String _convertYamlValue(dynamic value, [String prefix = '', String intent = '  ']) {
    var newPrefix = prefix;
    if (value is List || value is Map) {
      newPrefix += intent;
    }
    return _convertYaml(value, newPrefix, intent);
  }
}
