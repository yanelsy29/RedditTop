//
//  Model.m
//  TopTest
//
//  Created by Yanelsy Rivera on 10/31/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import "Model.h"

@implementation LinkObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    LinkObject *linkObject  = [[LinkObject alloc] init];
    linkObject.identifier   = dictionary[@"id"];
    linkObject.title        = dictionary[@"title"];
    linkObject.author       = dictionary[@"author"];
    linkObject.thumbnail    = dictionary[@"thumbnail"];
    linkObject.num_comments = [dictionary[@"num_comments"] longValue];
    linkObject.subreddit    = dictionary[@"subreddit"];
    
    double seconds = [dictionary[@"created_utc"] doubleValue];
    linkObject.createdDate  = [NSDate dateWithTimeIntervalSince1970:seconds];

    return linkObject;
}

-(NSString *)getTimeString
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                      fromDate:self.createdDate
                                                        toDate:currentDate
                                                       options:0];
    
    NSString *time;
    
    if (components.day > 0) {
        NSString *day = components.day < 1 ? @"%li days ago" : @"%li day ago";
        time = [NSString stringWithFormat:day ,(long)components.day];
    } else if (components.hour > 0) {
        NSString *hour = components.hour < 1 ? @"%li hours ago" : @"%li hour ago";
        time = [NSString stringWithFormat:hour ,(long)components.hour];
    }  else if (components.minute > 0) {
        NSString *minute = components.minute < 1 ? @"%li minutes ago" : @"%li minute ago";
        time = [NSString stringWithFormat:minute ,(long)components.minute];
    } else if (components.second > 0) {
        NSString *second = components.second < 1 ? @"%li seconds ago" : @"%li second ago";
        time = [NSString stringWithFormat:second ,(long)components.second];
    }
    
    return time;

}

@end


