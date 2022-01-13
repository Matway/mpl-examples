#include <iostream>

uint64_t fibonacci(uint64_t number) {
  if (number <= 1) {
    return number;
  }

  uint64_t fib1 = 0;
  uint64_t fib2 = 1;
  uint64_t result = 1;
  for (uint64_t i = 0; i < number; i++)
  {
    fib1 = fib2;
    fib2 = i;
    result += fib1 + fib2;
  }

  return result;
}

int main() {
  uint64_t result = 0;

  for (int i = 0; i < 10000000; ++i) {
    for (int i = 0; i < 45; ++i) {
      result += fibonacci(i) % 2;
    }
  }

  std::cout << result << std::endl;
}
