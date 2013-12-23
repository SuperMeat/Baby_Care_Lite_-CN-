//
//  CustomNotifyViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-18.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "CustomNotifyViewController.h"
#import "CustonTimeViewController.h"

@interface CustomNotifyViewController ()

@end

@implementation CustomNotifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"自定义消息", nil)];
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
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [self.myScrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.myScrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) ;
    _myScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.myScrollView];
    
    hours = [[NSMutableArray alloc] init];
    minutes = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i ++) {
        [hours addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0; i < 60; i ++) {
        [minutes addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(UIButton *)sender {
}

#pragma mark UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        return [hours objectAtIndex:row];
    }
    else {
        return [minutes objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        hour = [[hours objectAtIndex:row] intValue];
    }
    if (component == 1) {
        minute = [[minutes objectAtIndex:row] intValue];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

#pragma -mark textfield delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textfieldRedundant)
    {
        
    }
}


- (IBAction)setredundant:(UIButton *)sender
{
    CustonTimeViewController *ctvc = [[CustonTimeViewController alloc] init];
    [self.navigationController pushViewController:ctvc animated:YES];
}

@end
