//
//  BLEController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-13.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "BLEController.h"
@interface BLEController()<UartDelegate>
{
    UartLib *uartLib;
    
    CBPeripheral	*connectPeripheral;
}


@end

@implementation BLEController

+(id)btcontroller
{
    
    __strong static BLEController *_sharedObject = nil;
    
    _sharedObject =  [[self alloc] init]; // or some other init metho
    
    
    return _sharedObject;
}

-(id)init
{
    self=[super init];
    if (self) {
        connectPeripheral = nil;
        
        uartLib = [[UartLib alloc] init];
        
        [uartLib setUartDelegate:self];
    }
    
    return self;
}
/****************************************************************************/
/*                       UartDelegate Methods                        */
/****************************************************************************/
- (void) didBluetoothPoweredOff{
    [self.bleControllerDelegate BLEPowerOff:YES];
    NSLog(@"power off");
}

- (void) didScanedPeripherals:(NSMutableArray  *)foundPeripherals
{
    NSLog(@"didScanedPeripherals(%d)", [foundPeripherals count]);
    
    CBPeripheral	*peripheral;
    
    for (peripheral in foundPeripherals) {
		NSLog(@"--Peripheral:%@", [peripheral name]);
	}
    
    if ([foundPeripherals count] > 0) {
        connectPeripheral = [foundPeripherals objectAtIndex:0];
        if ([connectPeripheral name] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@"BT_COM" forKey:@"BTNAME"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[connectPeripheral name] forKey:@"BTNAME"];
        }
    }
}

- (void) didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"did Connect Peripheral");
    
    connectPeripheral = peripheral;
    [self.bleControllerDelegate DidConnected:YES];
}

- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"did Disconnect Peripheral");
    
    connectPeripheral = nil;
    [self.bleControllerDelegate DidConnected:NO];
}

- (void) didWriteData:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didWriteData:%@", [peripheral name]);
}

- (void) didReceiveData:(CBPeripheral *)peripheral recvData:(NSData *)recvData
{
    NSLog(@"uart recv(%d):%@", [recvData length], recvData);
    [self.bleControllerDelegate RecvBTData:recvData];
}

#pragma -mark public function
-(void)startscan
{
    [uartLib scanStart];
}

-(void)stopscan
{
    [uartLib scanStop];
}

-(void)bleconnect
{
    NSLog(@"connect Peripheral");
    [uartLib scanStop];
    [uartLib connectPeripheral:connectPeripheral];
}

-(void)bledisconnect;
{
    [uartLib scanStop];
    [uartLib disconnectPeripheral:connectPeripheral];
}

-(void)senddata:(NSData *)sendData
{
    [uartLib sendValue:connectPeripheral sendData:sendData type:CBCharacteristicWriteWithoutResponse];
}
@end
