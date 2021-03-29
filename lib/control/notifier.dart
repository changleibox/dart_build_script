/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:sprintf/sprintf.dart';

import '../common/paths.dart';
import '../config/configs.dart';
import '../plugin/dingtalk_chatbot.dart';
import '../util/date_time_utils.dart';
import '../util/file_utils.dart';

/// 通知
class Notifier {
  /// 构造函数
  Notifier(this.config) : chatbot = DingtalkChatbot(config.url!, config.secret!, config.accessKey!);

  /// 钉钉配置
  final DingtalkConfig config;

  /// 智能机器人
  final DingtalkChatbot chatbot;

  /// 通知
  Future<Map<String, dynamic>> notify(String platform, Map<String, dynamic> data) async {
    final file = File(descriptionPath);
    var content = await file.readAsString();
    content = sprintf(content, <dynamic>[
      data['data']['buildName'],
      platform,
      data['data']['buildVersion'],
      data['data']['buildBuildVersion'],
      FileUtils.convertFukeSize(int.tryParse(data['data']['buildFileSize'] as String)!),
      DateTimeUtils.convertDateTime(data['data']['buildUpdated'] as String),
      data['data']['buildQRCodeURL'],
      data['data']['buildShortcutUrl'],
      data['apiKey'],
      data['data']['buildKey'],
      data['buildPassword'],
    ]);
    return await chatbot.sendMarkdown(
      config.title!,
      content,
      isAtAll: config.isAtAll!,
      atMobiles: config.atMobiles,
      atDingtalkIds: config.atDingtalkIds,
      isAutoAt: config.isAutoAt!,
    );
  }
}
