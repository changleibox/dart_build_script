import 'dart:io';

import '../common/paths.dart';
import '../config/configs.dart';
import '../enums/export_type.dart';
import '../enums/install_type.dart';
import '../plugin/dandelion_chatbot.dart';
import '../util/file_utils.dart';
import 'publisher.dart';

abstract class Uploader {
  final ExportType exportType;
  final PgyConfig? pgyConfig;
  final String? appKey;
  final Publisher? publisher;

  Uploader(this.exportType, this.pgyConfig, this.publisher, {this.appKey});

  Future<dynamic> upload(File file) async {
    switch (exportType) {
      case ExportType.export:
        return await export(file);
      case ExportType.dandelion:
        if (pgyConfig == null) {
          return file;
        }
        return await uploadToPgy(file);
      case ExportType.appStore:
        if (publisher == null) {
          return file;
        }
        return await publish(file);
    }
  }

  Future<String> export(File file) async {
    return FileUtils.copy(file.parent.path, outputsPath);
  }

  Future<Map<String, dynamic>> uploadToPgy(File file) async {
    var chatbot = DandelionChatbot(
      pgyConfig!.url!,
      pgyConfig!.apiKey!,
      pgyConfig!.userKey!,
      buildInstallType: convertInstallType(pgyConfig!.buildInstallType!)!,
      buildPassword: pgyConfig!.buildPassword!,
      buildUpdateDescription: pgyConfig!.buildUpdateDescription,
      buildName: pgyConfig!.buildName,
      buildInstallDate: pgyConfig!.buildInstallDate,
      buildInstallStartDate: pgyConfig!.buildInstallStartDate,
      buildInstallEndDate: pgyConfig!.buildInstallEndDate,
      appKey: appKey!,
    );
    var result = await chatbot.upload(file);
    result['apiKey'] = pgyConfig!.apiKey;
    result['buildPassword'] = pgyConfig!.buildPassword;
    return result;
  }

  Future<ProcessResult?> publish(File file) async {
    return await publisher?.publish(file);
  }
}

class ApkUploader extends Uploader {
  ApkUploader(
    ExportType exportType,
    PgyConfig? pgyConfig,
    String? appKey,
  ) : super(
          exportType,
          pgyConfig,
          ApkPublisher(),
          appKey: appKey,
        );
}

class IOSUploader extends Uploader {
  IOSUploader(
    ExportType exportType,
    PgyConfig? pgyConfig,
    String? appKey,
    AppStoreConfig? appStoreConfig,
  ) : super(
          exportType,
          pgyConfig,
          appStoreConfig == null ? null : IOSPublisher(appStoreConfig),
          appKey: appKey,
        );
}
