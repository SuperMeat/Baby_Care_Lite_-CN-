//
//  BLEWeatherView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@class AdviseData;
@class AdviseLevel;
@interface BLEWeatherView : UIView<UITableViewDataSource,UITableViewDelegate,BLEControllerDelegate>
{
    BOOL         isgetted;
    UITableView *table;
    NSString    *tempcontent;
    int          templevel;
    //温度建议
    AdviseData  *mAdTemp;
    AdviseLevel *mAlTemp;
    
    //湿度建议
    AdviseData  *mAdHumi;
    AdviseLevel *mAlHumi;
    
    //bluetooth data
    short errorCode;
    short dataLength;
    long humidityHigh;
    long humidityLow;
    long humidity;
    long temperatureHigh;
    long temperatureLow;
    long temperature;
    
    //light
    long lowlightChannel0;
    long highlightChannel0;
    long lowlightChannel1;
    long highlightChannel1;
    long CH0;
    long CH1;
    double curlux;
    
    //uv
    long lowuv;
    long highuv;
    long adcoutput;
    short uvvalue;
    
    //microphone
    long lowphone;
    long highphone;
    long phonevalue;
    double phonethrans;
    long lowmaxphone;
    long highmaxphone;
    double maxphonethrans;
    
    BOOL isTimeOut;
    BOOL isFound;
    BOOL isFistTime;
    BOOL isBLEConnected;
    int  getindex;
    NSTimer *checktimer;
    NSTimer *gettimer;
    NSTimeInterval getDataTimeInterval;
}
+(id)weatherview;
@property (nonatomic,strong)  NSMutableArray  *dataarray;
@property (nonatomic, weak )id delete;
@property (strong, nonatomic) BLEController *blecontroller;
@property int chooseType;
-(void)makeview;
-(void)refreshweather;
-(void)setbluetooth;
-(void)checkbluetooth;
@end
