// LAF OS Library
// Copyright (C) 2018  Igara Studio S.A.
// Copyright (C) 2012-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_SKIA_SKIA_SYSTEM_INCLUDED
#define OS_SKIA_SKIA_SYSTEM_INCLUDED
#pragma once

#include "base/base.h"
#include "gfx/color_space.h"
#include "gfx/size.h"
#include "os/common/system.h"
#include "os/skia/skia_color_space.h"
#include "os/skia/skia_display.h"
#include "os/skia/skia_surface.h"

#ifdef _WIN32
  #include "os/win/color_space.h"
  #include "os/win/system.h"
  #define SkiaSystemBase WindowSystem
#elif __APPLE__
  #include <TargetConditionals.h>
  #if TARGET_OS_IPHONE
    #include "os/ios/system.h"
    #define SkiaSystemBase IOSSystem
  #else
    #include "os/osx/color_space.h"
    #include "os/osx/system.h"
    #define SkiaSystemBase OSXSystem
  #endif
#else
  #include "os/x11/system.h"
  #define SkiaSystemBase X11System
#endif

#include "SkGraphics.h"

namespace os {

class SkiaSystem : public SkiaSystemBase {
public:
  SkiaSystem()
    : m_defaultDisplay(nullptr)
    , m_gpuAcceleration(false) {
    SkGraphics::Init();
  }

  ~SkiaSystem() {
    SkGraphics::Term();
  }

  Capabilities capabilities() const override {
    return Capabilities(
      int(Capabilities::MultipleDisplays) |
      int(Capabilities::CanResizeDisplay) |
      int(Capabilities::DisplayScale) |
      int(Capabilities::CustomNativeMouseCursor) |
      int(Capabilities::ColorSpaces)
    // TODO enable this when the GPU support is ready
#if 0 // SK_SUPPORT_GPU
      | int(Capabilities::GpuAccelerationSwitch)
#endif
      );
  }

  bool gpuAcceleration() const override {
    return m_gpuAcceleration;
  }

  void setGpuAcceleration(bool state) override {
    m_gpuAcceleration = state;
  }

  gfx::Size defaultNewDisplaySize() override {
    gfx::Size sz;
#ifdef _WIN32
    sz.w = GetSystemMetrics(SM_CXMAXIMIZED);
    sz.h = GetSystemMetrics(SM_CYMAXIMIZED);
    sz.w -= GetSystemMetrics(SM_CXSIZEFRAME)*4;
    sz.h -= GetSystemMetrics(SM_CYSIZEFRAME)*4;
    sz.w = MAX(0, sz.w);
    sz.h = MAX(0, sz.h);
#endif
    return sz;
  }

  Display* defaultDisplay() override {
    return m_defaultDisplay;
  }

  Display* createDisplay(int width, int height, int scale) override {
    SkiaDisplay* display = new SkiaDisplay(width, height, scale);
    if (!m_defaultDisplay)
      m_defaultDisplay = display;
    return display;
  }

  Surface* createSurface(int width, int height,
                         const os::ColorSpacePtr& colorSpace) override {
    SkiaSurface* sur = new SkiaSurface;
    sur->create(width, height, colorSpace);
    return sur;
  }

  Surface* createRgbaSurface(int width, int height,
                             const os::ColorSpacePtr& colorSpace) override {
    SkiaSurface* sur = new SkiaSurface;
    sur->createRgba(width, height, colorSpace);
    return sur;
  }

  Surface* loadSurface(const char* filename) override {
    return SkiaSurface::loadSurface(filename);
  }

  Surface* loadRgbaSurface(const char* filename) override {
    return loadSurface(filename);
  }

  void setTranslateDeadKeys(bool state) override {
    if (m_defaultDisplay)
      m_defaultDisplay->setTranslateDeadKeys(state);
  }

  void listColorSpaces(std::vector<os::ColorSpacePtr>& list) override {
    list.push_back(createColorSpace(gfx::ColorSpace::MakeNone()));
    list.push_back(createColorSpace(gfx::ColorSpace::MakeSRGB()));

#if defined(_WIN32) || (defined(__APPLE__) && !TARGET_OS_IPHONE)
    list_display_colorspaces(list);
#endif
  }

  os::ColorSpacePtr createColorSpace(const gfx::ColorSpacePtr& cs) override {
    return std::make_shared<SkiaColorSpace>(cs);
  }

  std::unique_ptr<ColorSpaceConversion> convertBetweenColorSpace(
    const os::ColorSpacePtr& src,
    const os::ColorSpacePtr& dst) override {
    return std::unique_ptr<SkiaColorSpaceConversion>(
      new SkiaColorSpaceConversion(src, dst));
  }

private:
  SkiaDisplay* m_defaultDisplay;
  bool m_gpuAcceleration;
};

} // namespace os

#endif
