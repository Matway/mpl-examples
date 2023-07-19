def fibonacci(n):
  if n < 2:
    return n
  else:
    return fibonacci(n - 1) + fibonacci(n - 2)

def main():
  checksum = 0

  i32FibMax = 46
  for i in range(i32FibMax + 1):
    checksum ^= fibonacci(i)

  print(checksum)

if __name__ == "__main__":
  main()