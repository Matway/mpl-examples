#include <iostream>

int fibonacci(int n) {
  if (n < 2)
    return n;
  else
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
  unsigned checksum = 0u;

  int i32FibMax = 46;
  for (int i = 0; i < i32FibMax + 1; ++i)
    checksum ^= unsigned(fibonacci(i));

  std::cout << checksum << std::endl;
}
