#pragma once

#include <cstdint>
#include <string_view>

struct RandomLcg {
  unsigned seed{};
  auto next() {
    return seed = seed * 0x8088405u + 1u;
  }
};

using Duration  = uint64_t;
using TimePoint = Duration;

extern "C" void startUp();                        // From MPL.
extern "C" void tearDown();                       //
extern "C" void storeCase(void *, int, Duration); //
extern "C" TimePoint tickCount();                 //
extern "C" Duration sinceTimePoint(TimePoint);    //

struct TestSystem {
  TestSystem() { startUp(); }
  ~TestSystem() { tearDown(); }

  TimePoint ticks() {
    return tickCount();
  }

  Duration since(TimePoint timePoint) {
    return sinceTimePoint(timePoint);
  }

  void store(std::string_view caseName, Duration caseTime) {
    storeCase((void *)caseName.data(), int(caseName.size()), caseTime);
  }
} test;
