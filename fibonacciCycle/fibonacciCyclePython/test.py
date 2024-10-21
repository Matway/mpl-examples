def fibonacci(n):
  result = 0;
  last = 1;
  for _ in range(n): (result, last) = (last + result, result)
  return result

def main():
  checksum = 0

  for _ in range(10_000_000):
    i32FibMax = 46
    for i in range(i32FibMax + 1):
      checksum += fibonacci(i) % 2

  print(checksum)

if __name__ == "__main__":
  main()
