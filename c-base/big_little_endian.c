
int x = 1;
if (*(char*) &x == 1)
    printf("小端");
else
    pirntf("大端");

uint32_t swap_endian(uint32_t val) {
      val = ((val << 8) & 0xFF00FF00) | ((val >> 8) & 0xFF00FF);
      return (val << 16) | (val >> 16);
 }