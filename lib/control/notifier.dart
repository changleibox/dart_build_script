/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/common/paths.dart';
import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/enums/build_type.dart';
import 'package:dart_build_script/plugin/dingtalk_chatbot.dart';
import 'package:dart_build_script/util/file_utils.dart';
import 'package:sprintf/sprintf.dart';

/// 通知
class Notifier {
  /// 构造函数
  Notifier(this.config) : chatbot = DingtalkChatbot(config.url!, config.secret!, config.accessKey!);

  /// 钉钉配置
  final DingtalkConfig config;

  /// 智能机器人
  final DingtalkChatbot chatbot;

  /// 通知
  Future<Map<String, dynamic>> notify(String platform, BuildType? builderType, Map<String, dynamic> data) async {
    final file = File(descriptionPath);
    var content = await file.readAsString();
    content = sprintf(content, <dynamic>[
      data['data']['buildName'],
      platform,
      builderType?.name ?? 'UNKNOWN',
      data['data']['buildVersion'],
      data['data']['buildBuildVersion'],
      FileUtils.convertFukeSize(int.tryParse(data['data']['buildFileSize'] as String)!),
      // DateTimeUtils.convertDateTime(data['data']['buildUpdated'] as String),
      data['data']['buildUpdated'] as String,
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
      atUserIds: config.atUserIds,
      isAutoAt: config.isAutoAt!,
    );
  }
}
