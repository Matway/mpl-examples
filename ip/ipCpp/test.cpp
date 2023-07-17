#include <iostream>

uint32_t convertToInt(uint8_t* ip, int size) {
  uint32_t result = 0;
  for (int i = 0; i < size; ++i)
  {
    switch (i)
    {
    case 0:
      result += ip[i] * 256 * 256 * 256;
      break;
    case 1:
      result += ip[i] * 256 * 256;
      break;
    case 2:
      result += ip[i] * 256;
      break;
    case 3:
      result += ip[i];
      break;
    }
  }

  return result;
}

int main() {
  uint64_t result = 0;
  uint8_t ip[4];

  for (int i = 0; i < 256; ++i) {
    ip[0] = i;
    uint32_t res = convertToInt(ip, 1);
    result += res;
  }

  for (int i = 0; i < 256; ++i) {
    ip[0] = i;
    for (int i = 0; i < 256; ++i) {
      ip[1] = i;
      uint32_t res = convertToInt(ip, 2);
      result += res;
    }
  }

  for (int i = 0; i < 256; ++i) {
    ip[0] = i;
    for (int i = 0; i < 256; ++i) {
      ip[1] = i;
      for (int i = 0; i < 256; ++i) {
        ip[2] = i;
        uint32_t res = convertToInt(ip, 3);
        result += res;
      }
    }
  }

  for (int i = 0; i < 256; ++i) {
    ip[0] = i;
    for (int i = 0; i < 256; ++i) {
      ip[1] = i;
      for (int i = 0; i < 256; ++i) {
        ip[2] = i;
        for (int i = 0; i < 256; ++i) {
          ip[3] = i;
          uint32_t res = convertToInt(ip, 4);
          result += res;
        }
      }
    }
  }

  std::cout << result << std::endl;
  std::cout << 9259542112527974400ll << std::endl;
}
