#include <stdio.h>
void shift(int no) {
  int one = 2 << (no - 1);
  int two = (2 << no) / 2;
  printf("Shift(%d): %d, %d\n", no, one, two);
}
int main() {
  shift(8);
  shift(1);
  shift(0);
  return 0;
}