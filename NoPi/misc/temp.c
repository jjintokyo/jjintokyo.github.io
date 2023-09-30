/////////////////////////////////////////////////////////////////////////
// Compile with: gcc temp.c -o temp                                    //
// Then copy to directory in your path: sudo mv ./temp /usr/local/bin/ //
// Run from anywhere: temp                                             //
// >> CPU Temp: 42.35°C                                                //
/////////////////////////////////////////////////////////////////////////

#include <stdio.h>

int main(int argc, char *argv[]) 
{
   FILE *fp;

   int temp = 0;
   fp = fopen("/sys/class/thermal/thermal_zone0/temp", "r");
   fscanf(fp, "%d", &temp);
   printf(">> CPU Temp: %.2f°C\n", temp / 1000.0);
   fclose(fp);

   return 0;
}