def shift(no) :
  one = 2 << (no - 1)
  two = (2 << no) / 2
  print("Shift(%d): #{%d}, #{%d}" % (no, one, two))

shift(8)
shift(1)
shift(0)
