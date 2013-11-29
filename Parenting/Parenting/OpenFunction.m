//
//  OpenFunction.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-9-23.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OpenFunction.h"
#import "APService.h"

@implementation OpenFunction

+ (float) getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void) openUserReviews
{
    //NSString *str = [NSString stringWithFormat:
    //                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",706557892];
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/bao-bei-ji-hua-jian-ban-rang/id706557892?mt=8"];
    https://itunes.apple.com/cn/app/bao-bei-ji-hua-jian-ban-rang/id706557892?mt=8
    //NSLog(@"openuserreviews %@ ", str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(NSString*)getpm25description:(int)value
{
    NSString *desp;
    if (value <= 35) {
        desp = @"优";
    }
    else if (value <= 75)
    {
        desp = @"良";
    }
    else if (value <= 115)
    {
        desp = @"轻度";
    }
    else if (value <= 150)
    {
        desp = @"中度";
    }
    else if (value <= 250)
    {
        desp = @"重度";
    }
    else
    {
        desp = @"严重";
    }
    
    return desp;
}

+ (NSString*)getopenudid
{
    return [APService openUDID];
}

@end
