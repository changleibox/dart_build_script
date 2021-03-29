/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

/// 蒲公英安装类型
enum InstallType {
  /// 公共
  public,

  /// 需要密码
  password,

  /// 邀请才能安装
  invite,
}

/// 转换
InstallType? convertInstallType(int value) {
  switch (value) {
    case 1:
      return InstallType.public;
    case 2:
      return InstallType.password;
    case 3:
      return InstallType.invite;
  }
  assert(false, '不支持的安装类型');
  return null;
}

/// 转换
int getInstallTypeValue(InstallType installType) {
  switch (installType) {
    case InstallType.public:
      return 1;
    case InstallType.password:
      return 2;
    case InstallType.invite:
      return 3;
  }
}
