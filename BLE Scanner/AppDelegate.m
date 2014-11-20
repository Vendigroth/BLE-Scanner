//
//  AppDelegate.m
//  BLE Scanner
//
//  Created by Dan on 11/3/14.
//  Copyright (c) 2014 Vendigroth. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize peripherals;
@synthesize arrayController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.scanning = NO;
    self.statusMessageField.stringValue = @"";
    self.peripherals = [NSMutableArray array];
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) dealloc
{
    [self stopScan];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



- (IBAction)clickedScan:(NSButtonCell *)sender {
    
    if( [self isLECapableHardware] ){
        if (!self.scanning) {
            sender.title = @"Stop Scanning";
            id me = self;
            [self.indicatorScanning startAnimation:me];
            [self startScan];
            self.scanning = YES;
        }
        else{
            sender.title = @"Start Scanning";
            id me = self;
            [self.indicatorScanning stopAnimation:me];
            [self stopScan];
            self.scanning = NO;
        }
    }
}
- (IBAction)clickedClear:(id)sender {
    [peripherals removeAllObjects];
    [_tableView reloadData];
}

/*
 Request CBCentralManager to scan */
- (void) startScan
{
    NSLog(@"Scanning");
    [manager scanForPeripheralsWithServices:nil options:nil];
    
}

/*
 Request CBCentralManager to stop scanning */
- (void) stopScan
{
    [manager stopScan];
 
}


/*
 Uses CBCentralManager to check whether the current platform/hardware supports Bluetooth LE. */
- (BOOL) isLECapableHardware
{
    NSString * state = nil;
    
    switch ([manager state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            self.statusMessageField.stringValue = @"";
            self.scanButton.enabled = YES;
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    NSLog(@"Central manager state: %@", state);
    
    self.statusMessageField.stringValue = state;
    self.scanButton.enabled = NO;
    return FALSE;
}

#pragma mark - CBCentralManager delegate methods

/*
 Invoked whenever the central manager's state is updated.
 */
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware];
}

/*
 Invoked when the central discovers heart rate peripheral while scanning.
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Found %@ %@", aPeripheral.name, RSSI);
    
    NSMutableArray *peripheralsArr = [self mutableArrayValueForKey:@"peripherals"];
    
    if( ![self.peripherals containsObject:aPeripheral] ){
        [peripheralsArr addObject:aPeripheral];
    }
    
}



@end
