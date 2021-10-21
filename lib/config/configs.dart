/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/control/builder.dart';
import 'package:dart_build_script/util/yaml_utils.dart';

import '../common/paths.dart';

/// 配置
const configs = Configs();

/// 安装配置
Future<void> installConfigs() async {
  final template = File(configTemplatePath).readAsStringSync();
  final result = await YamlUtils.dumpFile(template, configPath);
  assert(!result, '请先填写配置.');
}

/// 配置
class Configs {
  /// 构造函数
  const Configs();

  /// 获取配置
  Config get config => Config.fromJson(YamlUtils.loadFile(configPath));

  @override
  String toString() {
    return config.toJson().toString();
  }
}

/// 配置实体类
class Config {
  /// 构造函数
  Config({
    this.apkBuildConfig,
    this.appStoreConfig,
    this.description,
    this.dingtalkConfig,
    this.gitConfig,
    this.iosBuildConfig,
    this.name,
    this.pgyConfig,
  });

  /// 从json构造
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      apkBuildConfig: json['apk_build_config'] != null
          ? ApkBuildConfig.fromJson(json['apk_build_config'] as Map<String, dynamic>)
          : null,
      appStoreConfig: json['app_store_config'] != null
          ? AppStoreConfig.fromJson(json['app_store_config'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      dingtalkConfig: json['dingtalk_config'] != null
          ? DingtalkConfig.fromJson(json['dingtalk_config'] as Map<String, dynamic>)
          : null,
      gitConfig: json['git_config'] != null ? GitConfig.fromJson(json['git_config'] as Map<String, dynamic>) : null,
      iosBuildConfig: json['ios_build_config'] != null
          ? IosBuildConfig.fromJson(json['ios_build_config'] as Map<String, dynamic>)
          : null,
      name: json['name'] as String?,
      pgyConfig: json['pgy_config'] != null ? PgyConfig.fromJson(json['pgy_config'] as Map<String, dynamic>) : null,
    );
  }

  /// name
  String? name;

  /// 描述
  String? description;

  /// build apk配置
  ApkBuildConfig? apkBuildConfig;

  /// 上传到appStore配置
  AppStoreConfig? appStoreConfig;

  /// 钉钉配置
  DingtalkConfig? dingtalkConfig;

  /// git配置
  GitConfig? gitConfig;

  /// build iOS配置
  IosBuildConfig? iosBuildConfig;

  /// 蒲公英配置
  PgyConfig? pgyConfig;

  /// git是否开启
  bool get gitEnable => gitConfig != null;

  /// android是否开启
  bool get androidEnable => apkBuildConfig != null;

  /// iOS是否开启
  bool get iosEnable => iosBuildConfig != null;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['android_enable'] = androidEnable;
    data['description'] = description;
    data['git_enable'] = gitEnable;
    data['ios_enable'] = iosEnable;
    data['name'] = name;
    if (apkBuildConfig != null) {
      data['apk_build_config'] = apkBuildConfig!.toJson();
    }
    if (appStoreConfig != null) {
      data['app_store_config'] = appStoreConfig!.toJson();
    }
    if (dingtalkConfig != null) {
      data['dingtalk_config'] = dingtalkConfig!.toJson();
    }
    if (gitConfig != null) {
      data['git_config'] = gitConfig!.toJson();
    }
    if (iosBuildConfig != null) {
      data['ios_build_config'] = iosBuildConfig!.toJson();
    }
    if (pgyConfig != null) {
      data['pgy_config'] = pgyConfig!.toJson();
    }
    return data;
  }
}

/// git配置
class GitConfig {
  /// 构造函数
  GitConfig({
    this.branch,
    this.email,
    this.password,
    this.remote,
    this.username,
  });

  /// 从json构造
  factory GitConfig.fromJson(Map<String, dynamic> json) {
    return GitConfig(
      branch: json['branch'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      remote: json['remote'] as String?,
      username: json['username'] as String?,
    );
  }

  /// 分支
  String? branch;

  /// 账号邮箱
  String? email;

  /// 密码
  String? password;

  /// 远程地址
  String? remote;

  /// 用户名
  String? username;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['branch'] = branch;
    data['email'] = email;
    data['password'] = password;
    data['remote'] = remote;
    data['username'] = username;
    return data;
  }
}

/// build配置
class BuildConfig {
  /// 构造函数
  BuildConfig({
    this.buildName,
    this.buildNumber,
    this.buildType,
    this.dartDefine,
    this.exportType,
    this.flavor,
    this.obfuscate,
    this.performanceMeasurementFile,
    this.pub,
    this.splitDebugInfo,
    this.target,
    this.treeShakeIcons,
  });

  /// 从json构造
  factory BuildConfig.fromJson(Map<String, dynamic> json) {
    return BuildConfig(
      buildName: json['build_name'] as String?,
      buildNumber: json['build_number'] as String?,
      buildType: BuildType.valueOf(json['build_type'] as String?),
      dartDefine: json['dart_define'] as String?,
      exportType: json['export_type'] as String?,
      flavor: json['flavor'] as String?,
      obfuscate: json['obfuscate'] as bool?,
      performanceMeasurementFile: json['performance_measurement_file'] as String?,
      pub: json['pub'] as bool?,
      splitDebugInfo: json['split_debug_info'] as String?,
      target: json['target'] as String?,
      treeShakeIcons: json['tree_shake_icons'] as bool?,
    );
  }

  /// buildName
  String? buildName;

  /// buildNumber
  String? buildNumber;

  /// buildType
  BuildType? buildType;

  /// dartDefine
  String? dartDefine;

  /// 导出类型
  String? exportType;

  /// flavor
  String? flavor;

  /// obfuscate
  bool? obfuscate;

  /// performanceMeasurementFile
  String? performanceMeasurementFile;

  /// pub
  bool? pub;

  /// splitDebugInfo
  String? splitDebugInfo;

  /// target
  String? target;

  /// treeShakeIcons
  bool? treeShakeIcons;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['build_name'] = buildName;
    data['build_number'] = buildNumber;
    data['build_type'] = buildType;
    data['dart_define'] = dartDefine;
    data['export_type'] = exportType;
    data['flavor'] = flavor;
    data['obfuscate'] = obfuscate;
    data['performance_measurement_file'] = performanceMeasurementFile;
    data['pub'] = pub;
    data['split_debug_info'] = splitDebugInfo;
    data['target'] = target;
    data['tree_shake_icons'] = treeShakeIcons;
    return data;
  }
}

/// build apk配置
class ApkBuildConfig extends BuildConfig {
  /// 构造函数
  ApkBuildConfig({
    String? buildName,
    String? buildNumber,
    BuildType? buildType,
    String? dartDefine,
    String? exportType,
    String? flavor,
    bool? obfuscate,
    String? performanceMeasurementFile,
    bool? pub,
    this.shrink,
    String? splitDebugInfo,
    this.splitPerAbi,
    String? target,
    this.targetPlatform,
    this.trackWidgetCreation,
    bool? treeShakeIcons,
  }) : super(
          buildName: buildName,
          buildNumber: buildNumber,
          buildType: buildType,
          dartDefine: dartDefine,
          exportType: exportType,
          flavor: flavor,
          obfuscate: obfuscate,
          performanceMeasurementFile: performanceMeasurementFile,
          pub: pub,
          splitDebugInfo: splitDebugInfo,
          target: target,
          treeShakeIcons: treeShakeIcons,
        );

  /// 从json构造
  factory ApkBuildConfig.fromJson(Map<String, dynamic> json) {
    return ApkBuildConfig(
      buildName: json['build_name'] as String?,
      buildNumber: json['build_number'] as String?,
      buildType: BuildType.valueOf(json['build_type'] as String?),
      dartDefine: json['dart_define'] as String?,
      exportType: json['export_type'] as String?,
      flavor: json['flavor'] as String?,
      obfuscate: json['obfuscate'] as bool?,
      performanceMeasurementFile: json['performance_measurement_file'] as String?,
      pub: json['pub'] as bool?,
      shrink: json['shrink'] as bool?,
      splitDebugInfo: json['split_debug_info'] as String?,
      splitPerAbi: json['split_per_abi'] as String?,
      target: json['target'] as String?,
      targetPlatform: json['target_platform'] as String?,
      trackWidgetCreation: json['track_widget_creation'] as bool?,
      treeShakeIcons: json['tree_shake_icons'] as bool?,
    );
  }

  /// shrink
  bool? shrink;

  /// splitPerAbi
  String? splitPerAbi;

  /// targetPlatform
  String? targetPlatform;

  /// trackWidgetCreation
  bool? trackWidgetCreation;

  /// 转为json
  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['build_name'] = buildName;
    data['build_number'] = buildNumber;
    data['build_type'] = buildType;
    data['dart_define'] = dartDefine;
    data['export_type'] = exportType;
    data['flavor'] = flavor;
    data['obfuscate'] = obfuscate;
    data['performance_measurement_file'] = performanceMeasurementFile;
    data['pub'] = pub;
    data['shrink'] = shrink;
    data['split_debug_info'] = splitDebugInfo;
    data['split_per_abi'] = splitPerAbi;
    data['target'] = target;
    data['target_platform'] = targetPlatform;
    data['track_widget_creation'] = trackWidgetCreation;
    data['tree_shake_icons'] = treeShakeIcons;
    return data;
  }
}

/// build iOS配置
class IosBuildConfig extends BuildConfig {
  /// 构造函数
  IosBuildConfig({
    String? buildName,
    String? buildNumber,
    BuildType? buildType,
    String? dartDefine,
    String? exportType,
    String? flavor,
    bool? obfuscate,
    String? performanceMeasurementFile,
    bool? pub,
    this.codesign,
    this.exportOptions,
    String? splitDebugInfo,
    String? target,
    this.simulator,
    bool? treeShakeIcons,
  }) : super(
          buildName: buildName,
          buildNumber: buildNumber,
          buildType: buildType,
          dartDefine: dartDefine,
          exportType: exportType,
          flavor: flavor,
          obfuscate: obfuscate,
          performanceMeasurementFile: performanceMeasurementFile,
          pub: pub,
          splitDebugInfo: splitDebugInfo,
          target: target,
          treeShakeIcons: treeShakeIcons,
        );

  /// 从json构造
  factory IosBuildConfig.fromJson(Map<String, dynamic> json) {
    return IosBuildConfig(
      buildName: json['build_name'] as String?,
      buildNumber: json['build_number'] as String?,
      buildType: BuildType.valueOf(json['build_type'] as String?),
      codesign: json['codesign'] as bool?,
      dartDefine: json['dart_define'] as String?,
      exportOptions: json['export_options'] != null
          ? ExportOptions.fromJson(json['export_options'] as Map<String, dynamic>)
          : null,
      exportType: json['export_type'] as String?,
      flavor: json['flavor'] as String?,
      obfuscate: json['obfuscate'] as bool?,
      performanceMeasurementFile: json['performance_measurement_file'] as String?,
      pub: json['pub'] as bool?,
      simulator: json['simulator'] as bool?,
      splitDebugInfo: json['split_debug_info'] as String?,
      target: json['target'] as String?,
      treeShakeIcons: json['tree_shake_icons'] as bool?,
    );
  }

  /// codesign
  bool? codesign;

  /// 导出配置
  ExportOptions? exportOptions;

  /// simulator
  bool? simulator;

  /// 转为json
  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['build_name'] = buildName;
    data['build_number'] = buildNumber;
    data['build_type'] = buildType;
    data['codesign'] = codesign;
    data['dart_define'] = dartDefine;
    data['export_type'] = exportType;
    data['flavor'] = flavor;
    data['obfuscate'] = obfuscate;
    data['performance_measurement_file'] = performanceMeasurementFile;
    data['pub'] = pub;
    data['simulator'] = simulator;
    data['split_debug_info'] = splitDebugInfo;
    data['target'] = target;
    data['tree_shake_icons'] = treeShakeIcons;
    if (exportOptions != null) {
      data['export_options'] = exportOptions!.toJson();
    }
    return data;
  }
}

/// 导出配置
class ExportOptions {
  /// 构造函数
  ExportOptions({
    this.debug,
    this.profile,
    this.release,
  });

  /// 从json构造
  factory ExportOptions.fromJson(Map<String, dynamic> json) {
    return ExportOptions(
      debug: json['debug'] as String?,
      profile: json['profile'] as String?,
      release: json['release'] as String?,
    );
  }

  /// debug模式下的配置文件名
  String? debug;

  /// profile模式下的配置文件名
  String? profile;

  /// release模式下的配置文件名
  String? release;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['debug'] = debug;
    data['profile'] = profile;
    data['release'] = release;
    return data;
  }
}

/// 上传到appStore的配置
class AppStoreConfig {
  /// 构造函数
  AppStoreConfig({
    this.apiIssuer,
    this.apiKey,
    this.appleId,
    this.outputFormat,
    this.type,
  });

  /// 从json构造
  factory AppStoreConfig.fromJson(Map<String, dynamic> json) {
    return AppStoreConfig(
      apiIssuer: json['api_issuer'] as String?,
      apiKey: json['api_key'] as String?,
      appleId: json['apple_id'] as String?,
      outputFormat: json['output_format'] as String?,
      type: json['type'] as String?,
    );
  }

  /// apiIssuer
  String? apiIssuer;

  /// apiKey
  String? apiKey;

  /// appleId
  String? appleId;

  /// outputFormat
  String? outputFormat;

  /// type
  String? type;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['api_issuer'] = apiIssuer;
    data['api_key'] = apiKey;
    data['apple_id'] = appleId;
    data['output_format'] = outputFormat;
    data['type'] = type;
    return data;
  }
}

/// 上传到蒲公英的配置
class PgyConfig {
  /// 构造函数
  PgyConfig({
    this.apiKey,
    this.androidAppKey,
    this.buildChannelShortcut,
    this.buildInstallDate,
    this.buildInstallEndDate,
    this.buildInstallStartDate,
    this.buildInstallType,
    this.buildName,
    this.buildPassword,
    this.buildUpdateDescription,
    this.iosAppKey,
    this.url,
    this.userKey,
  });

  /// 从json构造
  factory PgyConfig.fromJson(Map<String, dynamic> json) {
    return PgyConfig(
      apiKey: json['_api_key'] as String?,
      androidAppKey: json['apk_app_key'] as String?,
      buildChannelShortcut: json['build_channel_shortcut'] as String?,
      buildInstallDate: json['build_install_date'] as int?,
      buildInstallEndDate: json['build_install_end_date'] as String?,
      buildInstallStartDate: json['build_install_start_date'] as String?,
      buildInstallType: json['build_install_type'] as int?,
      buildName: json['build_name'] as String?,
      buildPassword: json['build_password'] as String?,
      buildUpdateDescription: json['build_update_description'] as String?,
      iosAppKey: json['ios_app_key'] as String?,
      url: json['url'] as String?,
      userKey: json['user_key'] as String?,
    );
  }

  /// apiKey
  String? apiKey;

  /// androidAppKey
  String? androidAppKey;

  /// buildChannelShortcut
  String? buildChannelShortcut;

  /// buildInstallDate
  int? buildInstallDate;

  /// buildInstallEndDate
  String? buildInstallEndDate;

  /// buildInstallStartDate
  String? buildInstallStartDate;

  /// buildInstallType
  int? buildInstallType;

  /// buildName
  String? buildName;

  /// buildPassword
  String? buildPassword;

  /// buildUpdateDescription
  String? buildUpdateDescription;

  /// iosAppKey
  String? iosAppKey;

  /// url
  String? url;

  /// userKey
  String? userKey;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_api_key'] = apiKey;
    data['apk_app_key'] = androidAppKey;
    data['build_channel_shortcut'] = buildChannelShortcut;
    data['build_install_date'] = buildInstallDate;
    data['build_install_end_date'] = buildInstallEndDate;
    data['build_install_start_date'] = buildInstallStartDate;
    data['build_install_type'] = buildInstallType;
    data['build_name'] = buildName;
    data['build_password'] = buildPassword;
    data['build_update_description'] = buildUpdateDescription;
    data['ios_app_key'] = iosAppKey;
    data['url'] = url;
    data['user_key'] = userKey;
    return data;
  }
}

/// 钉钉配置
class DingtalkConfig {
  /// 构造函数
  DingtalkConfig({
    this.accessKey,
    this.atUserIds,
    this.atMobiles,
    this.isAtAll,
    this.isAutoAt,
    this.secret,
    this.title,
    this.url,
  });

  /// 从json构造
  factory DingtalkConfig.fromJson(Map<String, dynamic> json) {
    return DingtalkConfig(
      accessKey: json['access_key'] as String?,
      atUserIds: json['at_user_ids'] != null ? List<String>.from(json['at_user_ids'] as Iterable<dynamic>) : null,
      atMobiles: json['at_mobiles'] != null ? List<String>.from(json['at_mobiles'] as Iterable<dynamic>) : null,
      isAtAll: json['is_at_all'] as bool?,
      isAutoAt: json['is_auto_at'] as bool?,
      secret: json['secret'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
    );
  }

  /// accessKey
  String? accessKey;

  /// atDingtalkIds
  List<String>? atUserIds;

  /// atMobiles
  List<String>? atMobiles;

  /// isAtAll
  bool? isAtAll;

  /// isAutoAt
  bool? isAutoAt;

  /// secret
  String? secret;

  /// title
  String? title;

  /// url
  String? url;

  /// 转为json
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_key'] = accessKey;
    data['is_at_all'] = isAtAll;
    data['is_auto_at'] = isAutoAt;
    data['secret'] = secret;
    data['title'] = title;
    data['url'] = url;
    if (atUserIds != null) {
      data['at_user_ids'] = atUserIds;
    }
    if (atMobiles != null) {
      data['at_mobiles'] = atMobiles;
    }
    return data;
  }
}
