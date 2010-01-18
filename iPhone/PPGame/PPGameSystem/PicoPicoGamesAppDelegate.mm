/*
  PicoPicoGames

  Copyright (c) 2009, Hiromitsu Yamaguchi, All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer. 

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution. 

  3. Neither the name of the Yamagame nor the names of its contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission. 

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "PicoPicoGamesAppDelegate.h"
#import "RootViewController.h"
#import "QBSound.h"
#import "PPGameViewController.h"
#import "PPGameBGM.h"


@implementation PicoPicoGamesAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle


-(void) receivedRotate:(NSNotification*) notification
{
	if ([navigationController.topViewController isKindOfClass:[PPGameViewController class]]) {
		PPGameViewController* c = (PPGameViewController*)navigationController.topViewController;
		//UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
		[c receivedRotate:notification];
	}
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch    
//	[application setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];

//	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;

//	[[UIApplication sharedApplication] performSelector: @selector(startTVOut) withObject: nil afterDelay: .1];

	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receivedRotate:) name: UIDeviceOrientationDidChangeNotification object: nil];

	QBSound_SetCategory("ambient");
	QBSound_Start(4);
	QBSound_SetMasterVolume(0.8);
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	if ([navigationController.topViewController isKindOfClass:[PPGameViewController class]]) {
		PPGameViewController* c = (PPGameViewController*)navigationController.topViewController;
		[c exitGame];
	}

	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	
	[PPGameBGM stop];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	if ([navigationController.topViewController isKindOfClass:[PPGameViewController class]]) {
		PPGameViewController* c = (PPGameViewController*)navigationController.topViewController;
		[c resignActive];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if ([navigationController.topViewController isKindOfClass:[PPGameViewController class]]) {
		PPGameViewController* c = (PPGameViewController*)navigationController.topViewController;
		[c becomeActive];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

