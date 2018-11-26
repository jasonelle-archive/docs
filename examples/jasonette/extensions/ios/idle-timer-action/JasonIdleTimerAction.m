//
//  JasonIdleTimerAction.m
//  Jasonette
//
//  Created by Camilo Castro on 01-03-17.
//  Copyright © 2017 Jasonette. All rights reserved.
//

#import "JasonIdleTimerAction.h"

@implementation JasonIdleTimerAction

- (void) enable
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[Jason client] success];
}

- (void) disable
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [[Jason client] success];
}
@end
