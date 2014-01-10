//
//  BLEWeatherView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BLEWeatherView.h"
#import "Environmentitem.h"
#import "EnvironmentAdviceDataBase.h"
#import "WeatherAdviseViewController.h"
@implementation BLEWeatherView
@synthesize dataarray;
+(id)weatherview
{
    
    __strong static WeatherView *_sharedObject = nil;
    
    _sharedObject =  [[self alloc] init]; // or some other init metho
    
    return _sharedObject;
}

-(id)init
{
    self=[super init];
    if (self){
        self.frame = CGRectMake(0, 0, 320, 200);
        
        //        self.backgroundColor=[UIColor redColor];
    }
    return self;
}

-(void)makeview
{
    [self makeView];
}

-(void)checkbluetooth
{
    if (!isBLEConnected) {
        isFistTime = YES;
        isTimeOut = NO;
        isFound = NO;
        checktimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
        [self.blecontroller startscan];
    }
    else
    {
        NSLog(@"ble is connected!");
    }
}

-(void)setbluetooth
{
    self.blecontroller = [[BLEController alloc] init];
    self.blecontroller.bleControllerDelegate = self;
    getDataTimeInterval = 1.0;
    
    [self checkbluetooth];
}

-(void)timeGo
{
    if (isTimeOut && !isFound) {
        //连接失败,提醒距离
        [self.blecontroller stopscan];
        [checktimer invalidate];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"同步失败,请确定\n①手机蓝牙已开启\n②配件已开启并在手机附近" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        isFound = NO;
    }
}

-(void)makeView
{
    dataarray =[[NSMutableArray alloc]init];
    Environmentitem *temp = [[Environmentitem alloc]init];
    Environmentitem *humi = [[Environmentitem alloc]init];
    Environmentitem *light= [[Environmentitem alloc]init];
    Environmentitem *sound= [[Environmentitem alloc]init];
    Environmentitem *pm   = [[Environmentitem alloc]init];
    Environmentitem *uv   = [[Environmentitem alloc]init];
    
    temp.tag  = 1;
    humi.tag  = 2;
    light.tag = 3;
    sound.tag = 4;
    pm.tag    = 5;
    uv.tag    = 6;
    
    temp.title=NSLocalizedString(@"Temperature",nil);
    humi.title=NSLocalizedString(@"Humidity",nil);
    light.title=NSLocalizedString(@"Light",nil);
    sound.title=NSLocalizedString(@"Sound",nil);
    pm.title=NSLocalizedString(@"PM2.5",nil);
    uv.title=NSLocalizedString(@"UV",nil);
    
    temp.headimage=[UIImage imageNamed:@"icon_temperature.png"];
    humi.headimage=[UIImage imageNamed:@"icon_humidity.png"];
    light.headimage=[UIImage imageNamed:@"icon_light.png"];
    sound.headimage=[UIImage imageNamed:@"icon_sound.png"];
    pm.headimage=[UIImage imageNamed:@"icon_pm2.5.png"];
    uv.headimage=[UIImage imageNamed:@"icon_uv.png"];
    
    dataarray=[[NSMutableArray alloc]initWithCapacity:0];
    [dataarray addObject:temp];
    [dataarray addObject:humi];
    
    if (CUSTOMER_COUNTRY == 0)
    {
        [dataarray addObject:uv];
    }
    else
    {
        [dataarray addObject:light];
        [dataarray addObject:sound];
        [dataarray addObject:uv];
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(self.bounds.origin.x+10, self.bounds.origin.y+8, self.bounds.size.width-20, self.bounds.size.height) style:UITableViewStyleGrouped];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor=[UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView=nil;
    table.bounces=NO;
    
    [self setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    [self addSubview:table];
    
    //[[BLEWeather bleweather] getbleweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=[[BLEWeather bleweather] getbleweather];
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            temperature = [BLEWeather gettemperature];
        }
        
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"humidity"]];
            humidity   = [BLEWeather gethumidity];
        }
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
            curlux   = [BLEWeather getlight];
        }
        
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
            phonethrans = [BLEWeather getsound];
        }
        
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
            uvvalue   = [BLEWeather getuv];
        }
        
        
        [dataarray replaceObjectAtIndex:0 withObject:temp];
        [dataarray replaceObjectAtIndex:1 withObject:humi];
        [dataarray replaceObjectAtIndex:2 withObject:light];
        [dataarray replaceObjectAtIndex:3 withObject:sound];
        [dataarray replaceObjectAtIndex:4 withObject:uv];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
   // }];
}

-(void)refreshweather
{
    mAlTemp.mAdviseId = 0;
    mAlHumi.mAdviseId = 0;
    [self updatebledataarray];
}

-(void)updatebledataarray
{
    Environmentitem *temp=[[Environmentitem alloc]init];
    Environmentitem *humi=[[Environmentitem alloc]init];
    Environmentitem *light=[[Environmentitem alloc]init];
    Environmentitem *sound=[[Environmentitem alloc]init];
    //Environmentitem *pm=[[Environmentitem alloc]init];
    Environmentitem *uv=[[Environmentitem alloc]init];
    
  //  [[BLEWeather bleweather] getbleweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=[[BLEWeather bleweather]getbleweather];
        NSLog(@"weDic %@", dict);
        
        if([[dict objectForKey:@"temp"] length]>0)
        {
            temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
            NSArray *arr;
            switch (self.chooseType) {
                case QCM_TYPE_BATH:
                    arr = [EnvironmentAdviceDataBase selectBathSuggestionByTemp:[[dict objectForKey:@"temp"] intValue]];
                    break;
                case QCM_TYPE_DIAPER:
                    arr = [EnvironmentAdviceDataBase selectDiaperSuggestionByTemp:[[dict objectForKey:@"temp"] intValue]];
                    break;
                case QCM_TYPE_FEED:
                    arr = [EnvironmentAdviceDataBase selectFeedSuggestionByTemp:[[dict objectForKey:@"temp"] intValue]];
                    break;
                case QCM_TYPE_SLEEP:
                    arr = [EnvironmentAdviceDataBase selectSleepSuggestionByTemp:[[dict objectForKey:@"temp"] intValue]];
                    break;
                case QCM_TYPE_PLAY:
                    arr = [EnvironmentAdviceDataBase selectPlaySuggestionByTemp:[[dict objectForKey:@"temp"] intValue]];
                    break;
                default:
                    break;
            }
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDataBase selectsuggestiontemp:al.mAdviseId];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    tempcontent = ad.mContent;
                    templevel   = al.mLevel;
                    mAdTemp = ad;
                    mAlTemp = al;
                }
            }
            
        }
        
        if ([[dict objectForKey:@"humidity"] length]>0) {
            humi.detail=[NSString stringWithFormat:@"%@ %%",[dict objectForKey:@"humidity"]];
            NSArray *arr;
            switch (self.chooseType) {
                case QCM_TYPE_BATH:
                    arr = [EnvironmentAdviceDataBase selectBathSuggestionByHumi:[[dict objectForKey:@"humidity"] intValue]];
                    break;
                case QCM_TYPE_DIAPER:
                    arr = [EnvironmentAdviceDataBase selectDiaperSuggestionByHumi:[[dict objectForKey:@"humidity"] intValue]];
                    break;
                case QCM_TYPE_FEED:
                    arr = [EnvironmentAdviceDataBase selectFeedSuggestionByHumi:[[dict objectForKey:@"humidity"] intValue]];
                    break;
                case QCM_TYPE_SLEEP:
                    arr = [EnvironmentAdviceDataBase selectSleepSuggestionByHumi:[[dict objectForKey:@"humidity"] intValue]];
                    break;
                case QCM_TYPE_PLAY:
                    arr = [EnvironmentAdviceDataBase selectPlaySuggestionByHumi:[[dict objectForKey:@"humidity"] intValue]];
                    break;
                default:
                    break;
            }
            
            if ([arr count]>0) {
                AdviseLevel *al = [arr objectAtIndex:0];
                NSArray *a2 = [EnvironmentAdviceDataBase selectsuggestionhumi:al.mAdviseId];
                if ([a2 count]>0) {
                    AdviseData* ad = [a2 objectAtIndex:0];
                    tempcontent = ad.mContent;
                    templevel   = al.mLevel;
                    mAdHumi = ad;
                    mAlHumi = al;
                }
            }
        }
        
        if ([[dict objectForKey:@"light"] length]>0) {
            light.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]];
        }
        
        if ([[dict objectForKey:@"maxsound"] length]>0) {
            sound.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]];
        }
        
        if ([[dict objectForKey:@"uv"] length]>0) {
            uv.detail=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]];
        }
        
        Environmentitem *itemTemp = [dataarray objectAtIndex:0];
        itemTemp.detail = temp.detail;
        [dataarray replaceObjectAtIndex:0 withObject:itemTemp];
        
        Environmentitem *itemHumi = [dataarray objectAtIndex:1];
        itemHumi.detail = humi.detail;
        [dataarray replaceObjectAtIndex:1 withObject:itemHumi];
        
        Environmentitem *itemLight = [dataarray objectAtIndex:2];
        itemLight.detail = light.detail;
        [dataarray replaceObjectAtIndex:2 withObject:itemLight];
        
        Environmentitem *itemSound = [dataarray objectAtIndex:3];
        itemSound.detail = sound.detail;
        [dataarray replaceObjectAtIndex:3 withObject:itemSound];
        
        Environmentitem *itemUV = [dataarray objectAtIndex:4];
        itemUV.detail = uv.detail;
        [dataarray replaceObjectAtIndex:4 withObject:itemUV];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
   // }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataarray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (Cell==nil) {
        Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        Cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_env.png"]];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(150, 2, 30, 30)];
        [Cell.contentView addSubview:image];
        Cell.backgroundColor = [UIColor clearColor];
        image.tag=104;
        Cell.textLabel.backgroundColor=[UIColor clearColor];
        Cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        Cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Cell.textLabel.textColor=[UIColor colorWithRed:0x76/255.0 green:0x72/255.0 blue:0x71/255.0 alpha:0xFF/255.0];
        Cell.textLabel.font=[UIFont systemFontOfSize:15];
        Cell.detailTextLabel.textColor=[UIColor whiteColor];
    }
    Environmentitem *item=[dataarray objectAtIndex:indexPath.section];
    Cell.imageView.image=item.headimage;
    
    Cell.textLabel.text=item.title;
    UIImageView *image=(UIImageView*)[Cell.contentView viewWithTag:104];
    
    if (item.detail.length>0) {
        Cell.detailTextLabel.text=item.detail;
        [Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
        image.image=[UIImage imageNamed:@"icon_connected.png"];
    }
    else
    {
        //Cell.detailTextLabel.text=@"_______";
        Cell.detailTextLabel.text=NSLocalizedString(@"WeatherDetail", nil);
        [Cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        image.image=[UIImage imageNamed:@"icon_notconnected.png"];
    }
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d,%d",indexPath.section, indexPath.row);
    if (indexPath.section == 0 && mAlTemp.mAdviseId > 0) {
        NSString *title;
        switch (mAlTemp.mLevel) {
            case 1:
                title = @"Excellent";
                break;
            case 2:
                title = @"Good";
                break;
            case 3:
                title = @"Bad";
                break;
            default:
                break;
        }
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:mAdTemp.mContent leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
    }
    
    if (indexPath.section == 1 && mAlHumi.mAdviseId > 0) {
        NSString *title;
        switch (mAlHumi.mLevel) {
            case 1:
                title = @"Excellent";
                break;
            case 2:
                title = @"Good";
                break;
            case 3:
                title = @"Bad";
                break;
            default:
                break;
        }
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:title contentText:mAdHumi.mContent leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
    }
}

#pragma -mark bluetooth delegate
-(void)BLEPowerOff:(BOOL)isPowerOff
{
    isBLEConnected = NO;
}

-(void)DidConnected:(BOOL)isConnected
{
    isBLEConnected = isConnected;
    [self sendData];
}

-(void)DisConnected:(BOOL)isConnected
{
    isBLEConnected = isConnected;
}

-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals
{
    if (!result) {
        isTimeOut=YES;
    }
    else
    {
        //Peripherals的名字跟配件名字匹配 如果不匹配还是提示错误
        if (!isFound) {
            //NSString *sysPeripheralsName =[[NSUserDefaults standardUserDefaults] objectForKey:@"BLEPERIPHERAL_ACTIVITY"];
            //if ([sysPeripheralsName isEqualToString:[[foundPeripherals objectAtIndex:0] name]])
            {
                //同步数据
                [checktimer invalidate];
                [self.blecontroller bleconnect];
            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"同步失败,请确定\n①手机蓝牙已开启\n②配件已开启并在手机附近" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }
            isFound = YES;
            [self.blecontroller stopscan];
        }
    }

}

-(void)RecvHumiAndTempDada:(NSData*)data
{
    NSString *hexStr=@"";
    
    Byte *hexData = (Byte *)[data bytes];
    errorCode = 0;
    for(int i = 0; i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        if (errorCode == 0)
        {
            ///16进制数
            if (i == 1) {
                humidityHigh = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 2)
            {
                humidityLow = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 3)
            {
                temperatureHigh = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 4)
            {
                temperatureLow = [BLEController hexStringToInt:newHexStr];
            }
            
            if (i == 5)
            {
                NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
                dateFormator.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
                NSString *date = [dateFormator stringFromDate:[NSDate date]];
                humidity    = ((humidityHigh+humidityLow) * 1.0 )/ 16383 * 100;
                temperature = ((temperatureHigh + temperatureLow) * 1.0 )/ 16383 / 4 * 165 - 40;
                hexStr = [NSString stringWithCString:[[NSString stringWithFormat:@"%@ 采集到的湿度:%ld %%, 温度:%ld !", date,humidity,temperature] UTF8String] encoding:NSUTF8StringEncoding];
                [BLEWeather setweatherfrombluetooth:temperature Humidity:humidity];
            }
        }
    }
    //[self.blecontroller getLight];
}

-(double)getlightluxwithCH0:(double)ch0 andCH1:(double)ch1
{
    double lux = 0.0f;
    int  rate  = ch1/ch0*100;
    if (rate < 52) {
        lux = (0.0315*ch0)-(0.0593*ch0*pow(ch1/ch0, 1.4));
    }
    else if (rate < 65)
    {
        lux = (0.0229*ch0) - (0.0291*ch1);
    }
    else if (rate < 80)
    {
        lux = (0.0157*ch0) - (0.0180*ch1);
    }
    else if (rate < 130)
    {
        lux = (0.00338*ch0) - (0.00260*ch1);
    }
    else
    {
        lux = 0;
    }
    return lux;
}

-(void)RecvLightData:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        if (errorCode == 0)
        {
            
            ///16进制数
            if (i == 1) {
                lowlightChannel0 = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 2)
            {
                highlightChannel0 = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 3)
            {
                lowlightChannel1  = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 4)
            {
                highlightChannel1 = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if ( 5 == i) {
                CH0 = lowlightChannel0 + highlightChannel0;
                CH1 = lowlightChannel1 + highlightChannel1;
            }
        }
    }
    
    curlux = [self getlightluxwithCH0:CH0*1.0 andCH1:CH1*1.0];
    [BLEWeather setlightfrombluetooth:curlux];
    //[self.blecontroller getMicrophone:0];
}

-(int)getuv:(float)output
{
    NSLog(@"getuv :%lf", output);
    int ret = 0;
    if (output < 1.04) {
        ret = 0;
    }
    else if (output < 1.12)
    {
        ret = 1;
    }
    else if (output < 1.20)
    {
        ret = 2;
    }
    else if (output < 1.28)
    {
        ret = 3;
    }
    else if (output < 1.36)
    {
        ret = 4;
    }
    else if (output < 1.44)
    {
        ret = 5;
    }
    else if (output < 1.52)
    {
        ret = 6;
    }
    else if (output < 1.60)
    {
        ret = 7;
    }
    else if (output < 1.68)
    {
        ret = 8;
    }
    else if (output < 1.76)
    {
        ret = 9;
    }
    else if (output < 1.84)
    {
        ret = 10;
    }
    else if (output < 1.92)
    {
        ret = 11;
    }
    else if (output < 2.00)
    {
        ret = 12;
    }
    else if (output < 2.08)
    {
        ret = 13;
    }
    else if (output < 2.16)
    {
        ret = 14;
    }
    else if (output < 2.24)
    {
        ret = 15;
    }
    else if (output < 2.32)
    {
        ret = 16;
    }
    else if (output < 2.40)
    {
        ret = 17;
    }
    else if (output < 2.48)
    {
        ret = 18;
    }
    else if (output < 2.56)
    {
        ret = 19;
    }
    else
    {
        ret = 20;
    }
    
    return ret;
}

-(void)RecvUVData:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        
        if (errorCode == 0)
        {
            
            //16进制数
            if (i == 1) {
                lowuv  = [BLEController hexStringToInt:newHexStr];
            }
            
            if (2 == i)
            {
                highuv = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (3 == i)
            {
                adcoutput = lowuv + highuv;
            }
            
        }
        
    }
    float adc_v = adcoutput/8192.0*3.32;
    
    uvvalue = [self getuv:adc_v];
    [BLEWeather setuvfrombluetooth:uvvalue];
}

-(void)RecvMicroPhone:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        
        if (errorCode == 0)
        {
            
            //16进制数
            if (i == 2) {
                highphone  = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (1 == i)
            {
                lowphone = [BLEController hexStringToInt:newHexStr];
            }
            
            if (3 == i) {
                lowmaxphone = [BLEController hexStringToInt:newHexStr];
            }
            
            if (4 == i) {
                highmaxphone = [BLEController hexStringHighToInt:newHexStr];
            }

            
            if (3 == i)
            {
                phonevalue     = lowphone + highphone;
                //maxphonethrans = 20.0*log10((lowmaxphone + highmaxphone)*1.0/600.0);
                maxphonethrans = 94+20.0*log10(((lowmaxphone + highmaxphone)/8192.0*3.32)*1.0);
            }
        }
    }
    
    phonethrans = phonevalue*1.0*8192.0/3.32;
    
    [BLEWeather setsoundfrombluetooth:phonethrans andmaxsound:maxphonethrans];
    //[self.blecontroller getUV];
}

- (void)sendData{
    if (isBLEConnected) {
        if (isFistTime) {
            [_blecontroller getTemperatureAndHumi];
            [_blecontroller getLight];
            [_blecontroller getMicrophone:0];
            [_blecontroller getUV];
            isFistTime = NO;
        }
        
        gettimer = [NSTimer scheduledTimerWithTimeInterval: getDataTimeInterval
                                                 target: self
                                               selector: @selector(handleTimer:)
                                               userInfo: nil
                                                repeats: YES];
    }
    
}

- (void) handleTimer: (NSTimer *) timer
{
    //在这里进行处理
    getindex++;
    [_blecontroller getMicrophone:1];
    if (getindex % 4 == 0) {
        [self.blecontroller getTemperatureAndHumi];
    }
    else if (getindex % 4 == 1)
    {
        [self.blecontroller getLight];
    }
    else if (getindex % 4 == 2)
    {
        //[self.blecontroller getMicrophone:0];
    }
    else if (getindex % 4 == 3)
    {
        [self.blecontroller getUV];
    }
    
    if (isBLEConnected) {
        [self updatebledataarray];
    }
}

@end
