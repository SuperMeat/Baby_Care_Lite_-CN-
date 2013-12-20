//
//  CustonTimeViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-19.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustonTimeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btn7;
@property (strong, nonatomic) IBOutlet UIButton *btn6;
@property (strong, nonatomic) IBOutlet UIButton *btn5;
@property (strong, nonatomic) IBOutlet UIButton *btn4;
@property (strong, nonatomic) IBOutlet UIButton *btn3;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
- (IBAction)selectbtn1:(UIButton *)sender;

- (IBAction)selectbtn2:(UIButton *)sender;

- (IBAction)selectbtn3:(UIButton *)sender;

- (IBAction)selectbtn4:(UIButton *)sender;

- (IBAction)selectbtn5:(UIButton *)sender;

- (IBAction)selectbtn6:(UIButton *)sender;

- (IBAction)selectbtn7:(UIButton *)sender;

@end
