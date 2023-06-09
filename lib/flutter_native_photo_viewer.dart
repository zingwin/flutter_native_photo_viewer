import 'package:flutter/services.dart';

import 'flutter_native_photo_viewer_method_channel.dart';
import 'flutter_native_photo_viewer_platform_interface.dart';

class FlutterNativePhotoViewer {
  Future<String?> getPlatformVersion() {
    return FlutterNativePhotoViewerPlatform.instance.getPlatformVersion();
  }

  Future<String?> showGallery(List<PhotoItemData> list,
      {int initialIndex = 0}) {
    return FlutterNativePhotoViewerPlatform.instance
        .showGallery(list, initialIndex: initialIndex);
  }

  MethodChannel curMethodChannel() {
    return FlutterNativePhotoViewerPlatform.instance.curMethodChannel();
  }

  Future<void> hide() {
    return FlutterNativePhotoViewerPlatform.instance.hide();
  }
}
