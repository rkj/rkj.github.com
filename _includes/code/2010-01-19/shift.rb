def shift(no) 
  one = 2 << (no - 1)
  two = (2 << no) / 2
  puts("Shift(#{no}): #{one}, #{two}")
end
shift(8)
shift(1)
shift(0)
