// LAF OS Library
// Copyright (C) 2012-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_IOS_APP_DELEGATE_H_INCLUDED
#define OS_IOS_APP_DELEGATE_H_INCLUDED
#pragma once

#include <UIKit/UIKit.h>

@interface IOSAppDelegate : NSObject<UIApplicationDelegate>

@property (nonatomic, retain) UIWindow* window;

@end

#endif
