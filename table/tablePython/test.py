class Char:
    def __init__(self, codepoint):
      self.codepoint = codepoint


REPLACEMENT_CHARACTER = Char(0xFFFD)
validCount = 0
iterationCount = 0


def isValidCodepoint(codepoint):
  return codepoint >= 0 and codepoint <= 0xD7FF or codepoint >= 0xE000 and codepoint <= 0x10FFFF


def toChar(codepoint):
  assert isValidCodepoint(codepoint)
  return Char(codepoint)


def decodeCharReturn3(source, unit0, unit1):
  source.next()
  if not source.valid():
    return (REPLACEMENT_CHARACTER, 0)
  else:
    unit2 = source.get()
    if  ((unit2 & 0xC0) != 0x80):
      return (REPLACEMENT_CHARACTER, 0)
    else:
      source.next()
      return (
        toChar(
          ((unit0) & 0x0F) << 12 |
          ((unit1) & 0x3F) << 6 |
          ((unit2) & 0x3F)
        ), 3
      )


def decodeCharReturn4(source, unit0, unit1):
  source.next()
  if not source.valid():
    return (REPLACEMENT_CHARACTER, 0)
  else:
    unit2 = source.get()
    if (unit2 & 0xC0) != 0x80:
      return (REPLACEMENT_CHARACTER, 0)
    else:
      unit3 = source.get()
      if ((unit3 & 0xC0) != 0x80):
        return (REPLACEMENT_CHARACTER, 0)
      else:
        source.next()
        return (toChar(
          ((unit0) & 0x07) << 18 |
          ((unit1) & 0x3F) << 12 |
          ((unit2) & 0x3F) << 6 |
          ((unit3) & 0x3F)
        ), 4)
      

def decodeChar(source):
  if not source.valid():
    return (REPLACEMENT_CHARACTER, 0)
  else:
    unit0 = source.get()
    if unit0 < 0x80:
      source.next()
      return (toChar(unit0), 1)
    elif unit0 < 0xC2:
      return (REPLACEMENT_CHARACTER, 0)
    elif unit0 < 0xF5:
      source.next()
      if not source.valid():
        return (REPLACEMENT_CHARACTER, 0)
      else:
        unit1 = source.get()
        if unit0 < 0xE0:
          if (unit1 & 0xC0) != 0x80:
            return (REPLACEMENT_CHARACTER, 0)
          else:
            source.next()
            return (toChar(
              ((unit0) & 0x1F) << 6 |
              ((unit1) & 0x3F)
            ), 2)
        elif unit0 == 0xE0:
          if (unit1 & 0xE0) == 0xA0:
            return decodeCharReturn3(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        elif unit0 < 0xED:
          if ((unit1 & 0xC0) == 0x80):
            return decodeCharReturn3(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        elif unit0 == 0xED:
          if ((unit1 & 0xE0) == 0x80):
            return decodeCharReturn3(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        elif unit0 < 0xF0:
          if ((unit1 & 0xC0) == 0x80):
            return decodeCharReturn3(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        elif unit0 == 0xF0:
          if unit1 >= 0x90 and unit1 < 0xC0:
            return decodeCharReturn4(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        elif unit0 < 0xF4:
          if (unit1 & 0xC0) == 0x80:
            return decodeCharReturn4(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
        else:
          if ((unit1 & 0xF0) == 0x80):
            return decodeCharReturn4(source, unit0, unit1)
          else:
            return (REPLACEMENT_CHARACTER, 0)
    else:
        return (REPLACEMENT_CHARACTER, 0)


def mainValidate(data, size):
  global validCount, iterationCount
  class Iter:
    def __init__(self, data, size, key, usedSize):
      self.data = data
      self.size = size
      self.key = key
      self.usedSize = usedSize
    
    def get(self):
      self.usedSize = self.key + 1
      return data[self.key]
    
    def next(self):
      self.key += 1

    def valid(self):
      return self.key != self.size

  iter = Iter(data, size, 0, 0)
  valueSize = decodeChar(iter)
  if iter.usedSize == size and valueSize[1] > 0:
    validCount += 1
  
  iterationCount += 1


def main():
  global validCount, iterationCount
  validCount, iterationCount = 0, 0

  data = [0] * 4
  for i in range(256):
    data[0] = i
    mainValidate(data, 1)

  for i in range(256):
    data[0] = i
    for j in range(256):
      data[1] = j
      mainValidate(data, 2)
  
  for i in range(256):
    data[0] = i
    for j in range(256):
      data[1] = j
      for k in range(256):
        data[2] = k
        mainValidate(data, 3)

  for i in range(256):
    data[0] = i
    for j in range(256):
      data[1] = j
      for k in range(256):
        data[2] = k
        for t in range(256):
          data[3] = t
          mainValidate(data, 4)

  print(validCount)
  print(1112064)
  print(iterationCount)
  print(256 + 256 * 256 + 256 * 256 * 256 + 256 * 256 * 256 * 256)


if __name__ == "__main__":
  main()