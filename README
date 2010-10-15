Google Latitude updater for iPhone
==================================

The code for this is broken into an iPhone application component and a
Google AppEngine component. 

The iPhone application is responsible for assigning the phone's 
uniqueIdentifier with a google account and periodically updating the locaiton.

The AppEngine component is responsible for OAuth authentication and storing
the Google Latitude access tokens associated with a given device.

Installation of the AppEngine component is straight-forward. 

*Note: You may skip this step if you're happy to use my existing appengine application.*

1. Create an new appengine application.

2. Visit https://www.google.com/accounts/ManageDomains and obtain an OAuth consumer and secret key.

3. Edit settings.py and add your key and secret.

4. Update your app: 

    $ appcfg.py update . 

Building and Installation of the iPhone is a little more complex.

1. Build the application with XCode.
2. Copy the built application to your devices /Applications/LatitudeSettings.app/ via SSH or some other means. 
3. Ensure that /Applications/LatitudeSettings.app/LatitudeSettings is executable (chmod a+x).
4. Copy com.aarondrew.LatitudeDaemon.plist to /System/Library/LaunchDaemons
5. Reboot your phone.

Once installed, launch the app and follow the instructions to link your phone to your latitude account (via the appengine app).

Done!

