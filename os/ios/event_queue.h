// LAF OS Library
// Copyright (C) 2018  Igara Studio S.A.
// Copyright (C) 2015-2016  David Capello
//
// This file is released under the terms of the MIT license.
// Read LICENSE.txt for more information.

#ifndef OS_IOS_EVENT_QUEUE_INCLUDED
#define OS_IOS_EVENT_QUEUE_INCLUDED
#pragma once

#include "base/concurrent_queue.h"
#include "os/event.h"
#include "os/event_queue.h"

namespace os {

class IOSEventQueue : public EventQueue {
public:
  void getEvent(Event& ev, bool canWait) override;
  void queueEvent(const Event& ev) override;

private:
  base::concurrent_queue<Event> m_events;
  bool m_sleeping = false;
};

typedef IOSEventQueue EventQueueImpl;

} // namespace os

#endif
