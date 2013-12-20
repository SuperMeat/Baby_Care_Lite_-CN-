//
//  LocalNotifyCell.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "LocalNotifyCell.h"

@implementation LocalNotifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = CGRectMake(9, 0, 302, 44);
    self.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 44);
}
@end
