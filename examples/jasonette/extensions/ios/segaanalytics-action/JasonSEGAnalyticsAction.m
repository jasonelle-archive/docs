//
//  JasonSEGAnalyticsAction.m
//  Jasonette
//
//  Created by e on 1/14/17.
//  Copyright © 2017 Jasonette. All rights reserved.
//

#import "JasonSEGAnalyticsAction.h"

@implementation JasonSEGAnalyticsAction
+ (void)initialize{
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"segment" withExtension:@"plist"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfURL:file];
    if(settings != nil){
        NSString *key = settings[@"key"];
        SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:key];
        configuration.trackApplicationLifecycleEvents = YES; // Enable this to record certain application events automatically!
        configuration.recordScreenViews = YES; // Enable this to record screen views automatically!
        [SEGAnalytics setupWithConfiguration:configuration];
    }
}

- (void)identify{
    if(self.options){
        NSString *id = self.options[@"id"];
        NSDictionary *traits = self.options[@"traits"];
        [[SEGAnalytics sharedAnalytics] identify:id traits:traits];
        [[Jason client] success: [JasonMemory client]._register];
    } else {
        [[Jason client] error: @{@"error": @"Need to pass options"}];
    }
}

- (void)track{
    if(self.options){
        NSString *event = self.options[@"event"];
        NSDictionary *properties = self.options[@"properties"];
        [[SEGAnalytics sharedAnalytics] track:event properties:properties];
        [[Jason client] success: [JasonMemory client]._register];
    } else {
        [[Jason client] error: @{@"error": @"Need to pass options"}];
    }
}
@end
