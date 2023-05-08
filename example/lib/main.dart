import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer_method_channel.dart';
import 'package:flutter_native_photo_viewer/flutter_native_photo_viewer_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _photoViewerPlugin = FlutterNativePhotoViewer();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _photoViewerPlugin.curMethodChannel().setMethodCallHandler(null);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _photoViewerPlugin
        .curMethodChannel()
        .setMethodCallHandler((MethodCall call) async {
      if (call.method == "pin_message") {
        final argu = call.arguments as Map;
        final index = argu['index'];
        print("定位到图片索引： $index");
      } else if (call.method == "scan_result") {
        final arg = call.arguments as Map;
        final qr_context = arg['qr_context'];
        print("二维码信息： $qr_context");
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _photoViewerPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
                onPressed: () {
                  List<PhotoItemData> list = <PhotoItemData>[
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/d946e9ae21e2dadd3342baf5381bb41c.png",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/113eaecc35d62c5d61d77020ed767b97.jpg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/51721fa09d7e2eb609adc4286c278766.png",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/9a61840fbbcf766b15f8601b66b9d63c.jpeg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/af2a3b26c0a3c30e4cd9f22c3752ae05.gif",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/d79e1eadaf7145e9369a9b5b6bb13565.jpg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/71383d264c2d2c921c1d2553d4e4d4ce.jpg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/d79e1eadaf7145e9369a9b5b6bb13565.jpg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "https://fanbook-video-test-1251001060.file.myqcloud.com/fanbook/app/files/chatroom/video/f10ec6dbebcd095ee0a90fefc7760378.mp4",
                        isImage: false),
                    PhotoItemData(
                        url:
                            "https://fb-cdn.fanbook.mobi/fanbook/app/files/chatroom/image/af97828d9e7d84c338c8402589f4084f.jpg",
                        isImage: true),
                    PhotoItemData(
                        url:
                            "http://fanbook-1251001060.cos.accelerate.myqcloud.com/fanbook/app/files/chatroom/image/c11819334eebd376790cc7a8adea308e.jpg",
                        isImage: true)
                  ];

                  _photoViewerPlugin.showGallery(list);
                },
                child: Text("图片浏览"))
          ],
        ),
      ),
    );
  }
}
