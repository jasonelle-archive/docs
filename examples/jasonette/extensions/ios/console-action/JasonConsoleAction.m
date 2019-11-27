//
//  JasonConsoleAction.m
//  Jasonette
//
//  Created by e on 1/9/17.
//  Copyright © 2017 Jasonette. All rights reserved.
//

#import "JasonConsoleAction.h"

@implementation JasonConsoleAction
- (void)debug{
    NSDictionary *variables = [[Jason client] variables];
    NSMutableArray *vars = [[NSMutableArray alloc] init];
    
    if(self.options){
        if(self.options[@"eval"]){
            [vars addObject:@{@"name": @"evaluated", @"value": self.options[@"eval"]}];
        }
    }
    
    for(NSString *key in variables){
        [vars addObject:@{@"name": key, @"value": variables[key]}];
    }
    for(NSString *key in [JasonMemory client]._register){
        [vars addObject:@{@"name": key, @"value": [JasonMemory client]._register[key]}];
    }
    
    
    NSDictionary *href = @{
                           @"type": @"$href",
                           @"options": @{
                               @"url": @"file://jasonconsoleaction.json",
                               @"options": @{@"variables": vars}
                           }
   };
   [[Jason client] call: href];
}
@end
