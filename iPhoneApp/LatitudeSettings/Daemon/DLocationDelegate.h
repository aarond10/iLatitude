#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
@interface DLocationDelegate : NSObject <CLLocationManagerDelegate>
{
	BOOL trackingGPS;
	CLLocationManager *locationManager;
}
 
@property (nonatomic, retain) CLLocationManager *locationManager;
 
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		fromLocation:(CLLocation *)oldLocation;
 
- (void)locationManager:(CLLocationManager *)manager
	didFailWithError:(NSError *)error;
 
- (void) startIt:(NSTimer *) timer;
- (void) startItAgain:(NSTimer *)timer;
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
 
@end
