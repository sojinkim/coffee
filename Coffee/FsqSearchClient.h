//
//  FsqSearchClient.h
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 4..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import <CoreLocation/CoreLocation.h>

extern NSString * const fsqClientId;
extern NSString * const fsqClientSecret;
extern NSString * const fsqBaseURLString;
extern NSString * const apiVersion;

typedef enum {popularity=0, distance} SortBy;

@interface FsqSearchClient : AFHTTPClient
+ (FsqSearchClient *)sharedClient;
- (NSURLRequest *)makeNSURLRequestForCurrentLocation:(CLLocationCoordinate2D)currentCoordinate;
- (NSArray *)getCoffeeShopListFromJSON:(id)JSON sortedBy:(SortBy)criteria;
- (NSArray *)getSortedCoffeeShopListBy:(SortBy)criteria;
@end
