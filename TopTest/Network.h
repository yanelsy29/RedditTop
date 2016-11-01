//
//  Network.h
//  TopTest
//
//  Created by Yanelsy Rivera on 10/31/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

typedef void (^NKSRequestCompletionBlock)(id responseObject, NSError *error);

@interface Request : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NKSRequestCompletionBlock completionHandler;

+(void)requestLinksWithResponse: (void (^)(NSArray *response, NSError *error)) responseBlock;

@end
