import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer_platform_interface.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNativePhotoViewerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNativePhotoViewerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> showGallery(List<PhotoItemData> list,
      {int initialIndex = 0}) {
    // TODO: implement showGallery
    throw UnimplementedError();
  }
}

void main() {
  final FlutterNativePhotoViewerPlatform initialPlatform =
      FlutterNativePhotoViewerPlatform.instance;

  test('$MethodChannelFlutterNativePhotoViewer is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterNativePhotoViewer>());
  });

  test('getPlatformVersion', () async {
    FlutterNativePhotoViewer flutterNativePhotoViewerPlugin =
        FlutterNativePhotoViewer();
    MockFlutterNativePhotoViewerPlatform fakePlatform =
        MockFlutterNativePhotoViewerPlatform();
    FlutterNativePhotoViewerPlatform.instance = fakePlatform;

    expect(await flutterNativePhotoViewerPlugin.getPlatformVersion(), '42');
  });
}
