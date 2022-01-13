#include <iostream>

int find(uint8_t* data, int size, uint8_t number) {
  int count = 0;

  for (int i = 0; i < size; i++) {
    if (data[i] == number) {
      count++;
    }
  }

  return count;
}

int main() {
  int result = 0;
  uint8_t data[4];

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      int res = find(data, 1, i);
      if (res >= 1) {
        result++;
      }
    }
  }

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      data[1] = i;
      for (int i = 0; i < 256; ++i) {
        int res = find(data, 2, i);
        if (res >= 1) {
          result++;
        }
      }
    }
  }

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      data[1] = i;
      for (int i = 0; i < 256; ++i) {
        data[2] = i;
        for (int i = 0; i < 256; ++i) {
          int res = find(data, 3, i);
          if (res >= 1) {
            result++;
          }
        }
      }
    }
  }

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      data[1] = i;
      for (int i = 0; i < 256; ++i) {
        data[2] = i;
        for (int i = 0; i < 256; ++i) {
          data[3] = i;
          for (int i = 0; i < 256; ++i) {
            int res = find(data, 4, i);
            if (res >= 1) {
              result++;
            }
          }
        }
      }
    }
  }

  std::cout << result << std::endl;
}
