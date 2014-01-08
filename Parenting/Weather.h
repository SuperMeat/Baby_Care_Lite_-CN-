//
//  Weather.h
//  Parenting
//
//  Created by user on 13-5-29.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^Getweather)(NSDictionary *weatherDict);

@class GDataXMLNode;
@interface Weather : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *lm;
    NSMutableData *Mydata;
    CLLocationCoordinate2D  userCoordinate;
    Getweather getweatherBlock;
    NSString* mycity;
}

@property (nonatomic, strong) Getweather getweatherBlock;

+(id)weather;
-(NSDictionary*)getweather;
-(NSDictionary*)getbleweather;
-(void)getweather:(Getweather) getweather;
+(void)setweatherfrombluetooth:(long)temp Humidity:(long)humi;
+(void)setlightfrombluetooth:(double)light;
+(void)setsoundfrombluetooth:(double)sound;
+(void)setuvfrombluetooth:(long)uv;
+(long)gettemperature;
+(long)gethumidity;
+(double)getlight;
+(double)getsound;
+(long)getuv;
@end
