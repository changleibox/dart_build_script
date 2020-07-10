enum BuildPlatform {
  /// Build a repository containing an AAR and a POM file.
  aar,

  /// Build an Android APK file from your app.
  apk,

  /// Build an Android App Bundle file from your app.
  appbundle,

  /// Build the Flutter assets directory from your app.
  bundle,

  /// Build an iOS application bundle (Mac OS X host only).
  ios,

  /// Produces a .framework directory for a Flutter module and its plugins for integration into existing,
  /// plain Xcode projects.
  iosFramework,

  /// Build a macOS desktop application.
  macos,

  /// Build a web application bundle.
  web,
}

String getBuildPlatformLabel(BuildPlatform platform) {
  switch (platform) {
    case BuildPlatform.aar:
      return 'aar';
      break;
    case BuildPlatform.apk:
      return 'apk';
      break;
    case BuildPlatform.appbundle:
      return 'appbundle';
      break;
    case BuildPlatform.bundle:
      return 'bundle';
      break;
    case BuildPlatform.ios:
      return 'ios';
      break;
    case BuildPlatform.iosFramework:
      return 'ios-framework';
      break;
    case BuildPlatform.macos:
      return 'macos';
      break;
    case BuildPlatform.web:
      return 'web';
      break;
  }
  assert(false, '未定义的platform：$platform');
  return null;
}
