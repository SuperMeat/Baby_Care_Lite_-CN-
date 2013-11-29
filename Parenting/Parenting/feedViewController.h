//
//  ActivityViewController.h
//  Parenting
//
//  Created by user on 13-5-21.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"

@class save_feedview;
@class WeatherView;
@interface feedViewController : UIViewController
{
    UIButton * startButton;
    UIButton * startButtonleft;
    UIButton * startButtonright;
    UIButton * addRecordBtn;
    UIImageView *breastleft;
    UIImageView *breastright;
    NSTimer *timer;
    UILabel *timeLable;
   save_feedview *saveView;
    UILabel *labletip;
    
    
}
@property(nonatomic,strong)NSString *activity;
@property(nonatomic,strong)NSString *feedWay;
@property(nonatomic,strong)NSString *breast;
@property (strong, nonatomic)SummaryViewController *summary;
@property(weak,nonatomic)WeatherView *weather;
@property(nonatomic,strong)NSString *obj;
+(id)shareViewController;
@end
