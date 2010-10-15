//
//  DLocationDelegate.m
//
//  Created by Chris Alvares on 3/25/09.
//  Copyright 2009 Chris Alvares. All rights reserved.
//
//
 
#import <UIKit/UIKit.h>
#import "DLocationDelegate.h"
 
#define NSURLRequestReloadIgnoringLocalCacheData 1
 
@implementation DLocationDelegate
@synthesize locationManager;
 
-(id) init
{
	if (self = [super init])
	{
		trackingGPS = false;
 
		NSLog(@"starting the location Manager");
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = 100;
		self.locationManager.distanceFilter = 200;
	}
	return self;
}
 
//this function is to only be called once.
-(void) startIt:(NSTimer *) timer
{
	NSLog(@"startIt:");
	if(timer != nil) [timer invalidate];
	trackingGPS = true;
	[self.locationManager startUpdatingLocation];
}
 
//the difference in this function is that it invalidates the timer function, and can run more than one time
-(void) startItAgain:(NSTimer *)timer
{
	NSLog(@"startItAgain:");
	if(!trackingGPS)
	{
		trackingGPS = true;
		[self.locationManager startUpdatingLocation];
//		[self.locationManager startMonitoringSignificantLocationChanges];
	}
}
 
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation
{
	srandom(time(0)); //do this to make sure that it does not use a cached page
	NSLog(@"Location found");
	
	if([newLocation horizontalAccuracy] <= 300 && [newLocation horizontalAccuracy] > 0)
	{
		[self.locationManager stopUpdatingLocation];
		NSNumber *num = [NSNumber numberWithInt:(random())];
		NSString *devId = [[UIDevice currentDevice] uniqueIdentifier];
		
		NSLog(@"Latitude %lf  Longitude %lf", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		NSLog(@"Dev ID: %@", devId);
		
		NSNumber *latitude = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
		NSNumber *longitude = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
		//NSNumber *altitude = [[NSNumber alloc] initWithDouble:newLocation.altitude];
		NSNumber *accuracy = [[NSNumber alloc] initWithDouble:newLocation.horizontalAccuracy];
 
		NSMutableString *str = [[NSMutableString alloc] 
								initWithString:@"http://iphone-latitude.appspot.com/update?id="];
		[str appendString:devId];
		[str appendString:@"&lat="];
		[str appendString:[latitude stringValue]];
		[str appendString:@"&lon="];
		[str appendString:[longitude stringValue]];
 		//[str appendString:@"&alt="];
		//[str appendString:[altitude stringValue]];
		[str appendString:@"&acc="];
		[str appendString:[accuracy stringValue]];
		[str appendString:@"&random="];
		[str appendString:[num stringValue]];

		
		NSLog(@"URL: %@", str);
		NSURL *theURL = [[NSURL alloc] initWithString:str];
 
		NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL
													cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
												timeoutInterval:120];
 
 
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest 
																	  delegate:self 
															  startImmediately:YES];
		if(connection == nil)
		{
			trackingGPS = NO;
		}		
 
		NSLog(@"setting timer for 30 minutes");
		NSTimer *timer =  [[NSTimer
							timerWithTimeInterval:1800.0
							target:self
							selector:@selector(startItAgain:)
							userInfo:nil
							repeats:NO
							] retain];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
 
		[timer release];
		[latitude release];
		[longitude release];
		//[altitude release];
		[accuracy release];
		[theURL release];
	}
	else
	{
		NSLog(@"Accuracy not good enough %lf", [newLocation horizontalAccuracy]);
 
	}
}
 
- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
	trackingGPS = false;
 
	if ([error domain] == kCLErrorDomain) {
		// We handle CoreLocation-related errors here
		switch ([error code]) {
		
		// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
		// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
		case kCLErrorDenied:
		{
			CFOptionFlags responseFlags = 0;
			CFUserNotificationDisplayAlert(20.0, 3, NULL, NULL, NULL, CFSTR("iLatitude Error"), CFSTR("Can't access location. To re-enable location access, go to Settings > General > Reset > Reset Location Warnings."), CFSTR("OK"), NULL, NULL, &responseFlags);
			NSLog(@"trackingGPS failed: %@", [error localizedDescription]);
			break;
		}
		case kCLErrorLocationUnknown:
			NSLog(@"trackingGPS failed: %@", [error localizedDescription]);
			break;
		default:
			break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		NSLog(@"trackingGPS failed: %@", [error localizedDescription]);
	}
}
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"GPS information Sent");
	trackingGPS = false;	
}
 
 
-(void) dealloc
{
	NSLog(@"dealloc");
	[locationManager release];
	[super dealloc];
}
@end
