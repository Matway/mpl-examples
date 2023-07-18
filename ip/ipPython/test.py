def convertToInt(ip, size):
  result = 0
  for i in range(size):
    if i == 0:
      result += ip[i] * 256 * 256 * 256
    elif i == 1:
      result += ip[i] * 256 * 256
    elif i == 2:
      result += ip[i] * 256
    elif i == 3:
      result += ip[i]
  
  return result

def main():
  result = 0
  ip = [0] * 4
  for i in range(256):
    ip[0] = i
    res = convertToInt(ip, 1)
    result += res
  
  for i in range(256):
    ip[0] = i
    for j in range(256):
      ip[1] = j
      res = convertToInt(ip, 2)
      result += res

  for i in range(256):
    ip[0] = i
    for j in range(256):
      ip[1] = j
      for k in range(256):
        ip[2] = k
        res = convertToInt(ip, 3)
        result += res

  for i in range(256):
    ip[0] = i
    for j in range(256):
      ip[1] = j
      for k in range(256):
        ip[2] = k
        for t in range(256):
          ip[3] = t
          res = convertToInt(ip, 4)
          result += res

  print(result)
  print(9259542112527974400)

if __name__ == "__main__":
  main()
