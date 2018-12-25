// LAF OS Library
// Copyright (C) 2012-2016  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_IOS_APP_H_INCLUDED
#define OS_IOS_APP_H_INCLUDED
#pragma once

namespace base {
  class thread;
}

namespace os {

  class IOSApp {
  public:
    static IOSApp* instance();

    IOSApp();
    ~IOSApp();

    int init(int argc, char* argv[]);
    void didFinishLaunching();

  private:
    class Impl;
    Impl* m_impl;
  };

} // namespace os

#endif
