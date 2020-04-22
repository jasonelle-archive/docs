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
    JasonFirebaseService * service = [Jason client].services[@"JasonFirebaseService"];
    
    NSString * token = @"";
    if(service.token) {
        token = service.token;
        DTLogDebug(@"FCM Token %@", token);
    }
    
    [[Jason client] success:@{
        @"token": token
    }];
}

@end
