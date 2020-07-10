enum InstallType {
  public,
  password,
  invite,
}

InstallType convertInstallType(int value) {
  switch (value) {
    case 1:
      return InstallType.public;
      break;
    case 2:
      return InstallType.password;
      break;
    case 3:
      return InstallType.invite;
      break;
  }
  assert(false, '不支持的安装类型');
  return null;
}

int getInstallTypeValue(InstallType installType) {
  switch (installType) {
    case InstallType.public:
      return 1;
      break;
    case InstallType.password:
      return 2;
      break;
    case InstallType.invite:
      return 3;
      break;
  }
  assert(false, '未知的安装类型');
  return null;
}
