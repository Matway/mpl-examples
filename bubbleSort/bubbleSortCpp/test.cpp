#include <iostream>
#include <vector>

struct RandomLCG {
  uint32_t seed = 0;
  uint32_t nextSeed() {
    seed = seed * 0x8088405 + 1;
    return seed;
  }
};

void bubbleSort(std::vector<uint32_t>& data) {
  for (size_t i = 0; i < data.size(); i++) {
    for (size_t j = i; j < data.size(); j++)
    {
      if (data[i] > data[j]) {
        uint32_t tmp = data[i];
        data[i] = data[j];
        data[j] = tmp;
      }
    }
  }
}

int main() {
  const int size = 100000;
  std::vector<uint32_t> data(size);

  RandomLCG rand = RandomLCG();

  for (int i = 0; i < size; ++i) {
    data[i] = rand.nextSeed();
  }

  bubbleSort(data);

  std::cout << data[0] << " " << data[size / 2] << " " << data[size - 1] << " " << std::endl;
}
