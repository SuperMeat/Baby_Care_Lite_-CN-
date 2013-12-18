//
//  MyLocalNofityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-6.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "MyLocalNofityViewController.h"
#import "LocalNotifyCell.h"

@interface MyLocalNofityViewController ()

@end

@implementation MyLocalNofityViewController

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
        [titleText setText:NSLocalizedString(@"LocalNotify", nil)];
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
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    UIButton *remind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [remind setFrame:CGRectMake(100.0f, 300.0f, 120.0f, 40.0f)];
    [remind setTitle:@"定制闹钟" forState:UIControlStateNormal];
    [remind addTarget:self action:@selector(clock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remind];
    
    hours = [[NSMutableArray alloc] init];
    minutes = [[NSMutableArray alloc] init];
    
    NSMutableArray *localnotify = [[NSUserDefaults standardUserDefaults] objectForKey:@"localnotifylist"];
    if (localnotify == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]initWithCapacity:0] forKey:@"localnotifylist"];
    }
    
    notifylist = localnotify;
    
    if (notifytableview == nil) {
        notifytableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 15, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
        notifytableview.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
        notifytableview.delegate=self;
        notifytableview.dataSource=self;
        notifytableview.showsVerticalScrollIndicator =NO;
        //    _settingTable.bounces=NO;
        notifytableview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:notifytableview];
    }
    
    
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

- (void)addNotify
{
    NSLog(@"addNotify");
    [self actionsheetShow];
}

- (void)clock:(UIButton *)button
{
    [self actionsheetShow];
    
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDateAndTime;
        [datepicker addTarget:self action:@selector(updatedate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self]) {
        [action showInView:self.view];
    } else {
        [action showInView:window];
    }
}

-(void)updatedate:(UIDatePicker*)sender
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    comps=[calendar components:unitFlags fromDate:sender.date];
    NSString* str = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",[comps year],[comps month],[comps day],[comps hour],[comps minute],0];
    notifyDate = [currentdate dateFromString:str];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [OpenFunction addLocalNotificationWithMessage:@"干嘛干嘛" FireDate:notifyDate AlarmKey:@"ddd"];
    
}
/**
 *	table view delegate
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [notifylist count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self actionsheetShow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [notifylist count]) {
        return 90.0f;
    }
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [notifylist count] ) {
        LocalNotifyCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"Notify"];
        if (Cell == nil) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"LocalNotifyCell" owner:self options:nil] lastObject];
            Cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        Cell.title.text      = @"玩耍";
        Cell.timedetail.text = @"周一 20:20";
        Cell.notifycontent.text    = @"五天后提醒";
        Cell.notifyswitch.selected = YES;
        Cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
        return Cell;

    }
    else
    {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"NotifyAdd"];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotifyAdd"];
            Cell.textLabel.font=[UIFont systemFontOfSize:30];
            Cell.textLabel.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
            Cell.textLabel.textAlignment = NSTextAlignmentCenter;
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        Cell.textLabel.text      = @"添加提醒";
        Cell.accessoryView.contentMode=UIViewContentModeScaleAspectFit;
        return Cell;
    }
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

@end
