
public void shift(int no) {
  int one = 2 << (no - 1);
  int two = (2 << no) / 2;
  System.out.println("Shift(" + no +"): " + one + ", " + two);
}
shift(8);
shift(1);
shift(0);
