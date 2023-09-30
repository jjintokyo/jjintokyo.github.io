//////////////////////////////////////////////////////////////////////
// OpenWrt - Testing C Program                                      //
// Compile for Ubuntu: gcc test_c.c -o test_c                       //
// Compile for OpenWrt: mipsel-openwrt-linux-gcc test_c.c -o test_c //
//////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int stop = 4096, loop = 0, random_number = 0, random_letter = 0, random_color = 0, previous_random_number = 0, previous_random_letter = 0, previous_random_color = 0;
const char *COLORS[] = { "\x1B[30m", "\x1B[31m", "\x1B[32m", "\x1B[33m", "\x1B[34m", "\x1B[35m", "\x1B[36m", "\x1B[37m", "\x1B[0m\x1B[5m", "\x1B[0m", NULL };
const char *LETTERS[] = { "A", "B", "C", "D", "E", "F", NULL };

int main(int argc, char *argv[]) {
   if (argc > 1) { stop = atoi(argv[1]); };
   srand(time(NULL));
   for (;;) {
      while (random_color == previous_random_color) { random_color = rand() % 8; };
      previous_random_color = random_color;
      if (rand() % 2 == 0) {
         while (random_number == previous_random_number) { random_number = rand() % 10; };
         previous_random_number = random_number;
         printf ("%s%d", COLORS[random_color], random_number);
      }
      else {
         while (random_letter == previous_random_letter) { random_letter = rand() % 6; };
         previous_random_letter = random_letter;
         printf ("%s%s", COLORS[random_color], LETTERS[random_letter]);
      }
      loop++; if (loop == stop) { printf ("\n\n%s%d%s\n\n", COLORS[8], stop, COLORS[9]); break; };
   }
   return 0;
}
