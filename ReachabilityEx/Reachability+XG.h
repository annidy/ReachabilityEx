//
//  Reachability+XG.h
//  ReachabilityEx
//
//  Created by FengXing on 13-12-27.
//  Copyright (c) 2013年 FengXing. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (XG)

- (BOOL)dataNetworkTypeFromTelephony:(NetworkStatus *)status;

+ (NetworkStatus)dataNetworkTypeFromStatusBar;

@end
