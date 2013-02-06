//
//  MapViewAnnotation.h
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 7..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title andAddress:(NSString *)address andCoordinate:(CLLocationCoordinate2D)coordinate;
@end
