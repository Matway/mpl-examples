def fibonacci(n):
  if n < 2:
    return n

  result = 1

  acc = 0
  for i in range(n - 1):
    tmp = result
    result += acc
    acc = tmp

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
