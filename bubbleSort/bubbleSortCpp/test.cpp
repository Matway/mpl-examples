#include <iostream>
#include <vector>

#include <common.hpp>

template<class T> void bubbleSort(T &data) {
  using Size = decltype(data.size());
  for (Size i{}; i < data.size(); ++i) {
    for (auto j{i}; j < data.size(); ++j) {
      if (data[i] > data[j]) {
        auto tmp{data[i]};
        data[i] = data[j];
        data[j] = tmp;
      }
    }
  }
}

int main() {
  constexpr auto size{int(1e5)};
  std::vector<unsigned> data(size);

  RandomLcg rand{};
  for (int i{}; i < size; ++i)
    data[i] = rand.next();

  auto startPoint{test.ticks()};
  bubbleSort(data);
  auto time{test.since(startPoint)};

  std::cout << data.front() << " " << data[size / 2] << " " << data.back() << std::endl;
  test.store("bubbleSort", time);
}
