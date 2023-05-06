import 'flutter_native_photo_viewer_method_channel.dart';
import 'flutter_native_photo_viewer_platform_interface.dart';

class FlutterNativePhotoViewer {
  Future<String?> getPlatformVersion() {
    return FlutterNativePhotoViewerPlatform.instance.getPlatformVersion();
  }

  Future<String?> showGallery(List<PhotoItemData> list) {
    return FlutterNativePhotoViewerPlatform.instance.showGallery(list);
  }
}
