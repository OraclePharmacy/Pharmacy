//
//  YdScanViewController.h
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface YdScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property(strong , nonatomic)AVCaptureSession *session;
@property (strong , nonatomic)AVCaptureVideoPreviewLayer*previewLayer;

@property (strong,nonatomic) NSString *str;
@property (strong, nonatomic) NSString *objecct;
@end
