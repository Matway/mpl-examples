#include <iostream>

int fibonacci(int n) {
  if (n < 2)
    return n;

  int result = 1;

  int acc = 0;
  for (int _ = 0; _ < n - 1; ++_) {
    int tmp = result;
    result += acc;
    acc = tmp;
  }

  return result;
}

int main() {
  int checksum = 0;

  for (int _ = 0; _ < int(1e7); ++_) {
    int i32FibMax = 46;
    for (int i = 0; i < i32FibMax + 1; ++i)
      checksum += fibonacci(i) % 2;
  }
  std::cout << checksum << std::endl;
}
