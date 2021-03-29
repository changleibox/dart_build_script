enum InstallType {
  public,
  password,
  invite,
}

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
