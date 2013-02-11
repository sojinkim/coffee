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

@interface FsqSearchClient(){
    NSArray *jsonResponse;
}
@property (strong, nonatomic) NSArray *coffeeShops;

@end

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

- (NSURLRequest *)makeNSURLRequestForCurrentLocation:(CLLocationCoordinate2D)currentCoordinate
{
    NSString *path = [NSString stringWithFormat:@"/v2/venues/search"];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     @"ll",
                     @"radius",
                     @"client_id",
                     @"client_secret",
                     @"categoryId",
                     @"v",
                     nil];
    NSArray *values = [[NSArray alloc] initWithObjects:
                       [NSString stringWithFormat:@"%g,%g", currentCoordinate.latitude, currentCoordinate.longitude],
                       [NSNumber numberWithInt:2000],
                       fsqClientId,
                       fsqClientSecret,
                       @"4bf58dd8d48988d16d941735,4bf58dd8d48988d1e0931735",
                       apiVersion,
                       nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    
    return [self requestWithMethod:@"GET" path:path parameters:params];
}

- (NSArray *)getCoffeeShopListFromJSON:(id)JSON sortedBy:(SortBy)criteria
{
    jsonResponse = [JSON valueForKeyPath:@"response.venues"];
    return [self getSortedCoffeeShopListBy:criteria];
}

- (NSArray *)getSortedCoffeeShopListBy:(SortBy)criteria
{
    NSString* keyString;
    if (popularity == criteria) {
        keyString = @"stats.checkinsCount";
        self.coffeeShops = [jsonResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSNumber *first = [obj1 valueForKeyPath:keyString];
            NSNumber *second = [obj2 valueForKeyPath:keyString];
            return (NSComparisonResult)[second compare:first];
        }];
    }
    else if (distance == criteria) {
        keyString = @"location.distance";
        self.coffeeShops = [jsonResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSNumber *first = [obj1 valueForKeyPath:keyString];
            NSNumber *second = [obj2 valueForKeyPath:keyString];
            return (NSComparisonResult)[first compare:second];
        }];
    }
   
    return self.coffeeShops;
}

@end
