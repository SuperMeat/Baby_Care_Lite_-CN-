//
//  CustomNotifyViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-18.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNotifyViewController : UIViewController< UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *hours;
    NSMutableArray *minutes;
    int hour;
    int minute;
}
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UITextField *textfieldTitleTip;
@property (strong, nonatomic) IBOutlet UITextField *textfieldTimeTip;
@property (strong, nonatomic) IBOutlet UITextField *textfieldRedundant;
@property (strong, nonatomic) IBOutlet UIButton *btnsave;
- (IBAction)save:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnredundant;
- (IBAction)setredundant:(UIButton *)sender;

@end
