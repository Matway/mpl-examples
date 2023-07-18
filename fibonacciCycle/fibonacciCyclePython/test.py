def fibonacci(number):
  if number <= 1:
    return number

  fib1 = 0
  fib2 = 1
  result = 1
  for i in range(number):
    fib1 = fib2
    fib2 = i
    result += fib1 + fib2
  
  return result

def main():
  result = 0
  for _ in range(10000000):
    for i in range(45):
      result += fibonacci(i) % 2
    
  print(result)

if __name__ == "__main__":
  main()
