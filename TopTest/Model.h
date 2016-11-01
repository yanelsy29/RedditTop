//
//  Model.h
//  TopTest
//
//  Created by Yanelsy Rivera on 10/31/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LinkObject : NSObject

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSDate *createdDate;
@property(nonatomic, strong) NSString *thumbnail;
@property(nonatomic, assign) long num_comments;
@property(nonatomic, strong) NSString *subreddit;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSString *)getTimeString;

@end
