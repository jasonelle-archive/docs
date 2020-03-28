//
//  JasonHAudioAction.h
//  Headless Audio Action
//
//  Created by Camilo Castro on 05-09-19.
//  Copyright © 2019 Ninjas.cl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JasonAction.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Jason Headless Audio Action.
 This is the main interface for using the $haudio methods.
 */
@interface JasonHAudioAction : JasonAction

/**
 Starts the recording session. Any other session will be stopped.
 @param duration (optional) milliseconds to wait before autostop.
 */
- (void) record;

/**
 Stops the recording session.
 Triggers the $haudio.onstop event.
 */
- (void) stop;

/**
 Pauses the recording session.
 Triggers the $haudio.onpause event.
 */
- (void) pause;

/**
 Resumes a paused recording session.
 Triggers the $haudio.onresume event.
 */
- (void) resume;

/**
 Removes an audio file from internal storages.
 @param path (required) the internal path to the file.
 */
- (void) remove;

/**
 Get the current audio stats.
 */
- (void) stats;
@end

NS_ASSUME_NONNULL_END
