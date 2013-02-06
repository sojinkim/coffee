//
//  MapViewAnnotation.m
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 7..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

- (id)initWithTitle:(NSString *)title andAddress:(NSString *)address andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self) {
        _title = title;
        _subtitle = address;
        _coordinate = coordinate;
    }
    return self;
}

@end
