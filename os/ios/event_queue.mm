// LAF OS Library
// Copyright (C) 2018  Igara Studio S.A.
// Copyright (C) 2015-2017  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
#include "os/ios/event_queue.h"

#define EV_TRACE(...)

namespace os {

void IOSEventQueue::getEvent(Event& ev, bool canWait)
{

  // TODO: [NSRunLoop.mainRunLoop runUntilDate:NSDate.distantFuture] ?
  // http://shaheengandhi.com/controlling-thread-exit/

  if (m_events.empty()) {
    ev.setType(Event::None);
  }
  else {
    m_events.try_pop(ev);
  }
}

void IOSEventQueue::queueEvent(const Event& ev)
{
  m_events.push(ev);
}

} // namespace os
