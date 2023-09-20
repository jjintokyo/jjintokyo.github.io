/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// OpenWrt - 4digits - jjr                                                                                             //
//---------------------------------------------------------------------------------------------------------------------//
//                                                                                                                     //
// Compile for Ubuntu:       gcc 4digits.c -o 4digits-ubuntu                                                           //
// Compile for Raspberry Pi: gcc 4digits.c -o 4digits-pi                                                               //
// Compile for OpenWrt:      mipsel-openwrt-linux-gcc 4digits.c -o 4digits-openwrt                                     //
// Compile for Windows 10:   gcc 4digits.c -o 4digits-cygwin (with Cygwin64 Terminal) + cygwin1.dll for runtime        //
// Compile for Windows 10:   x86_64-w64-mingw32-gcc 4digits.c -o 4digits-mingw64 (with Cygwin64 Terminal) but NO color //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_BACKGROUND_COLOR "\x1b[49m"
#define DEFAULT_FOREGROUND_COLOR "\x1b[39m"
#define RESET_ALL                "\x1b[0m"
#define BRIGHT                   "\x1b[1m"
#define COLOR_RED                "\x1b[31m"
#define COLOR_GREEN              "\x1b[32m"
#define COLOR_YELLOW             "\x1b[33m"
#define COLOR_BLUE               "\x1b[34m"
#define COLOR_MAGENTA            "\x1b[35m"
#define COLOR_CYAN               "\x1b[36m"
#define NUMBER_OF_DIGITS         4
#define NUMBER_OF_TRIES          8

int new_color = 9, previous_color = 9, bright_or_not, guess_counter, magic_code_index, guess_code_index, random_digit, range, i, j, A, B, left_to_try;
char string_color[32], input[32], digit[2], magic_code[5], guess_code[9][5], not_unique, already_guess, win;
char colors[6][9] = { COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE, COLOR_MAGENTA, COLOR_CYAN };
char bright[2][9] = { RESET_ALL, BRIGHT };
time_t start_time, stop_time;
unsigned long seconds;

void pgm_init(void)
{
    srand(time(NULL));
    guess_counter = 1;
    magic_code_index = 0;
    while (0 == 0)
    {
        if (magic_code_index == NUMBER_OF_DIGITS) { magic_code[NUMBER_OF_DIGITS] = '\0'; break; }
        random_digit = rand() % 10;
        if (magic_code_index == 0 && random_digit == 0) continue;
        sprintf(digit, "%d", random_digit);
        not_unique = 0;
        for (i = 0; i < NUMBER_OF_DIGITS; i++) { if (magic_code[i] == digit[0]) { not_unique = 1; break; } }
        if (not_unique) continue;
        magic_code[magic_code_index] = digit[0];
        magic_code_index++;
    }
}

int main(void)
{
    pgm_init();
    start_time = time(NULL);
    while (0 == 0)
    {
        string_color[0] = '\0';
        strcpy(string_color, DEFAULT_FOREGROUND_COLOR);
        strcat(string_color, DEFAULT_BACKGROUND_COLOR);
        printf("\n%sInput a 4-digit number:%s ", string_color, RESET_ALL);
        fflush(stdout);
        // scanf("%s", input);
        if (!fgets(input, sizeof(input), stdin)) continue;
        input[strlen(input) - 1] = '\0';
        if (strlen(input) > NUMBER_OF_DIGITS) { printf("%sInput too long!%s", string_color, RESET_ALL); continue; }
        range = atoi(input);
        if (range < 1000 || range > 9999) { printf("%sMust be a number between 1000 and 9999!%s", string_color, RESET_ALL); continue; }
        not_unique = 0;
        for (i = 0; i < NUMBER_OF_DIGITS; i++) { for (j = 0; j < NUMBER_OF_DIGITS; j++) { if (i != j && input[i] == input[j]) { not_unique = 1; break; } } }
        if (not_unique) { printf("%sFour digits must be unique.%s", string_color, RESET_ALL); continue; }
        already_guess = 0;
        for (i = 1; i < guess_counter; i++) { if (strcmp(guess_code[i], input) == 0) { already_guess = 1; break; } }
        if (already_guess) { printf("%sYou've already guessed it.%s", string_color, RESET_ALL); continue; }
        strncpy(guess_code[guess_counter], input, NUMBER_OF_DIGITS);
        guess_code[guess_counter][NUMBER_OF_DIGITS] = '\0';
        A = 0;
        B = 0;
        for (guess_code_index = 0; guess_code_index < NUMBER_OF_DIGITS; guess_code_index++)
        {
            for (magic_code_index = 0; magic_code_index < NUMBER_OF_DIGITS; magic_code_index++)
            {
                if (guess_code[guess_counter][guess_code_index] == magic_code[magic_code_index])
                {
                    if (guess_code_index == magic_code_index) A++; else B++;
                }
            }
        }
        if (strcmp(guess_code[guess_counter], magic_code) == 0) win = 1; else win = 0;
        left_to_try = NUMBER_OF_TRIES - guess_counter;
        while (new_color == previous_color) new_color = rand() % 6; previous_color = new_color;
        bright_or_not = rand() % 2;
        string_color[0] = '\0';
        if (win || left_to_try == 0) strcpy(string_color, BRIGHT); else strcpy(string_color, bright[bright_or_not]);
        strcat(string_color, colors[new_color]);
        strcat(string_color, DEFAULT_BACKGROUND_COLOR);
        stop_time = time(NULL);
        seconds = (unsigned long) difftime(stop_time, start_time);
        if      (left_to_try == 0)   printf("%s%dA%dB%s",                            string_color, A, B,              RESET_ALL);
        else if (left_to_try == 1)   printf("%s%dA%dB             %d time left.%s",  string_color, A, B, left_to_try, RESET_ALL);
        else if (left_to_try >= 2)   printf("%s%dA%dB             %d times left.%s", string_color, A, B, left_to_try, RESET_ALL);
        if (win)                   { printf("\n%sYou win! :) Used %ld sec.%s\n",     string_color, seconds,           RESET_ALL); break; }
        else if (left_to_try == 0) { printf("\n%sHaha, you lose. It is %s.%s\n",     string_color, magic_code,        RESET_ALL); break; }
        guess_counter++;
    }
    return 0;
}
