//
//  BLEController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-13.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BLEControllerDelegate<NSObject>
@optional
-(void)BLEPowerOff:(BOOL)isPowerOff;
-(void)DidConnected:(BOOL)isConnected;
-(void)RecvBTData:(NSData*)recvdata;
@end

@interface BLEController : NSObject
@property (assign) id<BLEControllerDelegate> bleControllerDelegate;

-(void)startscan;
-(void)stopscan;
-(void)bleconnect;
-(void)bledisconnect;
-(void)senddata:(NSData*)sendData;

@end
