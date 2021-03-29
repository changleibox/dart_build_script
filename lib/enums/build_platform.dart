enum BuildPlatform {
  /// Build a repository containing an AAR and a POM file.
  aar,

  /// Build an Android APK file from your app.
  apk,

  /// Build an Android App Bundle file from your app.
  appBundle,

  /// Build the Flutter assets directory from your app.
  bundle,

  /// Build an iOS application bundle (Mac OS X host only).
  ios,

  /// Produces a .framework directory for a Flutter module and its plugins for integration into existing,
  /// plain Xcode projects.
  iosFramework,

  /// Build a macOS desktop application.
  macOS,

  /// Build a web application bundle.
  web,
}

String getBuildPlatformLabel(BuildPlatform platform) {
  switch (platform) {
    case BuildPlatform.aar:
      return 'aar';
    case BuildPlatform.apk:
      return 'apk';
    case BuildPlatform.appBundle:
      return 'appbundle';
    case BuildPlatform.bundle:
      return 'bundle';
    case BuildPlatform.ios:
      return 'ios';
    case BuildPlatform.iosFramework:
      return 'ios-framework';
    case BuildPlatform.macOS:
      return 'macos';
    case BuildPlatform.web:
      return 'web';
  }
}
