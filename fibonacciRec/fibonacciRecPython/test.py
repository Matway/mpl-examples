def fibonacciRec(number):
  if number <= 1:
    return number
  else:
    return fibonacciRec(number - 1) + fibonacciRec(number - 2)

def main():
  result = 0
  for i in range(45):
    result += fibonacciRec(i)
  print(result)

if __name__ == "__main__":
  main()