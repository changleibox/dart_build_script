/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/control/builder.dart';
import 'package:dart_build_script/control/gitter.dart';
import 'package:dart_build_script/control/notifier.dart';
import 'package:dart_build_script/control/uploader.dart';
import 'package:dart_build_script/enums/export_type.dart';
import 'package:dart_build_script/manager/organizer.dart';

/// 管理器
class Manager {
  /// 构造函数
  const Manager(this.config);

  /// 配置
  final Config? config;

  /// 构建
  Future<void> build() async {
    assert(config != null, '请添加配置文件');
    final gitConfig = config!.gitConfig;
    final apkBuildConfig = config!.apkBuildConfig;
    final iosBuildConfig = config!.iosBuildConfig;
    final appStoreConfig = config!.appStoreConfig;
    final pgyConfig = config!.pgyConfig;
    final dingtalkConfig = config!.dingtalkConfig;

    if (gitConfig != null) {
      final gitter = Gitter(gitConfig);
      await gitter.pull();
    }

    Notifier? notifier;
    if (dingtalkConfig != null) {
      notifier = Notifier(dingtalkConfig);
    }

    final organizers = <Organizer>[];
    if (apkBuildConfig != null) {
      organizers.add(Organizer(
        ApkBuilder('Android', apkBuildConfig),
        uploader: ApkUploader(
          convertExportType(apkBuildConfig.exportType!)!,
          pgyConfig,
          pgyConfig?.androidAppKey,
        ),
        notifier: notifier,
      ));
    }
    if (iosBuildConfig != null) {
      organizers.add(Organizer(
        IOSBuilder('iOS', iosBuildConfig),
        uploader: IOSUploader(
          convertExportType(iosBuildConfig.exportType!)!,
          pgyConfig,
          pgyConfig?.iosAppKey,
          appStoreConfig,
        ),
        notifier: notifier,
      ));
    }
    assert(organizers.isNotEmpty, '请在配置文件设置需要构建的类型');
    for (var organizer in organizers) {
      final dynamic result = await organizer.release();
      if (result != null) {
        stdout.writeln('构建成功：$result');
      }
    }
  }
}
