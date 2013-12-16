//
//  BTController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-12.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UartLib.h"

@protocol BTControllerDelegate<NSObject>
@optional
-(void)BTPowerOff:(BOOL)isPowerOff;
-(void)DidConnected:(BOOL)isConnected;
-(void)RecvBTData:(NSData*)recvData;
@end

@interface BTController : NSObject{
    int isNext;
    //****cwb****
    BOOL isSaved;
}
@property (assign) id<BTControllerDelegate> btControllerDelegate;

-(void)startscan;
-(void)stopscan;
-(void)btconnect;
-(void)btdisconnect;

@end
