import 'dart:io';

import 'package:sprintf/sprintf.dart';

import '../common/paths.dart';
import '../config/configs.dart';
import '../plugin/dingtalk_chatbot.dart';
import '../util/date_time_utils.dart';
import '../util/file_utils.dart';

class Notifier {
  final DingtalkConfig config;
  final DingtalkChatbot chatbot;

  Notifier(this.config) : this.chatbot = DingtalkChatbot(config.url!, config.secret!, config.accessKey!);

  Future<Map<String, dynamic>> notify(String platform, Map<String, dynamic> data) async {
    var file = File(descriptionPath);
    var content = await file.readAsString();
    content = sprintf(content, [
      data['data']['buildName'],
      platform,
      data['data']['buildVersion'],
      data['data']['buildBuildVersion'],
      FileUtils.convertFukeSize(int.tryParse(data['data']['buildFileSize'])!),
      DateTimeUtils.convertDateTime(data['data']['buildUpdated']),
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
