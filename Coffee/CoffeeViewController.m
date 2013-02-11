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
#import "CoffeeShop.h"

@interface CoffeeViewController () 
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrder;
@property (strong, nonatomic) NSArray *coffeeShops;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FsqSearchClient *client;

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
    
    CoffeeShop *coffeeShop = [self.client getCoffeeShopAtIndex:[indexPath row]];
    
    cell.textLabel.text = coffeeShop.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d checkins / %gm ", coffeeShop.popularity, coffeeShop.distance];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *myMapViewController = [[MapViewController alloc] init];

    CoffeeShop *selectedCoffeeShop = [self.client getCoffeeShopAtIndex:[indexPath row]];
    
    myMapViewController.title = [selectedCoffeeShop name];
    myMapViewController.annotation = [selectedCoffeeShop makeAnnotation];
    myMapViewController.distance = [selectedCoffeeShop distance];
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    [self searchForCoffeeShopsNear:((CLLocation *)locations.lastObject).coordinate];
}

- (IBAction)sortBy:(UISegmentedControl *)sender
{
    self.coffeeShops = [self.client getSortedCoffeeShopListBy:sender.selectedSegmentIndex];
    [self.myTableView reloadData];
}

- (IBAction)refresh:(id)sender
{
    [self.locationManager startUpdatingLocation];
}

- (void)searchForCoffeeShopsNear:(CLLocationCoordinate2D)currentCoordinate
{
    self.client = [FsqSearchClient sharedClient];
    
    [self.spinner startAnimating];
    
    NSURLRequest *request = [self.client makeNSURLRequestForCurrentLocation:currentCoordinate];
    NSLog(@"%@", request);
    
    AFJSONRequestOperation *opeation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.coffeeShops = [self.client getCoffeeShopListFromJSON:JSON sortedBy:self.sortOrder.selectedSegmentIndex];
        [self.spinner stopAnimating];
        [self.myTableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self.spinner stopAnimating];
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Network error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }];
    
    [opeation start];
}

@end
