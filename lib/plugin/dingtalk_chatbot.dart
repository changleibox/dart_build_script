import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../util/parse_utils.dart';

class DingtalkChatbot {
  final String baseUrl;
  final String secret;
  final String accessKey;

  late Uri _uri;

  DingtalkChatbot(this.baseUrl, this.secret, this.accessKey) {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var stringToSign = '$timestamp\n$secret';
    var hmacCode = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(stringToSign));
    var sign = quotePlus(base64.encode(hmacCode.bytes));

    _uri = Uri.parse(this.baseUrl).replace(
      queryParameters: {
        'access_token': accessKey,
        'timestamp': timestamp.toString(),
        'sign': sign,
      },
    );
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    assert(data.isNotEmpty);
    var options = BaseOptions(
      baseUrl: baseUrl,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Charset': 'UTF-8',
      },
    );
    var dio = Dio(options);
    var response = await dio.postUri(
      _uri,
      data: json.encode(data),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> sendMarkdown(
    String title,
    String text, {
    bool isAtAll = false,
    List<String>? atMobiles,
    List<String>? atDingtalkIds,
    bool isAutoAt = true,
  }) {
    var data = <String, dynamic>{
      'msgtype': 'markdown',
      'markdown': {'title': title, 'text': text},
      'at': {},
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
    if (atDingtalkIds != null && atDingtalkIds.isNotEmpty) {
      data['at']['atDingtalIds'] = atDingtalkIds;
    }
    return sendMessage(data);
  }
}
