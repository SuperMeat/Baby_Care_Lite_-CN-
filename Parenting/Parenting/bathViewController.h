//
//  bathViewController.h
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"
@class WeatherView;
@class save_bathview;
@interface bathViewController : UIViewController
{

    UIButton * startButton;
    UIButton * addRecordBtn;
    NSTimer *timer;
    UILabel *timeLable;
    save_bathview *saveView;
    UILabel *labletip;
}
@property (strong, nonatomic)SummaryViewController *summary;
@property(weak,nonatomic)WeatherView *weather;
+(id)shareViewController;
@end
