// LAF OS Library
// Copyright (C) 2018  Igara Studio S.A.
// Copyright (C) 2012-2018  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

//#define DEBUG_UPDATE_RECTS

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "os/skia/skia_window_ios.h"

#include "base/log.h"
#include "gfx/size.h"
#include "os/event.h"
#include "os/event_queue.h"
#include "os/ios/app.h"
#include "os/ios/window.h"
#include "os/skia/resize_surface.h"
#include "os/skia/skia_display.h"
#include "os/skia/skia_surface.h"
#include "os/system.h"

#include "mac/SkCGUtils.h"

#include <iostream>

namespace os {

class SkiaWindow::Impl : public IOSWindowImpl {
public:
  Impl(EventQueue* queue, SkiaDisplay* display,
       int width, int height, int scale)
    : m_display(display)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      m_window = [[IOSWindow alloc] initWithImpl:this
                                           width:width
                                           height:height
                                           scale:scale];
    });
  }

  ~Impl() {
  }

  void updateWindow(const gfx::Rect& rect) {
    if (!m_display->isInitialized())
      return;

    if (rect.isEmpty())
      return;

    @autoreleasepool {

      int scale = this->scale();
      UIView* view = m_window.view;

      SkiaSurface* surface = static_cast<SkiaSurface*>(m_display->getSurface());

      CGImageRef cgImage = SkCreateCGImageRef(surface->bitmap());

      dispatch_async(dispatch_get_main_queue(), ^{
        view.layer.contents = CFBridgingRelease(cgImage);
        [view setNeedsDisplay];
      });
    }
  }

  gfx::Size clientSize() const {
    return [m_window clientSize];
  }

  gfx::Size restoredSize() const {
    return [m_window restoredSize];
  }

  int scale() const {
    return [m_window scale];
  }

  void setScale(int scale) {
    [m_window setScale:scale];
  }

  void onResize(const gfx::Size& size) override {
    m_display->resize(size);
  }

  SkiaDisplay* m_display = nullptr;
  IOSWindow* m_window = nullptr;
};


SkiaWindow::SkiaWindow(EventQueue* queue, SkiaDisplay* display,
                       int width, int height, int scale)
  : m_impl(new Impl(queue, display,
                    width, height, scale))
{
}

SkiaWindow::~SkiaWindow()
{
  destroyImpl();
}

void SkiaWindow::destroyImpl()
{
  delete m_impl;
  m_impl = nullptr;
}

ColorSpacePtr SkiaWindow::colorSpace()
{
  return nullptr;
}

int SkiaWindow::scale() const
{
  if (m_impl) {
    int scale = m_impl->scale();
    // TODO:
    return MAX(1, scale);
  }
  else
    return 1;
}

void SkiaWindow::setScale(int scale)
{
  if (m_impl)
    m_impl->setScale(scale);
}

void SkiaWindow::setVisible(bool visible)
{
}

void SkiaWindow::maximize()
{
}

bool SkiaWindow::isMaximized() const
{
  return false;
}

bool SkiaWindow::isMinimized() const
{
  return false;
}

gfx::Size SkiaWindow::clientSize() const
{
  if (!m_impl)
    return gfx::Size(0, 0);

  return m_impl->clientSize();
}

gfx::Size SkiaWindow::restoredSize() const
{
  if (!m_impl)
    return gfx::Size(0, 0);

  return m_impl->restoredSize();
}


void SkiaWindow::setTitle(const std::string& title)
{
}

void SkiaWindow::captureMouse()
{
}

void SkiaWindow::releaseMouse()
{
}

void SkiaWindow::setMousePosition(const gfx::Point& position)
{
}

bool SkiaWindow::setNativeMouseCursor(NativeCursor cursor)
{
  return false;
}

bool SkiaWindow::setNativeMouseCursor(const Surface* surface,
                                      const gfx::Point& focus,
                                      const int scale)
{
  return false;
}

void SkiaWindow::updateWindow(const gfx::Rect& bounds)
{
  if (m_impl)
    m_impl->updateWindow(bounds);
}

void SkiaWindow::setTranslateDeadKeys(bool state)
{
}

void* SkiaWindow::handle()
{
  return nullptr;
}

} // namespace os
