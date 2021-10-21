/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_build_script/util/parse_utils.dart';
import 'package:dio/dio.dart';

/// 钉钉智能机器人
class DingtalkChatbot {
  /// 构造函数
  DingtalkChatbot(this.baseUrl, this.secret, this.accessKey) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final stringToSign = '$timestamp\n$secret';
    final hmacCode = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(stringToSign));
    final sign = quotePlus(base64.encode(hmacCode.bytes));

    _uri = Uri.parse(baseUrl).replace(
      queryParameters: <String, dynamic>{
        'access_token': accessKey,
        'timestamp': timestamp.toString(),
        'sign': sign,
      },
    );
  }

  /// baseUrl
  final String baseUrl;

  /// secret
  final String secret;

  /// accessKey
  final String accessKey;

  late Uri _uri;

  /// 发送消息
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    assert(data.isNotEmpty);
    final options = BaseOptions(
      baseUrl: baseUrl,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Charset': 'UTF-8',
      },
    );
    final dio = Dio(options);
    final response = await dio.postUri<dynamic>(
      _uri,
      data: json.encode(data),
    );
    return response.data as Map<String, dynamic>;
  }

  /// 发送markdown
  Future<Map<String, dynamic>> sendMarkdown(
    String title,
    String text, {
    bool isAtAll = false,
    List<String>? atMobiles,
    List<String>? atUserIds,
    bool isAutoAt = true,
  }) {
    final data = <String, dynamic>{
      'msgtype': 'markdown',
      'markdown': {'title': title, 'text': text},
      'at': <String, dynamic>{},
    };
    if (isAtAll) {
      data['at']['isAtAll'] = isAtAll;
    }
    if (atMobiles != null && atMobiles.isNotEmpty) {
      data['at']['atMobiles'] = atMobiles;
      if (isAutoAt) {
        data['markdown']['text'] = text + '\n' + atMobiles.map((e) => '@$e').join(' ');
      }
    }
    if (atUserIds != null && atUserIds.isNotEmpty) {
      data['at']['atUserIds'] = atUserIds;
    }
    return sendMessage(data);
  }
}
