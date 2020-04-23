//
//  JasonFirebaseService.m
//
//  Created by Camilo Castro on 21-04-20.
//  Copyright © 2020 Ninjas.cl. All rights reserved.
//

#import "JasonFirebaseService.h"
#import "JasonLogger.h"

NSString * kFCMTokenKey = @"FCMToken";

@implementation JasonFirebaseService

- (NSString *) token {
    
    if(!_token) {
        _token = @"";
    }
    
    return _token;
}

- (void)initialize:(NSDictionary *)launchOptions
{
    DTLogDebug (@"initialize");
}

#pragma mark - Firebase Messaging Delegate

// https://firebase.google.com/docs/cloud-messaging/ios/client
- (void)messaging:(FIRMessaging *)messaging
didReceiveRegistrationToken:(NSString *)fcmToken {
    
    DTLogDebug(@"Received FCM Token %@", fcmToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:kFCMTokenKey];

    self.token = fcmToken;
    
    NSDictionary * dataDict = @{@"token": fcmToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:
     kFCMTokenKey object:nil userInfo:dataDict];
}

@end
