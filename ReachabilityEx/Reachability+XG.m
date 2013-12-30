//
//  Reachability+XG.m
//  ReachabilityEx
//
//  Created by FengXing on 13-12-27.
//  Copyright (c) 2013年 FengXing. All rights reserved.
//

#import "Reachability+XG.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Reachability (XG)

/// iOS 7新增方法
- (BOOL)dataNetworkTypeFromTelephony:(NetworkStatus *)status
{
    static NSString *access = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        @try {
            access = [telephonyInfo valueForKey:@"currentRadioAccessTechnology"];
        }
        @catch (NSException *exception) {
            access = nil;
            return;
        }
        NSLog(@"Current Radio Access Technology: %@", access);
        [NSNotificationCenter.defaultCenter addObserverForName:@"CTRadioAccessTechnologyDidChangeNotification"
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(NSNotification *note)
        {
            access = [telephonyInfo valueForKey: @"currentRadioAccessTechnology"];
            NSLog(@"New Radio Access Technology: %@", access);
        }];
    });

    NSLog(@"Telephony %@", access);
    if ([access isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        *status = ReachableVia2G;
    } else if ([access isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
        *status = ReachableVia3G;
    } else {
        return NO;
    }
    return YES;
}

+ (NetworkStatus)dataNetworkTypeFromStatusBar
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    // UIStatusBarDataNetworkItemView 是使用api，这里简单处理一下
    NSString *UIStatusBarDataNetworkItemView = [NSString stringWithFormat:@"%@%@%@", @"UIStatus", @"BarDataNet", @"workItemView"];
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(UIStatusBarDataNetworkItemView) class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    /*
    0 = No wifi or cellular
    1 = 2G and earlier? (not confirmed)
    2 = 3G? (not yet confirmed)
    3 = 4G
    4 = LTE
    5 = Wifi
    */
    
    NetworkStatus netType = NotReachable;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    int n = [num intValue];
    if (n == 1) {
        netType = ReachableVia2G;
    } else if (n == 2) {
        netType = ReachableVia3G;
    } else if (n == 3) {
        netType = ReachableVia4G;
    } else if (n == 4) {
        netType = ReachableViaLTE;
    } else if (n == 5) {
        netType = ReachableViaWiFi;
    }
    return netType;
}

@end
