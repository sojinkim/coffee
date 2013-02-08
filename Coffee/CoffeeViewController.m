//
//  CoffeeViewController.m
//  Coffee
//
//  Created by Sojin Kim on 13. 2. 4..
//  Copyright (c) 2013년 Sojin Kim. All rights reserved.
//

#import "CoffeeViewController.h"
#import "FsqSearchClient.h"
#import "MapViewController.h"
#import "MapViewAnnotation.h"
#import <AFNetworking.h>


@interface CoffeeViewController () {
    NSArray *jsonResponse;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray *coffeeShops;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation CoffeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.coffeeShops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [[self.coffeeShops objectAtIndex:[indexPath row]] valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ checkins / %@m ",[[self.coffeeShops objectAtIndex:[indexPath row]] valueForKeyPath:@"stats.checkinsCount"],[[self.coffeeShops objectAtIndex:[indexPath row]] valueForKeyPath:@"location.distance"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *myMapViewController = [[MapViewController alloc] init];
    
    NSDictionary *selectedCoffeeShop = [self.coffeeShops objectAtIndex:[indexPath row]];
   
    NSString *name = [selectedCoffeeShop valueForKey:@"name"];
    NSString *address = [selectedCoffeeShop valueForKeyPath:@"location.address"];
    
    NSNumber *latitude = [selectedCoffeeShop valueForKeyPath:@"location.lat"];
    NSNumber *longitude = [selectedCoffeeShop valueForKeyPath:@"location.lng"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);

    myMapViewController.title = name;
    myMapViewController.annotation = [[MapViewAnnotation alloc] initWithTitle:name andAddress:address andCoordinate:coordinate];
    
    [self.navigationController pushViewController:myMapViewController animated:YES];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
    if (newLocation != nil) {
        [self searchForCoffeeShopsNear:newLocation.coordinate];
    }
}

- (IBAction)sortBy:(UISegmentedControl *)sender
{
    [self sortResponseDataBy:[sender selectedSegmentIndex]];
}

- (IBAction)refresh:(id)sender
{
    [self.locationManager startUpdatingLocation];
}

- (void)searchForCoffeeShopsNear:(CLLocationCoordinate2D)currentCoordinate
{
    FsqSearchClient *client = [FsqSearchClient sharedClient];
    
    [self.spinner startAnimating];
    
    NSString *path = [NSString stringWithFormat:@"/v2/venues/search?ll=%g,%g&section=coffee&client_id=%@&client_secret=%@&categoryId=4bf58dd8d48988d16d941735,4bf58dd8d48988d1e0931735&v=%@", currentCoordinate.latitude, currentCoordinate.longitude, fsqClientId, fsqClientSecret, apiVersion];
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *opeation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        jsonResponse = [JSON valueForKeyPath:@"response.venues"];
        [self sortResponseDataBy:0];
        [self.spinner stopAnimating];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self.spinner stopAnimating];
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Network error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }];
    
    [opeation start];
}

- (void)sortResponseDataBy:(int)criteria
{
    NSString* keyString;
    if (0 == criteria) {
        keyString = @"stats.checkinsCount";
        self.coffeeShops = [jsonResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSNumber *first = [obj1 valueForKeyPath:keyString];
            NSNumber *second = [obj2 valueForKeyPath:keyString];
            return (NSComparisonResult)[second compare:first];
        }];
    }
    else if (1 == criteria) {
        keyString = @"location.distance";
        self.coffeeShops = [jsonResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSNumber *first = [obj1 valueForKeyPath:keyString];
            NSNumber *second = [obj2 valueForKeyPath:keyString];
            return (NSComparisonResult)[first compare:second];
        }];
    }
    
    [self.myTableView reloadData];
}

@end
