import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart' as yaml;

import '../common/paths.dart';

const Configs configs = const Configs();

Future<void> installConfigs() async {
  var file = File(configPath);
  if (await file.exists()) {
    return;
  }
  await file.create(recursive: true);
  await file.writeAsString(File(configTemplatePath).readAsStringSync());
  assert(false, '请先填写配置.');
}

class Configs {
  const Configs();

  Config get config {
    var file = File(configPath);
    var configs = yaml.loadYaml(
      file.readAsStringSync(),
      sourceUrl: configPath,
    );
    return Config.fromJson(json.decode(json.encode(configs)));
  }

  @override
  String toString() {
    return config.toJson().toString();
  }
}

class Config {
  String name;
  String description;
  ApkBuildConfig apkBuildConfig;
  AppStoreConfig appStoreConfig;
  DingtalkConfig dingtalkConfig;
  GitConfig gitConfig;
  IosBuildConfig iosBuildConfig;
  PgyConfig pgyConfig;

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

  bool get gitEnable => gitConfig != null;

  bool get androidEnable => apkBuildConfig != null;

  bool get iosEnable => iosBuildConfig != null;

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      apkBuildConfig: json['apk_build_config'] != null ? ApkBuildConfig.fromJson(json['apk_build_config']) : null,
      appStoreConfig: json['app_store_config'] != null ? AppStoreConfig.fromJson(json['app_store_config']) : null,
      description: json['description'],
      dingtalkConfig: json['dingtalk_config'] != null ? DingtalkConfig.fromJson(json['dingtalk_config']) : null,
      gitConfig: json['git_config'] != null ? GitConfig.fromJson(json['git_config']) : null,
      iosBuildConfig: json['ios_build_config'] != null ? IosBuildConfig.fromJson(json['ios_build_config']) : null,
      name: json['name'],
      pgyConfig: json['pgy_config'] != null ? PgyConfig.fromJson(json['pgy_config']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['android_enable'] = this.androidEnable;
    data['description'] = this.description;
    data['git_enable'] = this.gitEnable;
    data['ios_enable'] = this.iosEnable;
    data['name'] = this.name;
    if (this.apkBuildConfig != null) {
      data['apk_build_config'] = this.apkBuildConfig.toJson();
    }
    if (this.appStoreConfig != null) {
      data['app_store_config'] = this.appStoreConfig.toJson();
    }
    if (this.dingtalkConfig != null) {
      data['dingtalk_config'] = this.dingtalkConfig.toJson();
    }
    if (this.gitConfig != null) {
      data['git_config'] = this.gitConfig.toJson();
    }
    if (this.iosBuildConfig != null) {
      data['ios_build_config'] = this.iosBuildConfig.toJson();
    }
    if (this.pgyConfig != null) {
      data['pgy_config'] = this.pgyConfig.toJson();
    }
    return data;
  }
}

class GitConfig {
  String branch;
  String email;
  String password;
  String remote;
  String username;

  GitConfig({
    this.branch,
    this.email,
    this.password,
    this.remote,
    this.username,
  });

  factory GitConfig.fromJson(Map<String, dynamic> json) {
    return GitConfig(
      branch: json['branch'],
      email: json['email'],
      password: json['password'],
      remote: json['remote'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branch'] = this.branch;
    data['email'] = this.email;
    data['password'] = this.password;
    data['remote'] = this.remote;
    data['username'] = this.username;
    return data;
  }
}

class BuildConfig {
  String buildName;
  String buildNumber;
  String buildType;
  String dartDefine;
  String exportType;
  String flavor;
  bool obfuscate;
  String performanceMeasurementFile;
  bool pub;
  String splitDebugInfo;
  String target;
  bool treeShakeIcons;

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

  factory BuildConfig.fromJson(Map<String, dynamic> json) {
    return BuildConfig(
        buildName: json['build_name'],
        buildNumber: json['build_number'],
        buildType: json['build_type'],
        dartDefine: json['dart_define'],
        exportType: json['export_type'],
        flavor: json['flavor'],
        obfuscate: json['obfuscate'],
        performanceMeasurementFile: json['performance_measurement_file'],
        pub: json['pub'],
        splitDebugInfo: json['split_debug_info'],
        target: json['target'],
        treeShakeIcons: json['tree_shake_icons']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['build_name'] = this.buildName;
    data['build_number'] = this.buildNumber;
    data['build_type'] = this.buildType;
    data['dart_define'] = this.dartDefine;
    data['export_type'] = this.exportType;
    data['flavor'] = this.flavor;
    data['obfuscate'] = this.obfuscate;
    data['performance_measurement_file'] = this.performanceMeasurementFile;
    data['pub'] = this.pub;
    data['split_debug_info'] = this.splitDebugInfo;
    data['target'] = this.target;
    data['tree_shake_icons'] = this.treeShakeIcons;
    return data;
  }
}

class ApkBuildConfig extends BuildConfig {
  bool shrink;
  String splitPerAbi;
  String targetPlatform;
  bool trackWidgetCreation;

  ApkBuildConfig({
    String buildName,
    String buildNumber,
    String buildType,
    String dartDefine,
    String exportType,
    String flavor,
    bool obfuscate,
    String performanceMeasurementFile,
    bool pub,
    this.shrink,
    String splitDebugInfo,
    this.splitPerAbi,
    String target,
    this.targetPlatform,
    this.trackWidgetCreation,
    bool treeShakeIcons,
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

  factory ApkBuildConfig.fromJson(Map<String, dynamic> json) {
    return ApkBuildConfig(
      buildName: json['build_name'],
      buildNumber: json['build_number'],
      buildType: json['build_type'],
      dartDefine: json['dart_define'],
      exportType: json['export_type'],
      flavor: json['flavor'],
      obfuscate: json['obfuscate'],
      performanceMeasurementFile: json['performance_measurement_file'],
      pub: json['pub'],
      shrink: json['shrink'],
      splitDebugInfo: json['split_debug_info'],
      splitPerAbi: json['split_per_abi'],
      target: json['target'],
      targetPlatform: json['target_platform'],
      trackWidgetCreation: json['track_widget_creation'],
      treeShakeIcons: json['tree_shake_icons'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['build_name'] = this.buildName;
    data['build_number'] = this.buildNumber;
    data['build_type'] = this.buildType;
    data['dart_define'] = this.dartDefine;
    data['export_type'] = this.exportType;
    data['flavor'] = this.flavor;
    data['obfuscate'] = this.obfuscate;
    data['performance_measurement_file'] = this.performanceMeasurementFile;
    data['pub'] = this.pub;
    data['shrink'] = this.shrink;
    data['split_debug_info'] = this.splitDebugInfo;
    data['split_per_abi'] = this.splitPerAbi;
    data['target'] = this.target;
    data['target_platform'] = this.targetPlatform;
    data['track_widget_creation'] = this.trackWidgetCreation;
    data['tree_shake_icons'] = this.treeShakeIcons;
    return data;
  }
}

class IosBuildConfig extends BuildConfig {
  bool codesign;
  ExportOptions exportOptions;
  bool simulator;

  IosBuildConfig({
    String buildName,
    String buildNumber,
    String buildType,
    String dartDefine,
    String exportType,
    String flavor,
    bool obfuscate,
    String performanceMeasurementFile,
    bool pub,
    this.codesign,
    this.exportOptions,
    String splitDebugInfo,
    String target,
    this.simulator,
    bool treeShakeIcons,
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

  factory IosBuildConfig.fromJson(Map<String, dynamic> json) {
    return IosBuildConfig(
      buildName: json['build_name'],
      buildNumber: json['build_number'],
      buildType: json['build_type'],
      codesign: json['codesign'],
      dartDefine: json['dart_define'],
      exportOptions: json['export_options'] != null ? ExportOptions.fromJson(json['export_options']) : null,
      exportType: json['export_type'],
      flavor: json['flavor'],
      obfuscate: json['obfuscate'],
      performanceMeasurementFile: json['performance_measurement_file'],
      pub: json['pub'],
      simulator: json['simulator'],
      splitDebugInfo: json['split_debug_info'],
      target: json['target'],
      treeShakeIcons: json['tree_shake_icons'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['build_name'] = this.buildName;
    data['build_number'] = this.buildNumber;
    data['build_type'] = this.buildType;
    data['codesign'] = this.codesign;
    data['dart_define'] = this.dartDefine;
    data['export_type'] = this.exportType;
    data['flavor'] = this.flavor;
    data['obfuscate'] = this.obfuscate;
    data['performance_measurement_file'] = this.performanceMeasurementFile;
    data['pub'] = this.pub;
    data['simulator'] = this.simulator;
    data['split_debug_info'] = this.splitDebugInfo;
    data['target'] = this.target;
    data['tree_shake_icons'] = this.treeShakeIcons;
    if (this.exportOptions != null) {
      data['export_options'] = this.exportOptions.toJson();
    }
    return data;
  }
}

class ExportOptions {
  String debug;
  String release;

  ExportOptions({
    this.debug,
    this.release,
  });

  factory ExportOptions.fromJson(Map<String, dynamic> json) {
    return ExportOptions(
      debug: json['debug'],
      release: json['release'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['debug'] = this.debug;
    data['release'] = this.release;
    return data;
  }
}

class AppStoreConfig {
  String apiIssuer;
  String apiKey;
  String appleId;
  String outputFormat;
  String type;

  AppStoreConfig({
    this.apiIssuer,
    this.apiKey,
    this.appleId,
    this.outputFormat,
    this.type,
  });

  factory AppStoreConfig.fromJson(Map<String, dynamic> json) {
    return AppStoreConfig(
      apiIssuer: json['api_issuer'],
      apiKey: json['api_key'],
      appleId: json['apple_id'],
      outputFormat: json['output_format'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['api_issuer'] = this.apiIssuer;
    data['api_key'] = this.apiKey;
    data['apple_id'] = this.appleId;
    data['output_format'] = this.outputFormat;
    data['type'] = this.type;
    return data;
  }
}

class PgyConfig {
  String apiKey;
  String androidAppKey;
  String buildChannelShortcut;
  int buildInstallDate;
  String buildInstallEndDate;
  String buildInstallStartDate;
  int buildInstallType;
  String buildName;
  String buildPassword;
  String buildUpdateDescription;
  String iosAppKey;
  String url;
  String userKey;

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

  factory PgyConfig.fromJson(Map<String, dynamic> json) {
    return PgyConfig(
      apiKey: json['_api_key'],
      androidAppKey: json['apk_app_key'],
      buildChannelShortcut: json['build_channel_shortcut'],
      buildInstallDate: json['build_install_date'],
      buildInstallEndDate: json['build_install_end_date'],
      buildInstallStartDate: json['build_install_start_date'],
      buildInstallType: json['build_install_type'],
      buildName: json['build_name'],
      buildPassword: json['build_password'],
      buildUpdateDescription: json['build_update_description'],
      iosAppKey: json['ios_app_key'],
      url: json['url'],
      userKey: json['user_key'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_api_key'] = this.apiKey;
    data['apk_app_key'] = this.androidAppKey;
    data['build_channel_shortcut'] = this.buildChannelShortcut;
    data['build_install_date'] = this.buildInstallDate;
    data['build_install_end_date'] = this.buildInstallEndDate;
    data['build_install_start_date'] = this.buildInstallStartDate;
    data['build_install_type'] = this.buildInstallType;
    data['build_name'] = this.buildName;
    data['build_password'] = this.buildPassword;
    data['build_update_description'] = this.buildUpdateDescription;
    data['ios_app_key'] = this.iosAppKey;
    data['url'] = this.url;
    data['user_key'] = this.userKey;
    return data;
  }
}

class DingtalkConfig {
  String accessKey;
  List<String> atDingtalkIds;
  List<String> atMobiles;
  bool isAtAll;
  bool isAutoAt;
  String secret;
  String title;
  String url;

  DingtalkConfig({
    this.accessKey,
    this.atDingtalkIds,
    this.atMobiles,
    this.isAtAll,
    this.isAutoAt,
    this.secret,
    this.title,
    this.url,
  });

  factory DingtalkConfig.fromJson(Map<String, dynamic> json) {
    return DingtalkConfig(
      accessKey: json['access_key'],
      atDingtalkIds: json['at_dingtalk_ids'] != null ? List<String>.from(json['at_dingtalk_ids']) : null,
      atMobiles: json['at_mobiles'] != null ? List<String>.from(json['at_mobiles']) : null,
      isAtAll: json['is_at_all'],
      isAutoAt: json['is_auto_at'],
      secret: json['secret'],
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['access_key'] = this.accessKey;
    data['is_at_all'] = this.isAtAll;
    data['is_auto_at'] = this.isAutoAt;
    data['secret'] = this.secret;
    data['title'] = this.title;
    data['url'] = this.url;
    if (this.atDingtalkIds != null) {
      data['at_dingtalk_ids'] = this.atDingtalkIds;
    }
    if (this.atMobiles != null) {
      data['at_mobiles'] = this.atMobiles;
    }
    return data;
  }
}
