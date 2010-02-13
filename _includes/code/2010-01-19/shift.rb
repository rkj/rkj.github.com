def shift(no, s) 
  [no << (s - 1), (no << s) / 2]
end
shift(2, 8) # => [256, 256]
shift(2, 1) # => [2, 2]
shift(2, 0) # => [1, 1]
shift(256, -4) # => [8, 8]
