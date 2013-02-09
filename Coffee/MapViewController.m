//
//  MapViewController.m
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 7..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.annotation.coordinate, self.distance * 2.0f, self.distance * 2.0f);
    
    [self.mapView addAnnotation:self.annotation];
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
