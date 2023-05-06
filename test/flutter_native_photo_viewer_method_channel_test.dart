import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer_method_channel.dart';

void main() {
  MethodChannelFlutterNativePhotoViewer platform = MethodChannelFlutterNativePhotoViewer();
  const MethodChannel channel = MethodChannel('flutter_native_photo_viewer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
