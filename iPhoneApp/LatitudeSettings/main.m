//
//  main.m
//  Latitude Settings
//
//  Created by Drew Aaron on 10/14/10.
//

#import <UIKit/UIKit.h>
#import "DLocationDelegate.h"

//  Based on code from http://www.chrisalvares.com/.
int runDaemon() {
	
	//start a pool
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	//initialize our LocationManager delegate so we can pick up GPS information
	DLocationDelegate *obj = [[DLocationDelegate alloc] init];
	
	//start a timer so that the process does not exit, this will GPS time to fetch and come back.
	NSDate *now = [[NSDate alloc] init];
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
		interval:10
		target:obj
		selector:@selector(startIt:)
		userInfo:nil
		repeats:YES];
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
	[runLoop run];
	
	[pool release];
	NSLog(@"Finished Everything, now closing");
	return 0;
}

int main(int argc, char *argv[]) {
    
	// Daemon mode in the same executable makes location permissions
	// a little less painful and makes for simpler packaging.
	if(argc == 2 && strcmp(argv[1],"-d") == 0) 
		return runDaemon();
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	int retVal = UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	return retVal;
}
