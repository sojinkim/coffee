//
//  FsqSearchClient.h
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 4..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const fsqClientId;
extern NSString * const fsqClientSecret;
extern NSString * const fsqBaseURLString;
extern NSString * const apiVersion;

@interface FsqSearchClient : AFHTTPClient
+ (FsqSearchClient *)sharedClient;
@end
