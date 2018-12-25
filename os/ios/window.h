// LAF OS Library
// Copyright (C) 2018  Igara Studio S.A.
// Copyright (C) 2012-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_IOS_WINDOW_H_INCLUDED
#define OS_IOS_WINDOW_H_INCLUDED
#pragma once

#include <UIKit/UIKit.h>

#include "gfx/point.h"
#include "gfx/rect.h"
#include "gfx/size.h"
#include "os/keys.h"
#include "os/native_cursor.h"

namespace os {
  class Surface;
}

class IOSWindowImpl {
public:
  virtual ~IOSWindowImpl() { }
  virtual void onResize(const gfx::Size& size) = 0;
};


@class IOSWindowDelegate;

@interface IOSWindow : UIViewController {
  @private
  IOSWindowImpl* m_impl;
  int m_scale;
}

@property(strong) UIViewController *viewController;

- (IOSWindow*)initWithImpl:(IOSWindowImpl*)impl
                     width:(int)width
                    height:(int)height
                     scale:(int)scale;
- (gfx::Size)clientSize;
- (gfx::Size)restoredSize;
- (int)scale;
- (void)setScale:(int)scale;
@end

#endif
