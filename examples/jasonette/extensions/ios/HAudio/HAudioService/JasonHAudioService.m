//
//  JasonHAudioService.m
//  Headless Audio Service
//
//  Created by Camilo Castro on 05-09-19.
//  Copyright © 2019 Ninjas.cl. All rights reserved.
//

#import "JasonHAudioService.h"
#import "JasonLogger.h"
#import "Jason.h"
#import "JasonMemory.h"
#import "NSString+DTUtilities.h"

NSString * JasonHAudioEventOnRecord = @"$haudio.onrecord";
NSString * JasonHAudioEventOnFinishRecording = @"$haudio.onfinishrecording";
NSString * JasonHAudioEventOnStop = @"$haudio.onstop";
NSString * JasonHAudioEventOnPause = @"$haudio.onpause";
NSString * JasonHAudioEventOnResume = @"$haudio.onresume";
NSString * JasonHAudioEventOnPermission = @"$haudio.onpermission";
NSString * JasonHAudioEventOnRemove = @"$haudio.onremove";
NSString * JasonHAudioEventOnTick = @"$haudio.ontick";

static const float DEFAULT_SAMPLE_RATE = 44100.0f;
static const int DEFAULT_CHANNELS = 1;
static const int DEFAULT_BIT_RATE = 0;
static const int DEFAULT_MAX_DURATION = 0;

static AVAudioRecorder * _audioRecorder;
static NSString * _filepath;
static NSString * _filename;
static NSTimer * _timer;
static BOOL _permissionGranted = NO;

@interface JasonHAudioService ()
@property (nonatomic) NSMutableDictionary * recordSettings;
@end

@implementation JasonHAudioService


- (void)initialize: (nullable NSDictionary *) launchOptions
{
    // Initiate and prepare the recorder
    
    self.state = JasonHAudioStateIdle;
    self.format = JasonHAudioFormatM4A;
    self.quality = JasonHAudioQualityDefault;
    self.samplerate = @(DEFAULT_SAMPLE_RATE);
    self.bitrate = @(DEFAULT_BIT_RATE);
    self.channels = @(DEFAULT_CHANNELS);
    self.maxduration = @(DEFAULT_MAX_DURATION);
    self.options = @{};
    
    self.recordSettings = [@{} mutableCopy];
    
    _permissionGranted = NO;
    
    [self setupAudioRecorder];
    
    DTLogDebug (@"Initialized");
}

- (void) setupAudioRecorder {

    
    NSString * uid = [NSProcessInfo processInfo].globallyUniqueString;
    _filename = [NSString stringWithFormat:@"%@.m4a", uid];
    
    NSString * recordingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:_filename];
    
    self.recordSettings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    
    if (self.format == JasonHAudioFormatCAF)
    {
        _filename = [NSString stringWithFormat:@"%@.caf", uid];
        recordingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:_filename];
        
        self.recordSettings[AVFormatIDKey] = @(kAudioFormatAppleLossless);
    }
    
    _filepath = recordingFilePath;
    
    self.recordSettings[AVSampleRateKey] = @(DEFAULT_SAMPLE_RATE);
    if ([self.samplerate floatValue] > 0.0f)
    {
        self.recordSettings[AVSampleRateKey] = self.samplerate;
    }
    
    self.recordSettings[AVNumberOfChannelsKey] = @(DEFAULT_CHANNELS);
    if ([self.channels integerValue] > 0)
    {
        self.recordSettings[AVNumberOfChannelsKey] = self.channels;
    }
    
    if (self.quality != JasonHAudioQualityDefault)
    {
        self.recordSettings[AVEncoderAudioQualityKey] = @(self.quality);
    }
    
    if ([self.bitrate integerValue] > DEFAULT_BIT_RATE)
    {
        self.recordSettings[AVEncoderBitRateKey] = self.bitrate;
    }
    
    // Initiate and prepare the recorder
    if(_audioRecorder) {
        [_audioRecorder stop];
        _audioRecorder = nil;
    }
    
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_filepath] settings:self.recordSettings error:nil];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;
    
}

- (void) record {
    [self checkIfCanAccessToMicrophone:^(BOOL granted) {
        
            if(!granted) {
                DTLogWarning(@"Microphone Access not Granted. Skip Recording");
                return;
            }
            
            // Schedule Timer every 1 second
            if(_timer) {
                [_timer invalidate];
                _timer = nil;
            }
        
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(sendStatsEventWithTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
        
            self.state = JasonHAudioStateRecording;
            
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
            
            [self setIdleTimerDisabled:YES];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:_filepath]) {
                [[NSFileManager defaultManager] removeItemAtPath:_filepath error:nil];
            }
            
            [_audioRecorder prepareToRecord];
            
            [self beginRecording];
            
            [self callEvent:JasonHAudioEventOnRecord withParams:[self fileUrlParams]];
    }];
}

- (void) stop {
    if(_audioRecorder) {
        DTLogDebug(@"Stopping %@", _filepath);
        [self setIdleTimerDisabled:NO];
        [_audioRecorder stop];
        [self callEvent:JasonHAudioEventOnStop withParams:[self fileUrlParams]];
    }
}

- (void) pause {
    if(_audioRecorder && _audioRecorder.isRecording) {
            DTLogDebug(@"Pausing %@", _filepath);
            [self callEvent:JasonHAudioEventOnPause withParams:[self fileUrlParams]];
        
            
            [_audioRecorder pause];
            if(_timer){
                [_timer invalidate];
                _timer = nil;
            }
            self.state = JasonHAudioStatePaused;
    }
}

- (void) resume {

    if(_audioRecorder && !_audioRecorder.isRecording) {
            
            DTLogDebug(@"Resuming Recording %@", _filepath);
            
            [self callEvent:JasonHAudioEventOnRecord withParams:[self fileUrlParams]];
            [self callEvent:JasonHAudioEventOnResume withParams:[self fileUrlParams]];
            
            self.state = JasonHAudioStateRecording;
            [self setIdleTimerDisabled:YES];

            [self beginRecording];
            
            if(!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendStatsEventWithTimer:) userInfo:nil repeats:YES];
            }
    }
}

- (void) removeAudioAtPath:(NSString *)path {
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        if([path hasSuffix:@"m4a"] || [path hasSuffix:@"caf"]) {
            DTLogDebug(@"Removing Audio File at Path %@", path);
            NSError * error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if(error){
                DTLogWarning(@"%@", error);
            }
            NSURL * url = [NSURL fileURLWithPath:path];
            [self callEvent:JasonHAudioEventOnRemove withParams:@{
                                                             @"file_url" : url.absoluteString,
                                                             @"file_path": path,
                                                             @"options": self.options
                                                             }];
        } else {
            DTLogWarning(@"Only can remove .m4a or .caf files. %@", path);
        }
        
        return;
    }
    
    DTLogWarning(@"File %@ Not Found", path);
}

- (void) checkIfCanAccessToMicrophone:(PermissionBlock) response
{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session requestRecordPermission:^(BOOL granted) {
        
            DTLogDebug(@"Audio Session Granted? %@", (granted ? @"YES" : @"NO"));
            NSMutableDictionary * params = [[self fileUrlParams] mutableCopy];
            params[@"granted"] = @(granted);
            _permissionGranted = granted;
            [self callEvent:JasonHAudioEventOnPermission withParams:params];
        
            if(!granted) {
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Microphone Access Denied!",nil) message:NSLocalizedString(@"Unable to access microphone. Please enable microphone access in Settings.",nil) preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                UIAlertAction * settings = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                
                [alert addAction:cancel];
                [alert addAction:settings];
                
                [[[Jason client] getVC] presentViewController:alert animated:YES completion:nil];
            }
        
            response(granted);
        }];
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL) flag
{
    BOOL succeeded = flag;
    
    DTLogDebug(@"Audio Recorder Did Finish Recording With %@ At Path %@", (succeeded ? @"success" : @"failure"), _filepath);
    
    self.state = JasonHAudioStateIdle;
    [self setIdleTimerDisabled:NO];
    
    if(_timer){
        [_timer invalidate];
    }
    
    [self callEvent:JasonHAudioEventOnFinishRecording withParams:[self getParams]];
    if(!succeeded)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filepath])
        {
            DTLogDebug(@"Removing file at path %@", _filepath);
            [[NSFileManager defaultManager] removeItemAtPath:_filepath error:nil];
        }
        return;
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    DTLogWarning(@"%@", error);
    if(_timer){
        [_timer invalidate];
    }
}

#pragma mark - Helpers

- (void) callEvent:(nonnull NSString *) event withParams:(nonnull NSDictionary *) params
{
        DTLogDebug(@"Prepare to call event %@", event);

        NSDictionary * events = [[[Jason client] getVC] valueForKey:@"events"];
        id action = events[event];
        
        if (action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[Jason client]
                     call:action
                     with:@{
                            @"$jason": params
                            }
                 ];
                // Sometimes happens a weird behaviour. (normally on pause event)
                // Somewhere the JasonMemory does not continue execution
                // And the actions are stopped entirely
                // So we have to manually reset the execution.
                // Maybe related to threads and the _timer
                // TODO: Investigate futher
                [JasonMemory client].executing = NO;
            });
        }
}

- (NSString *) timeStringForTimeInterval:(NSTimeInterval) timeInterval
{
    int secondsInMinute = 60;
    int secondsInHour = 3600;
    
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % secondsInMinute;
    NSInteger minutes = (ti / secondsInMinute) % secondsInMinute;
    NSInteger hours = (ti / secondsInHour);
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    
    return  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
}

- (nonnull NSDictionary *) fileUrlParams {
    NSURL * fileUrl = [NSURL fileURLWithPath:_filepath];
    NSString * quality = @"default";
    
    switch (self.quality) {
        case JasonHAudioQualityMin:
            quality = @"min";
            break;
        case JasonHAudioQualityLow:
            quality = @"low";
            break;
        case JasonHAudioQualityMedium:
            quality = @"medium";
            break;
        case JasonHAudioQualityHigh:
            quality = @"high";
            break;
        case JasonHAudioQualityMax:
            quality = @"max";
            break;
        default:
            quality = @"default";
            break;
    }
    
    return @{
             @"file_url" : [fileUrl absoluteString],
             @"file_path" : _filepath,
             @"file_name": _filename,
             @"file": @{
                     @"url" : [fileUrl absoluteString],
                     @"path" : _filepath,
                     @"name": _filename
                     },
             @"options": (self.options ? self.options : @{}),
             @"settings": @{
                     @"quality": quality,
                     @"samplerate": self.samplerate,
                     @"duration": self.maxduration,
                     @"format": ((self.format == JasonHAudioFormatM4A || self.format == JasonHAudioFormatDefault) ? @"m4a": @"caf")
             }
   };
}

- (NSDictionary *) stats {
    
    NSMutableDictionary * params = [[self fileUrlParams] mutableCopy];
    
    NSString * state = @"idle";
    
    if(self.state == JasonHAudioStateRecording) {
        state = @"recording";
    }
    
    if(self.state == JasonHAudioStatePaused) {
        state = @"paused";
    }
    
    params[@"state"] = state;
    
    params[@"channels"] = @{
                            @"default": @0,
                            @"zero" : @0
                            };
    params[@"duration"] = @{
                            @"formatted": @"0:0",
                            @"raw": @0
                            };
    
    if(_audioRecorder) {
        DTLogDebug(@"Getting Stats for Audio Recorder");
        if (_audioRecorder.isRecording || self.state == JasonHAudioStatePaused)
        {
            [_audioRecorder updateMeters];
            
            CGFloat channelZeroValue = pow(10, [_audioRecorder averagePowerForChannel:0] / 20);
            
            NSString * duration = [self timeStringForTimeInterval:_audioRecorder.currentTime];
            params[@"channels"] = @{
                                    @"default" : @(channelZeroValue),
                                    @"zero" : @(channelZeroValue)
                                    };
            params[@"duration"] = @{
                                    @"formatted": duration,
                                    @"seconds": @(_audioRecorder.currentTime)
                                    };
        }
    }
    
    DTLogDebug(@"Got Audio Stats %@", params);
    return [params copy];
}

- (void) setIdleTimerDisabled: (BOOL) disabled {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:disabled];
    });
}

- (nonnull NSDictionary *) getParams {
    
    NSURL * fileUrl = [NSURL fileURLWithPath:_filepath];
    NSData * data = [NSData dataWithContentsOfURL:fileUrl];
    NSString * base64 = [data base64EncodedStringWithOptions:0];
    
    if(!base64){
        base64 = @"";
    }
    
    NSString * dataFormatString = @"data:audio/m4a;base64,%@";
    
    if(self.format == JasonHAudioFormatCAF) {
        dataFormatString = @"data:audio/caf;base64;%@";
    }
    
    AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    double seconds = CMTimeGetSeconds(audioDuration);
    NSString * duration = [self timeStringForTimeInterval:seconds];
    
    NSString * dataString = [NSString stringWithFormat:dataFormatString, base64];
    
    if(!dataString) {
        dataString = @"";
    }
    
    NSURL * dataURI = [NSURL URLWithString:dataString];
    
    
    NSDictionary * params = @{ @"file_url": fileUrl.absoluteString,
                               @"file_path": _filepath,
                               @"file_name": _filename,
                               @"file": @{
                                       @"url": fileUrl.absoluteString,
                                       @"path": _filepath,
                                       @"name": _filename
                                       },
                               @"checksum": [[base64 md5Checksum] lowercaseString],
                               @"duration": @{
                                       @"formatted":duration,
                                       @"seconds":@(seconds)
                               },
                               @"data_uri": dataURI.absoluteString,
                               @"data": base64,
                               @"content_type": (self.format == JasonHAudioFormatM4A ? @"audio/m4a" : @"audio/caf"),
                               @"options": self.options
                               };
    
    return params;
}

- (void) sendStatsEventWithTimer: (NSTimer *) timer {
    NSDictionary * stats = [self stats];
    [self callEvent:JasonHAudioEventOnTick withParams:stats];
}

- (void) beginRecording {
    NSTimeInterval duration = [self.maxduration doubleValue];
    
    if (duration <= DEFAULT_MAX_DURATION) {
        [_audioRecorder record];
    } else {
        [_audioRecorder recordForDuration:duration];
    }
}
@end
