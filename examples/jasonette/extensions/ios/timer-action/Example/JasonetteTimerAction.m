//
//  JasonetteTimerAction.m
//  JasonetteTimerAction
//
//  Created by Unknower on 11/18/16.
//  Copyright © 2016 Gliechtenstein. All rights reserved.
//

#import "JasonetteTimerAction.h"

@implementation JasonetteTimerAction

-(id)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(start:)
         name:@"JasonetteTimerAction.start"
         object:nil];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(stop:)
         name:@"JasonetteTimerAction.stop"
         object:nil];
    }
    
    return self;
}


- (void)start:(NSNotification *)notification {

    if(!self.VC.timers){
        self.VC.timers = [[NSMutableDictionary alloc] init];
    }
    if(self.options){
        NSTimeInterval interval = (NSTimeInterval)[self.options[@"interval"] doubleValue];
        NSString *name = self.options[@"name"];
        BOOL repeats = NO;
        if(self.options[@"repeats"]){
            repeats = YES;
        }
        
        // If there's a pre-existing timer with the name, stop it.
        if(self.VC.timers[name]){
            [self.VC.timers[name] invalidate];
        }
        
        NSDictionary *action = self.options[@"action"];
        NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(func:)
                                               userInfo:action repeats:repeats];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.VC.timers[name] = timer;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Jason.success"
     object:@{}];

}
- (void)func: (NSTimer *)timer{
    NSDictionary *action = timer.userInfo;
    if([Jason client].touching) {
    } else {
        if(action && action.count > 0){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"Jason.call"
             object:action];

        }
    }
}
- (void)stop{
    if(!self.VC.timers){
        self.VC.timers = [[NSMutableDictionary alloc] init];
    }
    if(self.options){
        NSString *name = self.options[@"name"];
        if(name){
            if(self.VC.timers[name]){
                [self.VC.timers[name] invalidate];
                [self.VC.timers removeObjectForKey:name];
            }
        } else {
            // if name doesn't exist, just stop all timers
            for(NSString *timer_name in self.VC.timers){
                NSTimer *timer = self.VC.timers[timer_name];
                [timer invalidate];
                [self.VC.timers removeObjectForKey:timer_name];
            }
        }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Jason.success"
     object:@{}];
}

@end
