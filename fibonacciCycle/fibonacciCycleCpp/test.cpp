#include <iostream>

#include <common.hpp>

int fibonacci(int n) {
  int result{};
  int last{1};

  while(0 < n) {
    --n;
    int temp{result};
    result += last;
    last = temp;
  }

  return result;
}

int main() {
  int checksum{};

  auto startPoint{ticks()};
  for (int _{}; _ < int(1e7); ++_) {
    int i32FibMax{46};
    for (int i{}; i < i32FibMax + 1; ++i)
      checksum += fibonacci(i) % 2;
  }
  auto time{since(startPoint)};

  std::cout << checksum << std::endl;
  store("fibonacciCycle", time);
}
