//
//  CoffeeShop.h
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 11..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewAnnotation.h"

@interface CoffeeShop : NSObject

- (id)initWithInfo:(NSDictionary *)info;

- (NSString *)name;
- (NSString *)address;
- (CLLocationCoordinate2D)coordinate;
- (double)distance;
- (int)popularity;
- (MapViewAnnotation *)makeAnnotation;

@end
