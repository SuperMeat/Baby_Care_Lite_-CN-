//
//  CustonTimeViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-19.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "CustonTimeViewController.h"

@interface CustonTimeViewController ()

@end

@implementation CustonTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"重复", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        self.hidesBottomBarWhenPushed=YES;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectbtn1:(UIButton *)sender
{
    if (sender.tag == 101) {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 102;
    }
    else
    {
        [self.btn1 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn1.tag = 101;
    }
}

- (IBAction)selectbtn2:(UIButton *)sender
{
    if (sender.tag == 201) {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 202;
    }
    else
    {
        [self.btn2 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn2.tag = 201;
    }
}

- (IBAction)selectbtn3:(UIButton *)sender
{
    if (sender.tag == 301) {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 302;
    }
    else
    {
        [self.btn3 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn3.tag = 301;
    }
}

- (IBAction)selectbtn4:(UIButton *)sender
{
    if (sender.tag == 401) {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 402;
    }
    else
    {
        [self.btn4 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn4.tag = 401;
    }
}

- (IBAction)selectbtn5:(UIButton *)sender
{
    if (sender.tag == 501) {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 502;
    }
    else
    {
        [self.btn5 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn5.tag = 501;
    }
}

- (IBAction)selectbtn6:(UIButton *)sender
{
    if (sender.tag == 601) {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 602;
    }
    else
    {
        [self.btn6 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn6.tag = 601;
    }
}
- (IBAction)selectbtn7:(UIButton *)sender
{
    if (sender.tag == 701) {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day_up@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 702;
    }
    else
    {
        [self.btn7 setImage:[UIImage imageNamed:@"nofity_myadvise_day@2x.png"] forState:UIControlStateNormal];
        self.btn7.tag = 701;
    }
}
@end
