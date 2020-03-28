//
//  JasonHAudioService.h
//  Headless Audio Service
//
//  Created by Camilo Castro on 05-09-19.
//  Copyright © 2019 Ninjas.cl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JasonHAudioFormat) {
    JasonHAudioFormatDefault,
    JasonHAudioFormatM4A       = kAudioFormatMPEG4AAC,  //.m4a
    JasonHAudioFormatCAF       = kAudioFormatAppleLossless,  //.caf
};

typedef NS_ENUM(NSUInteger, JasonHAudioQuality) {
    JasonHAudioQualityDefault   = -1,
    JasonHAudioQualityMin       = AVAudioQualityMin,
    JasonHAudioQualityLow       = AVAudioQualityLow,
    JasonHAudioQualityMedium    = AVAudioQualityMedium,
    JasonHAudioQualityHigh      = AVAudioQualityHigh,
    JasonHAudioQualityMax       = AVAudioQualityMax,
};

typedef NS_ENUM(NSUInteger, JasonHAudioState) {
    JasonHAudioStateIdle        = 1000,
    JasonHAudioStateRecording   = 1001,
    JasonHAudioStatePaused      = 1002
};

extern const NSString * JasonHAudioEventOnRecord;
extern const NSString * JasonHAudioEventOnFinishRecording;
extern const NSString * JasonHAudioEventOnTick;
extern const NSString * JasonHAudioEventOnRecord;
extern const NSString * JasonHAudioEventOnStop;
extern const NSString * JasonHAudioEventOnPause;
extern const NSString * JasonHAudioEventOnResume;
extern const NSString * JasonHAudioEventOnPermission;
extern const NSString * JasonHAudioEventOnRemove;
extern const NSString * JasonHAudioEventOnTick;

/**
 Headless Audio Service.
 Provides the main interface to trigger events related to audio recording.
 @brief
 
 ## Events Triggered
 
 The following events will be called. Define them inside $jason.head.actions object.
 
 ### $haudio.onfinishrecording
 
 Triggered when an audio finished recording. With the following params.
 
 ```
     {
         "file_url": fileUrl.absoluteString, // use this to play the file with $audio.play
         "file_path": _filepath,
         "file_name": _filename,
         // these are the same as above, just to have a nice api
         "file": {
             "url": fileUrl.absoluteString,
             "path": _filepath,
             "name": _filename
         },
         "duration": {
            "formatted":duration,
            "seconds": seconds
         },
         "data_uri": dataURI.absoluteString, // data as an url from base64 string
         "data": base64, // data as bas64 string. Use this for sending to your server
         "checksum": [base64 md5Checksum],
         "content_type": "audio/m4a"
    }
```
 
 #### Example
 
 ```
 "$haudio.onfinishrecording": {
     "type": "$set",
     "options": {
         "audio": {
             "url": "{{$jason.file_url}}",
             "path": "{{$jason.file_path}}"
     }
 }
 ```
 */
@interface JasonHAudioService : NSObject <AVAudioRecorderDelegate>
@property (nonatomic) JasonHAudioState state;
@property (nonatomic) JasonHAudioFormat format;
@property (nonatomic) JasonHAudioQuality quality;
@property (nonatomic) NSNumber * samplerate;
@property (nonatomic) NSNumber * channels;
@property (nonatomic) NSNumber * bitrate;
@property (nonatomic) NSNumber * maxduration;
@property (nonatomic) NSDictionary * options;

/**
 Call this method to reset the options.
 Normally used in the AppDelegate initializer.

 @param launchOptions not used.
 */
- (void)initialize:(nullable NSDictionary *)launchOptions;
- (void) setupAudioRecorder;

- (void) record;
- (void) stop;
- (void) pause;
- (void) resume;
- (NSDictionary *) stats;
- (void) removeAudioAtPath: (NSString *) path;
@end

NS_ASSUME_NONNULL_END
