//
//  FsqSearchClient.m
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 4..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "FsqSearchClient.h"
#import <AFJSONRequestOperation.h>

NSString * const fsqClientId = @"J3KBMODGRX1E3SLITSB1SACZKZ1M1EM4UICECVOSQT0PXJBX";
NSString * const fsqClientSecret = @"VK2GXUI3AEV0ISVVIW3MDVJ3RAUDUALEAOKPUNRMOOX4XMBR";
NSString * const fsqBaseURLString = @"https://api.foursquare.com/";
NSString * const apiVersion = @"20130204";

@implementation FsqSearchClient
+ (FsqSearchClient *)sharedClient
{
    static FsqSearchClient *fsqClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{fsqClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:fsqBaseURLString]];});
    
    return fsqClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}

@end
