// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';
import 'package:package_info_plus/src/package_info_plus_web.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:video_player_web_hls/video_player_web_hls.dart';
import 'package:wakelock_plus/src/wakelock_plus_web_plugin.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  FlutterSecureStorageWeb.registerWith(registrar);
  PackageInfoPlusWebPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  VideoPlayerPluginHls.registerWith(registrar);
  WakelockPlusWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
