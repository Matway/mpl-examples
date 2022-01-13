#include <iostream>
#include <vector>

struct RandomLCG {
  uint32_t seed = 0;
  uint32_t nextSeed() {
    seed = seed * 0x8088405 + 1;
    return seed;
  }
};

void mergeSortedIntervals(std::vector<uint32_t>& arr, size_t left, size_t middle, size_t right) {
  std::vector<uint32_t> temp;
  temp.reserve(right - left + 1);

  size_t i = left;
  size_t j = middle + 1;

  while (i <= middle && j <= right) {
    if (arr[i] <= arr[j]) {
      temp.push_back(arr[i]);
      ++i;
    } else {
      temp.push_back(arr[j]);
      ++j;
    }
  }

  while (i <= middle) {
    temp.push_back(arr[i]);
    ++i;
  }

  while (j <= right) {
    temp.push_back(arr[j]);
    ++j;
  }

  for (size_t i = left; i <= right; ++i) {
    arr[i] = temp[i - left];
  }
}

void mergeSort(std::vector<uint32_t>& arr, size_t left, size_t right) {
  if (left < right) {
    size_t middle = (left + right) / 2;
    mergeSort(arr, left, middle);
    mergeSort(arr, middle + 1, right);
    mergeSortedIntervals(arr, left, middle, right);
  }
}

int main() {
  const int size = 50000000;
  std::vector<uint32_t> data(size);

  RandomLCG rand = RandomLCG();

  for (int i = 0; i < size; ++i) {
    data[i] = rand.nextSeed();
  }

  mergeSort(data, 0, size - 1);

  std::cout << data[0] << " " << data[size / 2] << " " << data[size - 1] << " " << std::endl;
}
