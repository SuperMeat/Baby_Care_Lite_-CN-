//
//  LookingForDeviceViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "LookingForDeviceViewController.h"

@interface LookingForDeviceViewController ()
{
    UartLib *uartLib;
    CBPeripheral	*connectPeripheral;
}
@end

@implementation LookingForDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //判断搜索硬件类别
    _deviceId = 0;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    _bleController = [[BLEController alloc]init];
    _bleController.bleControllerDelegate = self;
    
    [self startScanDevice];
}

-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals{
    if (!result) {
        isTimeOut=YES;
    }
    else{
        peripherals=foundPeripherals;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"搜索到" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [alert show];
    }
}

-(void)startScanDevice
{
    //根据设备id加载背景图
    _imageView.image = [UIImage imageNamed:@"lookingDevice.jpg"];
    if (_deviceId==0) {
        //_imageView.image = [UIImage imageNamed:@"lookingDevice.jpg"];
    }
    else if (_deviceId==1){
        //
    }
    [self.view addSubview:_imageView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    isTimeOut=NO;
    [_bleController startscan];
}

-(void)reScanDevice
{
    [_buttonRescan removeFromSuperview];
    [self startScanDevice];
}

-(void)timeGo
{
    if (isTimeOut) {
        [self scanFail];
        [timer invalidate];
    }
}

-(void)scanFail
{
    [_bleController stopscan];
    _imageView.image = [UIImage imageNamed:@"scanfail_1.jpg"];
    _buttonRescan = [[UIButton alloc]initWithFrame:CGRectMake(100, 360, 120, 24)];
    [_buttonRescan setTitle:@"重新搜寻" forState:UIControlStateNormal];
    [self.view addSubview:_buttonRescan];
}

#pragma UIAlert protocol
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (peripherals == nil) {
        return;
    }
    if (buttonIndex==0) {
        //活动信息设备绑定
        if (_deviceId==0) {
            [[NSUserDefaults standardUserDefaults] setObject:[[peripherals objectAtIndex:0] name] forKey:@"BLEPERIPHERAL_ACTIVITY"];
        }
        //else if 其他设备绑定 BLEPERIPHERAL_ENVIRONMENT
    }
    else if (buttonIndex==1){
        
    }
}


#pragma sys
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
