#include <iostream>

#include <common.hpp>

int fibonacci(int n) {
  if (n < 2)
    return n;

  int result{1};

  int acc{};
  for (int _{}; _ < n - 1; ++_) {
    int tmp{result};
    result += acc;
    acc = tmp;
  }

  return result;
}

int main() {
  int checksum{};

  auto startPoint{test.ticks()};
  for (int _{}; _ < int(1e7); ++_) {
    int i32FibMax{46};
    for (int i{}; i < i32FibMax + 1; ++i)
      checksum += fibonacci(i) % 2;
  }
  auto time{test.since(startPoint)};

  std::cout << checksum << std::endl;
  test.store("fibonacciCycle", time);
}
