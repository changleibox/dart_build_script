/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'package:dart_build_script/control/builder.dart';
import 'package:dart_build_script/control/notifier.dart';
import 'package:dart_build_script/control/uploader.dart';

/// 把所有流程组织在一起
class Organizer {
  /// 构造函数
  Organizer(this.builder, {this.uploader, this.notifier});

  /// 构建器
  final Builder builder;

  /// 上传器
  final Uploader? uploader;

  /// 通知器
  final Notifier? notifier;

  /// 发布
  Future<dynamic> release() async {
    final appFile = await builder.startBuild();
    assert(appFile?.existsSync() == true, '构建失败，请稍后重试');

    if (uploader == null || appFile == null) {
      return;
    }
    final dynamic result = await uploader!.upload(appFile);
    if (notifier != null && result is Map<String, dynamic>) {
      assert(result['code'] == 0, result['message']);
      return await notifier!.notify(builder.platform, builder.buildType, result);
    }
    return result;
  }
}
