import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_native_photo_viewer_platform_interface.dart';

class PhotoItemData {
  final String? id;
  // final String? resource;
  final String? filePath;
  final String? url;
  final String? holderUrl;
  final double? thumbWidth;
  final double? thumbHeight;
  final String? identifier;
  final bool isImage;
  final bool isInView; // 是否显示在页面中，来判断是否需要显示hero动画
  final int? imageWidth;
  final int? imageHeight;

  PhotoItemData(
      {this.id,
      this.filePath,
      this.url,
      this.holderUrl,
      this.thumbWidth,
      this.thumbHeight,
      this.identifier,
      this.isImage = true,
      this.isInView = false,
      this.imageWidth,
      this.imageHeight});

  // PhotoItemData.fromJson(Map<String, dynamic> json) {
  //   return PhotoItemData()
  //     ..id = json['id']
  //     ..filePath = json['filePath']
  //     ..url = json['url']
  //     ..holderUrl = json['holderUrl']
  //     ..thumbWidth = json['thumbWidth']
  //     ..thumbHeight = json['thumbHeight']
  //     ..isImage = json['isImage']
  //     ..isInView = json['isInView'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filePath'] = filePath;
    data['url'] = url;
    data['holderUrl'] = holderUrl;
    data['thumbWidth'] = thumbWidth;
    data['thumbHeight'] = thumbHeight;
    data['identifier'] = identifier;
    data['isImage'] = isImage;
    data['isInView'] = isInView;
    data['imageWidth'] = imageWidth;
    data['imageHeight'] = imageHeight;
    return data;
  }
}

/// An implementation of [FlutterNativePhotoViewerPlatform] that uses method channels.
class MethodChannelFlutterNativePhotoViewer
    extends FlutterNativePhotoViewerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_native_photo_viewer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> showGallery(List<PhotoItemData> list,
      {int initialIndex = 0}) async {
    await methodChannel.invokeMethod<String?>('showGallery', {
      "items": list.map((e) => e.toJson()).toList(),
      "initialIndex": initialIndex,
    });
    return null;
  }

  @override
  MethodChannel curMethodChannel() {
    return methodChannel;
  }

  @override
  Future<void> hide() async {
    await methodChannel.invokeMethod<String?>('hide');
  }
}
