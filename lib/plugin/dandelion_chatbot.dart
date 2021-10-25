/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/enums/install_type.dart';
import 'package:dart_build_script/plugin/std_progress.dart';
import 'package:dart_build_script/util/file_utils.dart';
import 'package:dio/dio.dart';

/// 蒲公英智能机器人
class DandelionChatbot {
  /// 构造函数
  DandelionChatbot(
    this.url,
    this.apiKey,
    this.userKey, {
    this.buildInstallType = InstallType.public,
    this.buildPassword = '',
    this.buildUpdateDescription,
    this.buildName,
    this.buildInstallDate,
    this.buildInstallStartDate,
    this.buildInstallEndDate,
    this.buildChannelShortcut,
    this.appKey,
  });

  /// url
  final String url;

  /// apiKey
  final String apiKey;

  /// userKey
  final String userKey;

  /// buildInstallType
  final InstallType buildInstallType;

  /// buildPassword
  final String buildPassword;

  /// buildUpdateDescription
  final String? buildUpdateDescription;

  /// buildName
  final String? buildName;

  /// buildInstallDate
  final int? buildInstallDate;

  /// buildInstallStartDate
  final String? buildInstallStartDate;

  /// buildInstallEndDate
  final String? buildInstallEndDate;

  /// buildChannelShortcut
  final String? buildChannelShortcut;

  /// appKey
  final String? appKey;

  /// 上传到蒲公英
  Future<Map<String, dynamic>> upload(File file) async {
    final dio = Dio();
    final data = <String, dynamic>{};
    data['_api_key'] = apiKey;
    data['userKey'] = userKey;
    data['buildInstallType'] = getInstallTypeValue(buildInstallType);
    data['buildPassword'] = buildPassword;
    if (buildUpdateDescription != null) {
      data['buildUpdateDescription'] = buildUpdateDescription;
    }
    if (buildName != null) {
      data['buildName'] = buildName;
    }
    if (buildInstallDate != null) {
      data['buildInstallDate'] = buildInstallDate;
    }
    if (buildInstallStartDate != null) {
      data['buildInstallStartDate'] = buildInstallStartDate;
    }
    if (buildInstallEndDate != null) {
      data['buildInstallEndDate'] = buildInstallEndDate;
    }
    if (buildChannelShortcut != null) {
      data['buildChannelShortcut'] = buildChannelShortcut;
    }
    if (appKey != null) {
      data['appKey'] = appKey;
    }
    data['file'] = MultipartFile.fromFileSync(file.path);
    final response = await dio.post<dynamic>(
      url,
      data: FormData.fromMap(data),
      onSendProgress: (count, total) {
        final percent = count * 100 / total;
        final formattedPercent = '${percent.toStringAsFixed(2)}%';
        final countStr = FileUtils.convertFukeSize(count).replaceAll(' ', '').replaceAll('Byte', 'B');
        final totalStr = FileUtils.convertFukeSize(total).replaceAll(' ', '').replaceAll('Byte', 'B');
        StdProgress.writeProgress(count, total, '正在上传($formattedPercent)：', ' $countStr/$totalStr');
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
