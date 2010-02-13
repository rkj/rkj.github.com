def shift(no) :
  return (2 << (no - 1), (2 << no) / 2)
print shift(8) # (256, 256)
print shift(1) # (2, 2)
print shift(0) # ValueError: negative shift count
