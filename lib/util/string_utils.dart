/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

/// 首字母转成大写
String? capitalize(String? s) {
  if (s == null || s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}
