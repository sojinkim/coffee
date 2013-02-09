//
//  MapViewController.h
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 7..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"

@interface MapViewController : UIViewController
@property (strong, nonatomic) MapViewAnnotation *annotation;
@property double distance;
@end
