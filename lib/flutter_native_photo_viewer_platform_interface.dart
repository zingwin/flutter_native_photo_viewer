import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_native_photo_viewer_method_channel.dart';

abstract class FlutterNativePhotoViewerPlatform extends PlatformInterface {
  /// Constructs a FlutterNativePhotoViewerPlatform.
  FlutterNativePhotoViewerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNativePhotoViewerPlatform _instance =
      MethodChannelFlutterNativePhotoViewer();

  /// The default instance of [FlutterNativePhotoViewerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNativePhotoViewer].
  static FlutterNativePhotoViewerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNativePhotoViewerPlatform] when
  /// they register themselves.
  static set instance(FlutterNativePhotoViewerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> showGallery(List<PhotoItemData> list, {int initialIndex = 0});

  MethodChannel curMethodChannel();

  Future<void> hide();
}
