/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'package:dart_build_script/util/string_utils.dart';

/// Created by changlei on 2021/10/21.
///
/// 构建类型
class BuildType {
  const BuildType._(this.name, this.index);

  /// 名称
  final String name;

  /// index
  final int index;

  /// debug
  bool get isDebug => this == debug;

  /// release
  bool get isRelease => this == release;

  /// configuration
  String get configuration => capitalize(toString())!;

  /// valueOf
  static BuildType valueOf(String? buildType) {
    switch (buildType?.toLowerCase()) {
      case 'debug':
        return BuildType.debug;
      case 'profile':
        return BuildType.profile;
      case 'release':
        return BuildType.release;
    }
    return BuildType.debug;
  }

  /// 调试
  static const debug = BuildType._('调试', 0);

  /// 测试
  static const profile = BuildType._('调试', 1);

  /// 发布
  static const release = BuildType._('发布', 2);

  @override
  String toString() {
    switch (this) {
      case debug:
        return 'debug';
      case profile:
        return 'profile';
      case release:
        return 'release';
    }
    return super.toString();
  }
}
