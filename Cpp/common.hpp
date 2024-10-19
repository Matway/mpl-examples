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
using Timepoint = Duration;

extern "C" void startUp();                        // From MPL
extern "C" void tearDown();                       //
extern "C" void storeCase(void *, int, Duration); //
extern "C" Timepoint tickCount();                 //
extern "C" Duration sinceTimepoint(Timepoint);    //

struct TestSystem {
  TestSystem() { startUp(); }
  ~TestSystem() { tearDown(); }

  Timepoint ticks() {
    return tickCount();
  }

  Duration since(Timepoint Timepoint) {
    return sinceTimepoint(Timepoint);
  }

  void store(std::string_view caseName, Duration caseTime) {
    storeCase((void *)caseName.data(), int(caseName.size()), caseTime);
  }
} test;
