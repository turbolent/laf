// LAF OS Library
// Copyright (C) 2012-2016  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <UIKit/UIKit.h>

#include "os/ios/app.h"

#include "base/debug.h"
#include "base/thread.h"
#include "base/memory.h"
#include "os/ios/app_delegate.h"

extern int app_main(int argc, char* argv[]);

namespace os {

class IOSApp::Impl {
public:
  int init(int argc, char* argv[])
  {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil,
                                  NSStringFromClass([IOSAppDelegate class]));
    }
  }
};

static IOSApp* g_instance = nullptr;

// static
IOSApp* IOSApp::instance()
{
  return g_instance;
}

IOSApp::IOSApp()
  : m_impl(new Impl)
{
  ASSERT(!g_instance);
  g_instance = this;
}

IOSApp::~IOSApp()
{
  ASSERT(g_instance == this);
  g_instance = nullptr;
}

int IOSApp::init(int argc, char* argv[])
{
  return m_impl->init(argc, argv);
}

void IOSApp::didFinishLaunching() {
  char** argv = new char*[1];
  argv[0] = base_strdup("");
  int argc = 1;
  app_main(argc, argv);
}

} // namespace os
