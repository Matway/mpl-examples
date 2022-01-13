#include <cassert>
#include <cstdint>
#include <iostream>
#include <tuple>

struct Char {
  int codepoint;
};

const static Char REPLACEMENT_CHARACTER = {0xFFFD};

bool isValidCodepoint(int codepoint) {
  return codepoint >= 0 && codepoint <= 0xD7FF || codepoint >= 0xE000 && codepoint <= 0x10FFFF;
}

Char toChar(int codepoint) {
  assert(isValidCodepoint(codepoint));
  return {codepoint};
}

template<class Iter> std::tuple<Char, int> decodeCharReturn3(Iter& source, uint8_t unit0, uint8_t unit1) {
  source.next();
  if (!source.valid()) {
    return {REPLACEMENT_CHARACTER, 0};
  } else {
    uint8_t unit2 = source.get();
    if ((unit2 & 0xC0) != 0x80) {
      return {REPLACEMENT_CHARACTER, 0};
    } else {
      source.next();
      return {toChar(
        (uint32_t(unit0) & 0x0F) << 12 |
        (uint32_t(unit1) & 0x3F) << 6 |
        (uint32_t(unit2) & 0x3F)
      ), 3};
    }
  }
}

template<class Iter> std::tuple<Char, int> decodeCharReturn4(Iter& source, uint8_t unit0, uint8_t unit1) {
  source.next();
  if (!source.valid()) {
    return {REPLACEMENT_CHARACTER, 0};
  } else {
    uint8_t unit2 = source.get();
    if ((unit2 & 0xC0) != 0x80) {
      return {REPLACEMENT_CHARACTER, 0};
    } else {
      source.next();
      if (!source.valid()) {
        return {REPLACEMENT_CHARACTER, 0};
      } else {
        uint8_t unit3 = source.get();
        if ((unit3 & 0xC0) != 0x80) {
          return {REPLACEMENT_CHARACTER, 0};
        } else {
          source.next();
          return {toChar(
            (uint32_t(unit0) & 0x07) << 18 |
            (uint32_t(unit1) & 0x3F) << 12 |
            (uint32_t(unit2) & 0x3F) << 6 |
            (uint32_t(unit3) & 0x3F)
          ), 4};
        }
      }
    }
  }
}

template<class Iter> std::tuple<Char, int> decodeChar(Iter& source) {
  if (!source.valid()) {
    return {REPLACEMENT_CHARACTER, 0};
  } else {
    uint8_t unit0 = source.get();
    if (unit0 < 0x80) {
      source.next();
      return {toChar(unit0), 1};
    } else if (unit0 < 0xC2) {
      return {REPLACEMENT_CHARACTER, 0};
    } else if (unit0 < 0xF5) {
      source.next();
      if (!source.valid()) {
        return {REPLACEMENT_CHARACTER, 0};
      } else {
        uint8_t unit1 = source.get();
        if (unit0 < 0xE0) {
          if ((unit1 & 0xC0) != 0x80) {
            return {REPLACEMENT_CHARACTER, 0};
          } else {
            source.next();
            return {toChar(
              (uint32_t(unit0) & 0x1F) << 6 |
              (uint32_t(unit1) & 0x3F)
            ), 2};
          }
        } else if (unit0 == 0xE0) {
          if ((unit1 & 0xE0) == 0xA0) {
            return decodeCharReturn3(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else if (unit0 < 0xED) {
          if ((unit1 & 0xC0) == 0x80) {
            return decodeCharReturn3(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else if (unit0 == 0xED) {
          if ((unit1 & 0xE0) == 0x80) {
            return decodeCharReturn3(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else if (unit0 < 0xF0) {
          if ((unit1 & 0xC0) == 0x80) {
            return decodeCharReturn3(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else if (unit0 == 0xF0) {
          if (unit1 >= 0x90 && unit1 < 0xC0) {
            return decodeCharReturn4(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else if (unit0 < 0xF4) {
          if ((unit1 & 0xC0) == 0x80) {
            return decodeCharReturn4(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        } else {
          if ((unit1 & 0xF0) == 0x80) {
            return decodeCharReturn4(source, unit0, unit1);
          } else {
            return {REPLACEMENT_CHARACTER, 0};
          }
        }
      }
    } else {
      return {REPLACEMENT_CHARACTER, 0};
    }
  }
}

void mainValidate(uint8_t* data, int size, int& validCount, int64_t& iterationCount) {
  struct Iter {
    uint8_t* data;
    int size;
    int key;
    int& usedSize;

    uint8_t& get() const {
      usedSize = key + 1;
      return data[key];
    }

    void next() {
      ++key;
    }

    bool valid() const {
      return key != size;
    }
  };

  int usedSize = 0;
  Iter iter = {data, size, 0, usedSize};
  auto valueSize = decodeChar(iter);
  if (usedSize == size && std::get<1>(valueSize) > 0) {
    ++validCount;
  }

  ++iterationCount;
}

int main() {
  int validCount = 0;
  int64_t iterationCount = 0;
  uint8_t data[4];

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    mainValidate(data, 1, validCount, iterationCount);
  }

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      data[1] = i;
      mainValidate(data, 2, validCount, iterationCount);
    }
  }

  for (int i = 0; i < 256; ++i) {
    data[0] = i;
    for (int i = 0; i < 256; ++i) {
      data[1] = i;
      for (int i = 0; i < 256; ++i) {
        data[2] = i;
        mainValidate(data, 3, validCount, iterationCount);
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
          mainValidate(data, 4, validCount, iterationCount);
        }
      }
    }
  }

  std::cout << validCount << std::endl;
  std::cout << 1112064 << std::endl;
  std::cout << iterationCount << std::endl;
  std::cout << int64_t(256) + int64_t(256) * int64_t(256) + int64_t(256) * int64_t(256) * int64_t(256) + int64_t(256) * int64_t(256) * int64_t(256) * int64_t(256) << std::endl;
}
