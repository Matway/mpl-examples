#pragma once

#include <algorithm>
#include <chrono>
#include <iostream>
#include <string_view>

struct RandomLcg {
  unsigned seed{};
  auto next() {
    return seed = seed * 0x8088405u + 1u;
  }
};

template<class Duration>
void store(std::string_view caseName, Duration caseTime) {
  auto bar{
    [](auto text) {
      using namespace std::string_view_literals;

      auto placeholder{"-------------------"sv};
      auto length{std::max((int)(placeholder.length() - text.length()), 1)};

      return placeholder.substr(0, length);
    }
  };

  auto indent{bar(caseName)};

  std::cerr << caseName << " " << indent << " " << caseTime << std::endl;
}

auto ticks() {
  return std::chrono::steady_clock::now();
}

template<class Timepoint>
auto since(Timepoint point) {
  return std::chrono::duration_cast<std::chrono::duration<double>>(ticks() - point);
}
