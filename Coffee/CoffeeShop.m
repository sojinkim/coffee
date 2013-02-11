//
//  CoffeeShop.m
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 11..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "CoffeeShop.h"

@interface CoffeeShop ()
@property (strong, nonatomic) NSDictionary *info;
@end

@implementation CoffeeShop

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    
    if (self) {
        _info = info;
    }
    return self;
}

- (NSString *)name
{
    return [self.info valueForKey:@"name"];
}

- (NSString *)address
{
    return [self.info valueForKeyPath:@"location.address"];
}

- (CLLocationCoordinate2D)coordinate
{
    NSNumber *latitude = [self.info valueForKeyPath:@"location.lat"];
    NSNumber *longitude = [self.info valueForKeyPath:@"location.lng"];
    
    NSLog(@"%g, %g", latitude.floatValue, longitude.floatValue);
    return CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
}

- (double)distance
{
    return [[self.info valueForKeyPath:@"location.distance"] doubleValue];
}

- (int)popularity
{
    return [[self.info valueForKeyPath:@"stats.checkinsCount"] intValue];
}

- (MapViewAnnotation *)makeAnnotation
{    
    return [[MapViewAnnotation alloc] initWithTitle:self.name andAddress:self.address andCoordinate:self.coordinate];
}

@end
