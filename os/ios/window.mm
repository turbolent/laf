// LAF OS Library
// Copyright (C) 2012-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "os/ios/window.h"

#include "base/debug.h"
#include "os/event.h"
#include "os/event_queue.h"
#include "os/surface.h"

using namespace os;

@implementation IOSWindow

- (IOSWindow*)initWithImpl:(IOSWindowImpl*)impl
                     width:(int)width
                    height:(int)height
                     scale:(int)scale
{  
  m_impl = impl;
  m_scale = scale;

  self = [super init];

  [self setNeedsStatusBarAppearanceUpdate];

  // TODO: use UINavigationController?
  UIApplication.sharedApplication.delegate.window.rootViewController = self;

  return self;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (gfx::Size)clientSize
{
  return gfx::Size(self.view.frame.size.width,
                   self.view.frame.size.height);
}

- (gfx::Size)restoredSize
{
  return self.clientSize;
}

- (int)scale
{
  return m_scale;
}

- (void)setScale:(int)scale
{
  m_scale = scale;

  if (m_impl) {
    CGRect bounds = self.view.bounds;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
      m_impl->onResize(gfx::Size(bounds.size.width,
                                 bounds.size.height));
    });
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  if (m_impl) {
    CGRect bounds = self.view.bounds;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
      m_impl->onResize(gfx::Size(bounds.size.width,
                                 bounds.size.height));
    });
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
  [self touchesMoved:touches withEvent:event];

  UITouch *touch = [touches anyObject];
  CGPoint cgPoint = [touch locationInView:touch.view];

  gfx::Point point(cgPoint.x / m_scale, cgPoint.y / m_scale);

  Event ev;
  ev.setType(Event::MouseDown);
  ev.setPosition(point);
  ev.setButton(Event::LeftButton);
  ev.setPointerType(os::PointerType::Cursor);

  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    os::queue_event(ev);
  });
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
  UITouch *touch = [touches anyObject];
  CGPoint cgPoint = [touch locationInView:touch.view];
  
  gfx::Point point(cgPoint.x / m_scale, cgPoint.y / m_scale);

  Event ev;
  ev.setType(Event::MouseMove);
  ev.setPosition(point);
  ev.setButton(Event::LeftButton);
  ev.setPointerType(os::PointerType::Cursor);

  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    os::queue_event(ev);
  });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  UITouch *touch = [touches anyObject];
  CGPoint cgPoint = [touch locationInView:touch.view];

  gfx::Point point(cgPoint.x / m_scale, cgPoint.y / m_scale);

  Event ev;
  ev.setType(Event::MouseUp);
  ev.setPosition(point);
  ev.setButton(Event::LeftButton);
  ev.setPointerType(os::PointerType::Cursor);

  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    os::queue_event(ev);
  });
}

@end
