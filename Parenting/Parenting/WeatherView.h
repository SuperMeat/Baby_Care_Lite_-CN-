//
//  WeatherView.h
//  Parenting
//
//  Created by user on 13-5-30.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@class AdviseData;
@class AdviseLevel;
@interface WeatherView : UIView <UITableViewDataSource,UITableViewDelegate,BLEControllerDelegate>
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
    
    BOOL isbluetooth;
    BOOL isFistTime;
    BOOL isBLEConnected;
    NSTimer *timer;
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
@end
