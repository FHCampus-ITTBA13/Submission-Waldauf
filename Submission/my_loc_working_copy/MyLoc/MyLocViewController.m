//
//  MyLocViewController.m
//  MyLoc
//
//  Created by miwa on 3/8/13.
//  Copyright (c) 2013 mw. All rights reserved.
//

#import "MyLocViewController.h"

@interface MyLocViewController ()



@end

@implementation MyLocViewController

@synthesize username = _username;
@synthesize locationManager, currentLocation;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Zuerst wird ein locationManager erzeugt, dann gestartet.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter=(int)self.sliDelta.value;
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
     
}

// Falls die App in den Background geschickt wird arbeitet sie weiter

- (void)applicationDidEnterBackground:(UIApplication *)application{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter=(int)self.sliDelta.value;
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Deaktiviert/aktiviert das Tracking

-(IBAction)changeSwitch:(id)sender{
    
    NSLog(@"switch event");    
    
    if (self.sliStartTracking.on) {
        [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
   
    }
    else {
     NSLog(@"switch off");
        [locationManager stopUpdatingLocation];
        [locationManager stopMonitoringSignificantLocationChanges];
        
        
    }
}

-(IBAction)sliDeltachange:(id)sender{
    NSLog(@"sli event");
locationManager.distanceFilter=(int)self.sliDelta.value;
self.labUpdateDistance.text=[NSString stringWithFormat:@"%d m", (int)self.sliDelta.value];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    self.labLatitude.text= [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    self.labLongitude.text= [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    self.labSpeed.text= [NSString stringWithFormat:@"%f m/s", self.currentLocation.speed];
    self.labAccu.text= [NSString stringWithFormat:@"%f m", self.currentLocation.horizontalAccuracy];
 
    
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];
    [mainQueue setMaxConcurrentOperationCount:1];
    
    
// Server bekommt einen Request mit Latitude und Logitude  
    
    NSString *infourl=@"http://192.168.1.119:8000/loc.html?";
    infourl=[infourl stringByAppendingString:[NSString stringWithFormat:@"%f?%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude]];

    
    NSURL *url = [NSURL URLWithString:infourl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:@{@"Accepts-Encoding": @"gzip", @"Accept": @"application/json"}];
    [request setTimeoutInterval:1];
    
    [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            NSLog(@"Status Code: %li %@", (long)urlResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Response Body: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
       }
        else {
            NSLog(@"An error occured, Status Code: %i", urlResponse.statusCode);
            NSLog(@"Description: %@", [error localizedDescription]);
            NSLog(@"Response Body: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            

            
        }
    }];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)viewDidUnload {

    [self setSliStartTracking:nil];
    [self setLabLatitude:nil];
    [self setLabLongitude:nil];
    [self setLabSpeed:nil];
    [self setLabAccu:nil];
    [self setSliDelta:nil];
    [self setSliDelta:nil];
    [self setLabUpdateDistance:nil];
    [super viewDidUnload];
}
@end
