//
//  WeatherView.m
//  Parenting
//
//  Created by user on 13-5-30.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "WeatherView.h"
#import "Environmentitem.h"
#import "EnvironmentAdviceDataBase.h"
#import "WeatherAdviseViewController.h"

@implementation WeatherView
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
        [self makeView];
//        self.backgroundColor=[UIColor redColor];
    
        
    }
    return self;
}

-(void)setbluetooth
{
    self.blecontroller = [[BLEController alloc] init];
    self.blecontroller.bleControllerDelegate = self;
}

-(void)makeView
{
    dataarray =[[NSMutableArray alloc]init];
    Environmentitem *temp=[[Environmentitem alloc]init];
    Environmentitem *humi=[[Environmentitem alloc]init];
    Environmentitem *light=[[Environmentitem alloc]init];
    Environmentitem *sound=[[Environmentitem alloc]init];
    Environmentitem *pm=[[Environmentitem alloc]init];
    Environmentitem *uv=[[Environmentitem alloc]init];
    
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
    [dataarray addObject:light];
    [dataarray addObject:sound];
    if (CUSTOMER_COUNTRY == 0)
    {
        [dataarray addObject:uv];
    }
    else
    {
        [dataarray addObject:pm];

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


           // dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
                [[Weather weather] getweather:^(NSDictionary *weatherDict) {
                    NSDictionary *dict=weatherDict;
                    NSLog(@"weDic %@", dict);
                    
                    if([[dict objectForKey:@"temp"] length]>0)
                    {
                        temp.detail=[NSString stringWithFormat:@"%@℃",[dict objectForKey:@"temp"]];
                    }
                    if ([[dict objectForKey:@"humidity"] length]>0) {
                        humi.detail=[NSString stringWithFormat:@"%@%%",[dict objectForKey:@"humidity"]];
                    }
                    
                    if (CUSTOMER_COUNTRY == 1) {
                        if ([[dict objectForKey:@"PM25"] length]>0) {
                            int pmvalue = [[dict objectForKey:@"PM25"] intValue];
                            if (pmvalue > 0) {
                                 pm.detail=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"PM25"],[OpenFunction getpm25description:pmvalue]];
                                [dataarray replaceObjectAtIndex:4 withObject:pm];
                            }
                        }

                    }
                    
                    [dataarray replaceObjectAtIndex:0 withObject:temp];
                    [dataarray replaceObjectAtIndex:1 withObject:humi];
                    

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UITableView *tab=table;
                        [tab reloadData];
                    });
                }];
                
         //   } );
}

-(void)refreshweather
{
    mAlTemp.mAdviseId = 0;
    mAlHumi.mAdviseId = 0;
    [self updatedataarray];
}

-(void)updatedataarray
{
    Environmentitem *temp=[[Environmentitem alloc]init];
    Environmentitem *humi=[[Environmentitem alloc]init];
    //  Environmentitem *light=[[Environmentitem alloc]init];
    //  Environmentitem *sound=[[Environmentitem alloc]init];
    Environmentitem *pm=[[Environmentitem alloc]init];
    //  Environmentitem *uv=[[Environmentitem alloc]init];
    
    [[Weather weather] getweather:^(NSDictionary *weatherDict) {
        NSDictionary *dict=weatherDict;
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
        
        if (CUSTOMER_COUNTRY == 1) {
            if ([[dict objectForKey:@"PM25"] length]>0) {
                int pmvalue = [[dict objectForKey:@"PM25"] intValue];
                if (pmvalue > 0) {
                    pm.detail=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"PM25"],[OpenFunction getpm25description:pmvalue]];
                    Environmentitem *itemPM25 = [dataarray objectAtIndex:4];
                    itemPM25.detail = pm.detail;
                    [dataarray replaceObjectAtIndex:4 withObject:itemPM25];
                }
            }
            
        }
        
        Environmentitem *itemTemp = [dataarray objectAtIndex:0];
        itemTemp.detail = temp.detail;
        [dataarray replaceObjectAtIndex:0 withObject:itemTemp];
        
        Environmentitem *itemHumi = [dataarray objectAtIndex:1];
        itemHumi.detail = humi.detail;
        [dataarray replaceObjectAtIndex:1 withObject:itemHumi];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UITableView *tab=table;
            [tab reloadData];
        });
    }];

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

#pragma -mark bluetooth
-(void)RecvHumiAndTempDada:(NSData*)data
{
    NSString *hexStr=@"";
    
    Byte *hexData = (Byte *)[data bytes];
    errorCode = 0;
    for(int i=0; i<[data length];i++)
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
            
            if (i == 5) {
                NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
                dateFormator.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
                NSString *date = [dateFormator stringFromDate:[NSDate date]];
                humidity    = ((humidityHigh+humidityLow) * 1.0 )/ 16383 * 100;
                temperature = ((temperatureHigh + temperatureLow) * 1.0 )/ 16383 / 4 * 165 - 40;
                hexStr = [NSString stringWithCString:[[NSString stringWithFormat:@"%@ 采集到的湿度:%ld %%, 温度:%ld !", date,humidity,temperature] UTF8String] encoding:NSUTF8StringEncoding];
                //[Weather setweatherfrombluetooth:temperature Humidity:humidity];
                
                [table reloadData];
            }
            
        }
    }

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
    for (int i=0;i<[data length];i++) {
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
                lowlightChannel0 = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 2)
            {
                highlightChannel0 = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 3)
            {
                lowlightChannel1 = [BLEController hexStringHighToInt:newHexStr];
            }
            else
            {
                highlightChannel1 = [BLEController hexStringToInt:newHexStr];
            }
            
            if ( 5 == i) {
                CH0 = lowlightChannel0 + highlightChannel0;
                CH1 = lowlightChannel1 + highlightChannel1;
            }
        }
    }
    curlux = [self getlightluxwithCH0:CH0 andCH1:CH1];
}

-(int)getuv:(long)output
{
    int ret = 0;
    if (output < 1340) {
        ret = 0;
    }
    else if (output < 1439)
    {
        ret = 1;
    }
    else if (output < 1539)
    {
        ret = 2;
    }
    else if (output < 1638)
    {
        ret = 3;
    }
    else if (output < 1737)
    {
        ret = 4;
    }
    else if (output < 1836)
    {
        ret = 5;
    }
    else if (output < 1936)
    {
        ret = 6;
    }
    else if (output < 2035)
    {
        ret = 7;
    }
    else if (output < 2134)
    {
        ret = 8;
    }
    else if (output < 2234)
    {
        ret = 9;
    }
    else if (output < 2333)
    {
        ret = 10;
    }
    else if (output < 2432)
    {
        ret = 11;
    }
    else if (output < 2532)
    {
        ret = 12;
    }
    else if (output < 2631)
    {
        ret = 13;
    }
    else if (output < 2730)
    {
        ret = 14;
    }
    else if (output < 2829)
    {
        ret = 15;
    }
    else if (output < 2929)
    {
        ret = 16;
    }
    else if (output < 3028)
    {
        ret = 17;
    }
    else if (output < 3127)
    {
        ret = 18;
    }
    else if (output < 3327)
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
    for (int i=0;i<[data length];i++)
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
                lowuv  = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (2 == i)
            {
                highuv = [BLEController hexStringToInt:newHexStr];
            }
            
            if (3 == i)
            {
                adcoutput = lowuv + highuv;
            }
            
        }
        
    }
    uvvalue = [self getuv:adcoutput];
}

@end
