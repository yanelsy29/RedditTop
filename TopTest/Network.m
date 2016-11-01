//
//  Network.m
//  TopTest
//
//  Created by Yanelsy Rivera on 10/31/16.
//  Copyright © 2016 Yanelsy Rivera. All rights reserved.
//

#import "Network.h"

@implementation Request

+(Request *)requestWithUrl:(NSString *)url
         completionHandler:(NKSRequestCompletionBlock) completionHandler
{
    Request *request = [[Request alloc] init];
    request.url = [NSURL URLWithString:url];
    request.completionHandler = completionHandler;
    
    return request;
}

-(void)perform
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               if (data) {
                                   id JSON  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   self.completionHandler(JSON, nil);
                               } else {
                                   self.completionHandler(nil, connectionError);
                               }
                           }];
}

+(void)requestLinksWithResponse: (void (^)(NSArray *response, NSError *error)) responseBlock
{
    NSString *url = @"https://www.reddit.com/top/.json";
    
    Request *request = [Request requestWithUrl:url
                             completionHandler:^(id responseObject, NSError *error) {
                                 
                                 NSArray *childrens = responseObject[@"data"][@"children"];
                                 
                                 responseBlock(childrens, error);
                                 
                             }];
    [request perform];
}

@end
