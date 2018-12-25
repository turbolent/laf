// LAF OS Library
// Copyright (C) 2016  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_IOS_SYSTEM_H
#define OS_IOS_SYSTEM_H
#pragma once

#include "os/common/system.h"

namespace os {

class IOSSystem : public CommonSystem {
public:
  bool isKeyPressed(KeyScancode scancode) override {
    // TODO
    return false;
  }

  int getUnicodeFromScancode(KeyScancode scancode) override {
    // TODO
    return 0;
  }
};

} // namespace os

#endif
