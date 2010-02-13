#include <stdio.h>
void shift(int no, int s) {
  int one = no << (s - 1);
  int two = (no << s) / 2;
  printf("Shift(%d, %d): %d, %d\n", no, s, one, two);
}
int main() {
  shift(2, 8); // 256, 256
  shift(2, 1); // 2, 2
  shift(2, 0); // 0, 1
  shift(256, -4); // 0, 0
  return 0;
}