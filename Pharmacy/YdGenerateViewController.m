//
//  YdGenerateViewController.m
//  Pharmacy
//
//  Created by suokun on 16/3/17.
//  Copyright © 2016年 sk. All rights reserved.
//

#import "YdGenerateViewController.h"
#import "YdScanViewController.h"

@interface YdGenerateViewController ()
@property (weak, nonatomic) NSString * code;
@property (weak, nonatomic) IBOutlet UIView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UIView *qrCodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *tiaoma;
@property (weak, nonatomic) IBOutlet UIImageView *erma;
@property (weak, nonatomic) IBOutlet UILabel *lable;

@end

@implementation YdGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //状态栏名称
    self.navigationItem.title = @"我的会员码";
    //设置self.view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"@3x_xx_06.png"] style:UIBarButtonItemStyleDone target:self action:@selector(fanhui)];
    
    /**
     *  设置条形码和二维码
     */
    _tiaoma.userInteractionEnabled = YES;
    _erma.userInteractionEnabled = YES;
    
    
    [self loadQRCodeAndBarCode];
    
    
}
- (void)loadQRCodeAndBarCode {

    __weak YdGenerateViewController *weakSelf = self;
  
    [weakSelf loadDataFromService];

}
- (void)loadDataFromService {
    
    __weak YdGenerateViewController *weakSelf = self;
    
    weakSelf.code=_haha;
    
    weakSelf.lable.text=[weakSelf formatCode:_haha];
    
    // 生成条形码
    weakSelf.tiaoma.image = [self generateBarCode:weakSelf.code width:weakSelf.tiaoma.frame.size.width height:weakSelf.barCodeImageView.frame.size.height];
    
    // 生成二维码
    weakSelf.erma.image = [self generateQRCode:weakSelf.code width:weakSelf.erma.frame.size.width height:weakSelf.qrCodeImageView.frame.size.height];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    
}
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [_code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}


- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [_code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
- (NSString *)formatCode:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}
- (IBAction)Jump:(id)sender {
    
    //返回上一页
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fanhui
{
    //返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
