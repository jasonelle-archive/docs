//
//  JasonHAudioAction.m
//  Headless Audio Action
//
//  Created by Camilo Castro on 05-09-19.
//  Copyright © 2019 Ninjas.cl. All rights reserved.
//

#import "JasonHAudioAction.h"
#import "JasonHAudioService.h"
#import "JasonLogger.h"

@implementation JasonHAudioAction

- (JasonHAudioService *) _getService {
    JasonHAudioService * service = [Jason client].services[@"JasonHAudioService"];
    return service;
}

- (void) record {
    DTLogDebug(@"$haudio.record");
    JasonHAudioService * service = [self _getService];
    
    // Reset Settings
    [service stop];
    [service initialize:nil];
    
    NSDictionary * options = self.options;
    if(options[@"duration"]) {
        // duration is in milliseconds
        NSNumber * duration = options[@"duration"];
        if(duration &&
           [duration isKindOfClass:[NSNumber class]] &&
           [duration doubleValue] > 0) {
            NSNumber * seconds = @([duration doubleValue] / 1000);
            DTLogDebug(@"Recording for %@ seconds", [seconds stringValue]);
            service.maxduration = seconds;
        }
    }
    
    if(options[@"quality"]) {

        service.quality = JasonHAudioQualityDefault;
        NSString * quality = [options[@"quality"] lowercaseString];
        DTLogDebug(@"Setting Quality as %@", quality);
        if([quality isEqualToString:@"min"]){
            service.quality = JasonHAudioQualityMin;
        }
        
        if([quality isEqualToString:@"low"]){
            service.quality = JasonHAudioQualityLow;
        }
        
        if([quality isEqualToString:@"medium"]){
            service.quality = JasonHAudioQualityMedium;
        }
        
        if([quality isEqualToString:@"high"]){
            service.quality = JasonHAudioQualityHigh;
        }
        
        if([quality isEqualToString:@"max"]){
            service.quality = JasonHAudioQualityMax;
        }
    }
    
    // Check if the special options are present and contains at least 1 value
    if(options[@"options"] &&
       [options[@"options"] isKindOfClass:[NSDictionary class]] &&
       [[options[@"options"] allValues] firstObject]) {
        DTLogDebug(@"Got special options %@", options[@"options"]);
        service.options = options[@"options"];
    }
    
    // Re apply settings
    [service setupAudioRecorder];
    [service record];
    
    [[Jason client] success];
}

- (void) stop {
    DTLogDebug(@"$haudio.stop");
    JasonHAudioService * service = [self _getService];
    [service stop];
    [[Jason client] success];

}

- (void) pause {
    DTLogDebug(@"$haudio.pause");
    JasonHAudioService * service = [self _getService];
    [service pause];
    [[Jason client] success];
}

- (void) resume {
    DTLogDebug(@"$haudio.resume");
    JasonHAudioService * service = [self _getService];
    [service resume];
    [[Jason client] success];
}

- (void) remove {
    DTLogDebug(@"$haudio.remove");
    JasonHAudioService * service = [self _getService];
    NSDictionary * options = self.options;
    if(options[@"path"]) {
        [service removeAudioAtPath:options[@"path"]];
    } else {
        DTLogWarning(@"Missing `path` in $haudio.remove");
    }
    [[Jason client] success];
}

- (void) stats {
    DTLogDebug(@"$haudio.stats");
    JasonHAudioService * service = [self _getService];
    NSDictionary * stats = [service stats];
    [[Jason client] success:stats];
}
@end
