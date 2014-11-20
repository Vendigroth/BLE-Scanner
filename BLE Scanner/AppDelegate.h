//
//  AppDelegate.h
//  BLE Scanner
//
//  Created by Dan on 11/3/14.
//  Copyright (c) 2014 Vendigroth. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,CBCentralManagerDelegate, CBPeripheralDelegate>
{
    NSArrayController *arrayController;
    NSMutableArray *peripherals;
    CBCentralManager *manager;
    CBPeripheral *peripheral;
    
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *statusMessageField;
@property (assign) IBOutlet NSTableView *tableView;
@property (retain) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet NSButton *scanButton;
@property (assign) IBOutlet NSProgressIndicator *indicatorScanning;
@property (assign) BOOL scanning;
@property (retain) NSMutableArray *peripherals;



- (void) startScan;
- (void) stopScan;
- (BOOL) isLECapableHardware;
@end

