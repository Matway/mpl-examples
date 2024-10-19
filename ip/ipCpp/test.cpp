#include <cstdint>
#include <iostream>

#include <common.hpp>

unsigned convertToInt(uint8_t* ip, int size) {
  unsigned result{};

  for (int i{}; i < size; ++i) {
    switch (i) {
      case 0: result += ip[i] * 256 * 256 * 256; break;
      case 1: result += ip[i] * 256 * 256;       break;
      case 2: result += ip[i] * 256;             break;
      case 3: result += ip[i];                   break;
    }
  }

  return result;
}

int main() {
  uint64_t result{};
  uint8_t ip[4];

  auto startPoint{test.ticks()};

  for (int i{}; i < 256; ++i) {
    ip[0] = i;
    result += convertToInt(ip, 1);
  }

  for (int i{}; i < 256; ++i) {
    ip[0] = i;
    for (int i{}; i < 256; ++i) {
      ip[1] = i;
      result += convertToInt(ip, 2);
    }
  }

  for (int i{}; i < 256; ++i) {
    ip[0] = i;
    for (int i{}; i < 256; ++i) {
      ip[1] = i;
      for (int i{}; i < 256; ++i) {
        ip[2] = i;
        result += convertToInt(ip, 3);
      }
    }
  }

  for (int i{}; i < 256; ++i) {
    ip[0] = i;
    for (int i{}; i < 256; ++i) {
      ip[1] = i;
      for (int i{}; i < 256; ++i) {
        ip[2] = i;
        for (int i{}; i < 256; ++i) {
          ip[3] = i;
          result += convertToInt(ip, 4);
        }
      }
    }
  }
  auto time{test.since(startPoint)};

  std::cout << result << std::endl;
  std::cout << 9259542112527974400ull << std::endl;
  test.store("ip", time);
}
