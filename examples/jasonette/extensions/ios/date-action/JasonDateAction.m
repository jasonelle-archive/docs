//
//  JasonDateAction.m
//  Jasonette
//  Created by Camilo Castro on 18-02-17.
//  Copyright © 2017 Ninjas.cl. All rights reserved.
//

#import "JasonDateAction.h"
#import "JasonOptionHelper.h"

NSString * const kISO8601Format = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";

@implementation JasonDateAction

#pragma mark - Private
- (NSDateFormatter *) __defaultDateFormatter
{
    
    static NSDateFormatter * dateFormatter = nil;
    
    static NSLocale * enUSPOSIXLocale = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dateFormatter = [NSDateFormatter new];
        
        enUSPOSIXLocale = [NSLocale
                                      localeWithLocaleIdentifier:@"en_US_POSIX"];
        
    });

    // English Locale
    [dateFormatter setLocale:enUSPOSIXLocale];
    
    // ISO 8601 Format
    [dateFormatter setDateFormat:kISO8601Format];

    JasonOptionHelper * options = [[JasonOptionHelper alloc]
                                   initWithOptions:self.options];

    NSString * format = [options getString:@"format"];
    if (format && ![format isEqualToString:@""])
    {
        [dateFormatter setDateFormat:format];
    }
    
    NSString * locale = [options getString:@"locale"];
    if (locale && ![locale isEqualToString:@""])
    {
        NSLocale * customLocale = [NSLocale
                                   localeWithLocaleIdentifier:
                                   locale
                                   ];
        
        [dateFormatter setLocale:customLocale];
    }
    

    return dateFormatter;
}

#pragma mark - Public

/*!
 * Returns the current date.
 * Defaults to ISO 8601 Format and en_US_POSIX Locale.
 *
 * @return
 *  - date (string)
 *  - unix (number)
 *  - timezone (object)
 *     - name (string)
 *     - secondsFromGMT (number)
 *
 * @options
 *  - format (string)
 *  - locale (string)
 */
- (void) now
{
    
    NSDateFormatter * dateFormatter = [self __defaultDateFormatter];
    
    NSDate * now = [NSDate date];
    NSTimeZone * timezone = [NSTimeZone localTimeZone];

    NSDictionary * result = @{
                              @"date" : [dateFormatter
                                        stringFromDate:now],
                              @"unix" : @([now timeIntervalSince1970]),
                              @"format" : dateFormatter.dateFormat,
                              @"locale" : dateFormatter.locale.localeIdentifier,
                              @"timezone" : @{
                                      @"name" : timezone.name,
                                      @"secondsFromGMT" : @(timezone.secondsFromGMT)
                                      }
                              };
    
    [[Jason client] success:result];
    
}

/*!
 * Takes a date with a given format and transform its to another format. 
 * Defaults to ISO 8601 Format and en_US_POSIX Locale.
 *
 * @return
 *  - date (string)
 *  - unix (number)
 *
 * @options
 *  - date (string, required)
 *  - format (string)
 *  - formatOut (string)
 *  - locale (string)
 */
- (void) format
{
    
    JasonOptionHelper * options = [[JasonOptionHelper alloc]
                                   initWithOptions:self.options];
    
    if ([options hasParam:@"date"])
    {
        NSString * dateIn = [options getString:@"date"];
        
        NSString * formatIn = [options
                               getStringWithKeyNames:@[
                                                       @"format",
                                                       @"format_in",
                                                       @"formatIn"]];
        
        if (!formatIn || [formatIn isEqualToString:@""])
        {
            formatIn = kISO8601Format;
        }
        
        NSString * formatOut = [options
                                getStringWithKeyNames:@[@"format_out",
                                                                @"formatOut"]];
        
        if (!formatOut || [formatOut isEqualToString:@""])
        {
            formatOut = kISO8601Format;
        }
        
        if (dateIn)
        {
            NSDateFormatter * dateFormatter = [self __defaultDateFormatter];
            
            [dateFormatter setDateFormat:formatIn];
            
            NSDate * date = [dateFormatter dateFromString:dateIn];
            
            [dateFormatter setDateFormat:formatOut];
            
            NSDictionary * result = @{
                                      @"date" : [dateFormatter
                                                 stringFromDate:date],
                                      @"format" : dateFormatter.dateFormat,
                                      @"locale" : dateFormatter.locale.localeIdentifier,
                                      @"unix" : @([date timeIntervalSince1970])         
                                    };
            
            return [[Jason client] success:result];
        }
    }
    
    // Params Not Found
    [[Jason client] error];
}

/*!
 * Transforms a Unix Timestamp into a Formatted Date.
 * Defaults to ISO 8601 Format and en_US_POSIX Locale.
 *
 * @return
 *  - date (string)
 *  - unix (number)
 *
 * @options
 *  - date (number, required)
 *  - format (string)
 *  - locale (string)
 */
- (void) unix 
{
  JasonOptionHelper * options = [[JasonOptionHelper alloc]
                                   initWithOptions:self.options];
    
  if ([options hasParam:@"date"])
  {
    NSDateFormatter * dateFormatter = [self __defaultDateFormatter];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:
                      [[options getNumber:@"date"] doubleValue]
                    ];

    NSDictionary * result = @{
                                      @"date" : [dateFormatter
                                                 stringFromDate:date],
                                      @"format" : dateFormatter.dateFormat,
                                      @"locale" : dateFormatter.locale.localeIdentifier,
                                      @"unix" : @([date timeIntervalSince1970])              
                              };
            
    return [[Jason client] success:result];
  }

  // Params Not Found
  [[Jason client] error];
}

@end
