import 'dart:io';

import 'package:dio/dio.dart';

import '../enums/install_type.dart';
import 'std_progress.dart';

class DandelionChatbot {
  final String url;
  final String apiKey;
  final String userKey;
  final InstallType buildInstallType;
  final String buildPassword;
  final String? buildUpdateDescription;
  final String? buildName;
  final int? buildInstallDate;
  final String? buildInstallStartDate;
  final String? buildInstallEndDate;
  final String? buildChannelShortcut;
  final String? appKey;

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

  Future<Map<String, dynamic>> upload(File file) async {
    var dio = Dio();
    var data = Map<String, dynamic>();
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
    var response = await dio.post(
      url,
      data: FormData.fromMap(data),
      onSendProgress: (count, total) {
        StdProgress.write(count, total);
      },
    );
    return response.data;
  }
}
