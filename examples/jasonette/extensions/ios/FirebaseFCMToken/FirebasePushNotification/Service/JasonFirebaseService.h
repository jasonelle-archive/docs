//
//  JasonFirebaseService.h
//
//  Created by Camilo Castro on 21-04-20.
//  Copyright © 2020 Ninjas.cl. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

extern NSString * kFCMTokenKey;

@interface JasonFirebaseService : NSObject <FIRMessagingDelegate>

@property (nonatomic) NSString * token;

- (void)messaging:(FIRMessaging *)messaging
didReceiveRegistrationToken:(NSString *)fcmToken;

@end

NS_ASSUME_NONNULL_END
