/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/common/paths.dart';
import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/control/publisher.dart';
import 'package:dart_build_script/enums/export_type.dart';
import 'package:dart_build_script/enums/install_type.dart';
import 'package:dart_build_script/plugin/dandelion_chatbot.dart';
import 'package:dart_build_script/util/file_utils.dart';

/// 上传器
abstract class Uploader {
  /// 构造函数
  Uploader(this.exportType, this.pgyConfig, this.publisher, {this.appKey});

  /// 导出类型
  final ExportType exportType;

  /// 蒲公英配置
  final PgyConfig? pgyConfig;

  /// 蒲公英appKey
  final String? appKey;

  /// 发布器
  final Publisher? publisher;

  /// 上传
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

  /// 导出到制定目录
  Future<String> export(File file) async {
    return FileUtils.copy(file.parent.path, outputsPath);
  }

  /// 上传到蒲公英
  Future<Map<String, dynamic>> uploadToPgy(File file) async {
    final chatbot = DandelionChatbot(
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
    final result = await chatbot.upload(file);
    result['apiKey'] = pgyConfig!.apiKey;
    result['buildPassword'] = pgyConfig!.buildPassword;
    return result;
  }

  /// 发布
  Future<ProcessResult?> publish(File file) async {
    return await publisher?.publish(file);
  }
}

/// apk上传器
class ApkUploader extends Uploader {
  /// 构造函数
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

/// iOS上传器
class IOSUploader extends Uploader {
  /// 构造函数
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
