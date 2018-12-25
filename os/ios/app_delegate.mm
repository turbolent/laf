// LAF OS Library
// Copyright (C) 2012-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <UIKit/UIKit.h>

#include "os/ios/app_delegate.h"

#include "base/fs.h"
#include "os/event.h"
#include "os/event_queue.h"
#include "os/ios/app.h"
#include "os/system.h"

@implementation IOSAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window.rootViewController = [UIViewController new];
  [self.window makeKeyAndVisible];

  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    os::IOSApp::instance()->didFinishLaunching();
  });

  return YES;
}

@end
