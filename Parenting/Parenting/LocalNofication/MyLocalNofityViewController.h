//
//  MyLocalNofityViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-6.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLocalNofityViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIDatePicker  *datepicker;
    
    UIActionSheet *action;
    NSDate* notifyDate;
    
    UIPickerView *picker;
    NSMutableArray *hours;
    NSMutableArray *minutes;
    
    UITableView *notifytableview;
    
    NSMutableArray *notifylist;
    int hour;
    int minute;
}


@end
