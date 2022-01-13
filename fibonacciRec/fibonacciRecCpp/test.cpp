#include <iostream>

int fibonacciRec(unsigned int number) {
  if (number <= 1) {
    return number;
  } else {
    return fibonacciRec(number - 1) + fibonacciRec(number - 2);
  }
}

int main() {
  uint64_t result = 0;

  for (int i = 0; i < 45; ++i) {
    result += fibonacciRec(i);
  }

  std::cout << result << std::endl;
}
