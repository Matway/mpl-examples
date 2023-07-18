class RandomLCG:
  def __init__(self):
    self.seed = 0

  def nextSeed(self):
    self.seed = (self.seed * 0x8088405 + 1) % (1 << 32)
    return self.seed
  

def mergeSortedIntervals(arr, left, middle, right):
  temp = []
  i = left
  j = middle + 1

  while i <= middle and j <= right:
    if arr[i] <= arr[j]:
      temp.append(arr[i])
      i += 1
    else:
      temp.append(arr[j])
      j += 1
    
  while i <= middle:
    temp.append(arr[i])
    i += 1
  
  while j <= right:
    temp.append(arr[j])
    j += 1
  
  for i in range(left, right + 1):
    arr[i] = temp[i - left]


def mergeSort(arr, left, right):
  if left < right:
    middle = (left + right) // 2
    mergeSort(arr, left, middle)
    mergeSort(arr, middle + 1, right)
    mergeSortedIntervals(arr, left, middle, right)


def main():
  size = 50000000
  rand = RandomLCG()
  data = [rand.nextSeed() for _ in range(size)]
  
  mergeSort(data, 0, size - 1)

  print(data[0], data[size // 2], data[size - 1])
  

if __name__ == "__main__":
  main()

