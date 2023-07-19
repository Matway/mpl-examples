class RandomLCG:
  def __init__(self):
    self.seed = 0

  def nextSeed(self):
    self.seed = (self.seed * 0x8088405 + 1) % (1 << 32)
    return self.seed

def bubbleSort(data):
  for i in range(len(data)):
    for j in range(i, len(data)):
      if data[i] > data[j]:
        data[i], data[j] = data[j], data[i]

def main():
  size = 100000

  rand = RandomLCG()

  data = [rand.nextSeed() for _ in range(size)]

  bubbleSort(data)

  print(data[0], data[size // 2], data[size - 1])

if __name__ == "__main__":
  main()