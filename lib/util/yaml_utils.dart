/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// 处理yaml文件
class YamlUtils {
  const YamlUtils._();

  /// 读取内容
  static Map<String, dynamic> loadFile(String path) {
    final file = File(path);
    final dynamic configs = loadYaml(
      file.readAsStringSync(),
      sourceUrl: Uri.file(path),
    );
    return json.decode(json.encode(configs)) as Map<String, dynamic>;
  }

  /// 写文件
  static Future<bool> dumpFile(String jsonStr, String target) async {
    return await dump(json.decode(jsonStr) as Map<String, dynamic>, target);
  }

  /// 写文件
  static Future<bool> dump(Map<String, dynamic> data, String target) async {
    final file = File(target);
    if (file.existsSync()) {
      return false;
    }
    await file.create(recursive: true);
    await file.writeAsString(convert(data));
    return true;
  }

  /// 转换
  static String convert(Map data, [String prefix = '', String intent = '  ']) {
    return _convert(data, prefix, intent).trim();
  }

  static String _convert(dynamic data, [String prefix = '', String intent = '  ']) {
    final buffer = StringBuffer();
    if (data is Map) {
      for (var key in data.keys) {
        buffer.writeln();
        final dynamic value = data[key];
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
