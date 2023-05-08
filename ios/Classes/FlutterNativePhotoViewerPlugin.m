#import "FlutterNativePhotoViewerPlugin.h"

#import "YBImageBrowser.h"
#import "YBIBVideoData.h"


@interface FlutterNativePhotoViewerPlugin()  <YBImageBrowserDelegate>
@property(nonatomic,strong) FlutterMethodChannel *curChannel;
@property(nonatomic,strong) YBImageBrowser *browser;
@end

@implementation FlutterNativePhotoViewerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_native_photo_viewer"
            binaryMessenger:[registrar messenger]];
  FlutterNativePhotoViewerPlugin* instance = [[FlutterNativePhotoViewerPlugin alloc] init];
  instance.curChannel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"hide" isEqualToString:call.method]){
      [self.browser hide];
  } else if ([@"showGallery" isEqualToString:call.method]) {

      NSMutableArray *datas = [NSMutableArray array];
      NSDictionary *argu =  call.arguments;
      NSInteger index = [[argu objectForKey:@"initialIndex"] intValue];
      NSArray *items = [argu objectForKey:@"items"];

      for(NSDictionary *item in items){
          bool isImage = [[item objectForKey:@"isImage"] boolValue];
          NSString *url = [item objectForKey:@"url"];
          NSString *filePath = [item objectForKey:@"filePath"];
          NSString *holderUrl = [item objectForKey:@"holderUrl"];
          NSString *thumbWidth = [item objectForKey:@"thumbWidth"];
          NSString *thumbHeight = [item objectForKey:@"thumbHeight"];
          NSString *imageWidth = [item objectForKey:@"imageWidth"];
          NSString *imageHeight = [item objectForKey:@"imageHeight"];

          if(isImage){
              if(filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                  //本地图片
                YBIBImageData *data = [YBIBImageData new];
                  data.imageURL = [NSURL fileURLWithPath:filePath];
                [datas addObject:data];
              }else{
                  YBIBImageData *data = [YBIBImageData new];
                  data.imageURL = [NSURL URLWithString:url];
    //              data.shouldPreDecodeAsync = YES;
    //              data.imageName = @"打发舒服";
                  //data.projectiveView = [self viewAtIndex:idx];
                  [datas addObject:data];
              }
          }else{
              if(filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                YBIBVideoData *data = [YBIBVideoData new];
                data.videoURL = [NSURL fileURLWithPath:filePath];
                [datas addObject:data];
              }else{
                  YBIBVideoData *data = [YBIBVideoData new];
                  data.videoURL = [NSURL URLWithString:url];
                  [datas addObject:data];
              }
          }

      }

      self.browser = [YBImageBrowser new];
      self.browser.dataSourceArray = datas;
      self.browser.currentPage = index;
//      browser.supportedOrientations = UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
      // 只有一个保存操作的时候，可以直接右上角显示保存按钮
      self.browser.defaultToolViewHandler.topView.operationType = -1;//YBIBTopViewOperationTypeMore;
      self.browser.delegate = self;
      [self.browser show];
      

      result(@"OK");
    }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser respondsToLongPressWithData:(id<YBIBDataProtocol>)data{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"标题" message:@"这是message" preferredStyle:UIAlertControllerStyleActionSheet];

    __weak typeof(self) weakSelf = self;

    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");

        [data yb_saveToPhotoAlbum];
    }];
    UIAlertAction *pin = [UIAlertAction actionWithTitle:@"定位到消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.curChannel invokeMethod:@"pin_message"
                                arguments:@{@"index": @(weakSelf.browser.currentPage)}];
        [weakSelf.browser hide];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
    }];

    if([data isKindOfClass: [YBIBImageData class] ]){
        YBIBImageData *d = (YBIBImageData*)data;

        CIContext *context = [[CIContext alloc] init];
          //创建探测器
          CIDetector *QRCodeDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
          //识别图片，获取特征

          CIImage *imgCI = [[CIImage alloc] initWithImage: d.originImage ];
          NSArray *features = [QRCodeDetector featuresInImage:imgCI];
        //判断是否识别到二维码
        if (features.count > 0) {
            //有二维码
            CIQRCodeFeature *qrcodeFeature = (CIQRCodeFeature *)features[0];

            UIAlertAction *dicern = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [weakSelf.curChannel invokeMethod:@"scan_result"
                                        arguments:@{@"qr_context": qrcodeFeature.messageString}];
                [weakSelf.browser hide];
                
                NSLog(@"二维码信息： %@", qrcodeFeature.messageString);

            }];
            [sheet addAction:dicern];
        }
    }

    [sheet addAction:sure];
    [sheet addAction:pin];
    [sheet addAction:cancel];

    //show
    [[[self class] topMostController] presentViewController:sheet animated:YES completion:nil];
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}
@end
