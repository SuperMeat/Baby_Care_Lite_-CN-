    //
//  MyDevicesTableViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-16.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "MyDevicesTableViewController.h"
#import "BindingDeviceViewController.h"

@interface MyDevicesTableViewController ()

@end

@implementation MyDevicesTableViewController
@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self dataInitialize];
    
    tableView= [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
}

-(void)dataInitialize{
    //处理已绑定设备
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BLEPERIPHERAL_ACTIVITY"] != nil) {
        NSString *peripheral1 =[[NSUserDefaults standardUserDefaults] stringForKey:@"BLEPERIPHERAL_ACTIVITY"];
        [arrMyDevices arrayByAddingObject:peripheral1];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BLEPERIPHERAL_ENVIRONMENT"] != nil) {
        NSString *peripheral2 =[[NSUserDefaults standardUserDefaults] stringForKey:@"BLEPERIPHERAL_ENVIRONMENT"];
        [arrMyDevices arrayByAddingObject:peripheral2];
    }
    
    arrAdd = [[NSArray alloc] initWithObjects:@"绑定配件",nil];
    if (arrMyDevices == nil) {
        arrData = [[NSArray alloc] initWithObjects:arrAdd, nil];

    }
    else{
        arrData = [[NSArray alloc] initWithObjects:arrMyDevices, arrAdd, nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)ctableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //制作可重復利用的表格栏位Cell
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [ctableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font=[UIFont systemFontOfSize:17];
        cell.textLabel.textColor=[UIColor blueColor];

        
        if (indexPath.section == 1) {
//            此处添加硬件设备外观图 & 是否已连接标示
//            cell.imageView.image = [UIImage imageNamed:@"icon_connected"];
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    
    //设定栏位的内容与类型
    cell.textLabel.text = [[arrData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
    if (indexPath.section == [arrData count] - 2) {
        //进入配件编辑页面
    }
    else if (indexPath.section == [arrData count] - 1)
    {
        //进入配件绑定搜寻页面
        BindingDeviceViewController *binding = [[BindingDeviceViewController alloc] init];
        [self.navigationController pushViewController:binding animated:YES];
    }
    
    
}

@end
