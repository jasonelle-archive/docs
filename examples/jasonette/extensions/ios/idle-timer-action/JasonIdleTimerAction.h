//
//  JasonIdleTimerAction.h
//  Jasonette
//
//  Created by Camilo Castro on 01-03-17.
//  Copyright © 2017 Jasonette. All rights reserved.
//

#import "JasonAction.h"

/*!
 * Provides access to the idle timer
 * https://developer.apple.com/reference/uikit/uiapplication/1623070-idletimerdisabled?language=objc
 *
 * The default value of this property is NO. 
 * When most apps have no touches as user input for a short period, 
 * the system puts the device into a "sleep” state where the screen dims. 
 * This is done for the purposes of conserving power. 
 * However, apps that don't have user input except for the accelerometer—games, 
 * for instance—can, by setting this property to YES, disable the “idle timer” 
 * to avert system sleep.
 */
@interface JasonIdleTimerAction : JasonAction

@end
