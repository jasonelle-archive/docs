//
//  JasonFirebaseAction.m
//
//  Created by Camilo Castro on 21-04-20.
//  Copyright © 2020 Ninjas.cl. All rights reserved.
//

#import "JasonFirebaseAction.h"
#import "JasonLogger.h"


@implementation JasonFirebaseAction


- (void) token {
    
    // Returns the current FCM token
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:kFCMTokenKey];
    DTLogDebug(@"FCM Token %@", token);
    
    if(!token) {
        token = @"";
        DTLogError(@"FCM Token not found. Is delegate set to JasonFirebaseService?.");
    }
    
    [[Jason client] success:@{
        @"token": token
    }];
}

@end
