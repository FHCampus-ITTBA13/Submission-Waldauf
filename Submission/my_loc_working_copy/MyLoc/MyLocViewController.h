//
//  MyLocViewController.h
//  MyLoc
//
//  Created by miwa on 3/8/13.
//  Copyright (c) 2013 mw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tfname;
@property (strong, nonatomic) IBOutlet UILabel *laboutput;
@property (strong, nonatomic) IBOutlet UIButton *butok;
@property (strong, nonatomic) IBOutlet UILabel *lablat;
@property (strong, nonatomic) IBOutlet UILabel *lablong;
@property (strong, nonatomic) IBOutlet UISwitch *sliStartTracking;
@property (strong, nonatomic) IBOutlet UILabel *labLatitude;
@property (strong, nonatomic) IBOutlet UILabel *labLongitude;
@property (strong, nonatomic) IBOutlet UILabel *labSpeed;
@property (strong, nonatomic) IBOutlet UISlider *sliDelta;
@property (strong, nonatomic) IBOutlet UILabel *labUpdateDistance;

@property (strong, nonatomic) IBOutlet UILabel *labAccu;
- (IBAction)sliDeltachange:(id)sender;



-(IBAction)changeSwitch:(id)sender;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@property (copy, nonatomic) NSString *username;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;




@end
