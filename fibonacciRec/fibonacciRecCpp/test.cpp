#include <iostream>
#include <limits>

#include <common.hpp>

int fibonacci(int n) {
  if (n < 2)
    return n;
  else
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
  unsigned checksum{};

  auto startPoint{ticks()};
  constexpr int i32FibMax{46};
  for (int i{}; i < i32FibMax + 1; ++i)
    checksum ^= unsigned(fibonacci(i));
  auto time{since(startPoint)};

  std::cout << checksum << std::endl;
  store("fibonacciRec", time);
}
