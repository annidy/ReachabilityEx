//
//  ViewController.m
//  ReachabilityEx
//
//  Created by FengXing on 13-12-27.
//  Copyright (c) 2013年 FengXing. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

@interface ViewController ()
@end

@implementation ViewController
{
    Reachability *reachability;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(alert) withObject:nil afterDelay:2.f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alert
{
    int n = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    NSString *msg;
    if (n == 0) {
        msg = @"无网络";
    } else if (n == 1) {
        msg = @"WiFi";
    } else if (n == 2) {
        msg = @"蜂窝";
    } else if (n == 3) {
        msg = @"2G";
    } else if (n == 4) {
        msg = @"3G";
    } else if (n == 5) {
        msg = @"4G";
    } else if (n == 6) {
        msg = @"LTE";
    } else {
        msg = @"Opps";
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:msg
                                                delegate:self
                                       cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(alert) withObject:nil afterDelay:2.f];
}

@end
