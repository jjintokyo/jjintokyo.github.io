/*
*****************************************************************
*                                                               *
*   CASIO fx-CG10/20/50 SDK Library                             *
*                                                               *
*   File name : CodeBreaker.c                                   *
*                                                               *
*   Tue 3 May 2022 / JJR                                        *
*                                                               *
*****************************************************************
*/

#include <fxcg/keyboard.h>
#include <fxcg/display.h>
#include <fxcg/system.h>
#include <fxcg/misc.h>
#include <fxcg/file.h>
#include <fxcg/rtc.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define KEY_MENU     48
#define KEY_EXIT     47
#define KEY_F1       79
#define KEY_F2       69
#define KEY_F3       59
#define KEY_F4       49
#define KEY_F5       39
#define KEY_F6       29
#define KEY_0        71
#define KEY_1        72
#define KEY_2        62
#define KEY_3        52
#define KEY_4        73
#define KEY_5        63
#define KEY_6        53
#define KEY_7        74
#define KEY_8        64
#define KEY_9        54
#define KEY_PLUS     42
#define KEY_MINUS    32
#define KEY_RETURN   31
#define KEY_ACON     10
#define KEY_STORE    25
#define KEY_DP       61
#define KEY_RPAR     45
#define KEY_LPAR     55
#define KEY_SQUARE   67
#define KEY_SHIFT    78
#define KEY_ALPHA    77
#define KEY_DEL      44
#define KEY_POW      57
#define KEY_PMINUS   41
#define KEY_EXP      51
#define KEY_VARS     58
#define KEY_OPTN     68
#define KEY_UP       28
#define KEY_DOWN     37
#define KEY_LEFT     38
#define KEY_RIGHT    27
#define SAVEFILE "\\\\fls0\\CodeBreaker.sav"
#define YES      "YES    "
#define NO       "NO     "
#define INPUT    "INPUT  "
#define SCREEN_WIDTH              383
#define SCREEN_HEIGHT             215
#define BORDER_SIZE                 4
#define NUMBER_OF_COLORS           10
#define INTRO_TOP_MARGIN            7
#define INTRO_FRAME_SIZE           25
#define INTRO_SCROLL_TEXT_LENGTH   34
#define INTRO_SCROLL_TEXT_WAIT    400
#define INTRO_SCROLL_TEXT_SPEED     7
#define INTRO_BUG_X_MIN             1
#define INTRO_BUG_Y_MIN             8
#define INTRO_BUG_X_MAX           364
#define INTRO_BUG_Y_MAX           191
#define INTRO_BUG_SPEED             5

unsigned int main_timer = 0;
unsigned int number_of_digits = 5;
unsigned int allow_duplicate_digits = 0;
unsigned int allow_incomplete_code = 0;
unsigned int guess_count = 0;
unsigned int digit_count = 0;
unsigned int item_position_x = 0;
unsigned int item_position_y = 0;
unsigned int digit_position_x = 0;
unsigned int digit_position_y = 0;
unsigned int smiley = 0;
unsigned int blink = 0;
unsigned int gizmo = 0;
unsigned int intro_scrolling_wait = 0;
unsigned int intro_scrolling = 0;
unsigned int intro_scroll_text_buffer_position = 0;
unsigned int foreground_color[NUMBER_OF_COLORS]      = { COLOR_INDIGO,    COLOR_NAVY,      COLOR_MAROON,    COLOR_DARKRED,   COLOR_DARKSLATEGRAY, COLOR_FIREBRICK, COLOR_MIDNIGHTBLUE,   COLOR_KHAKI,       COLOR_WHITE,      COLOR_BLACK      };
unsigned int background_color[NUMBER_OF_COLORS]      = { COLOR_YELLOW,    COLOR_GOLD,      COLOR_BURLYWOOD, COLOR_MISTYROSE, COLOR_ROSYBROWN,     COLOR_ORANGE,    COLOR_CORNFLOWERBLUE, COLOR_FORESTGREEN, COLOR_BLACK,      COLOR_WHITE      };
unsigned int others_color[NUMBER_OF_COLORS]          = { COLOR_RED,       COLOR_CRIMSON,   COLOR_ORANGERED, COLOR_ORANGERED, COLOR_ANTIQUEWHITE,  COLOR_DIMGRAY,   COLOR_AQUA,           COLOR_LIME,        COLOR_WHITE,      COLOR_BLACK      };
unsigned int print_mini_mini_color[NUMBER_OF_COLORS] = { TEXT_COLOR_BLUE, TEXT_COLOR_BLUE, TEXT_COLOR_RED,  TEXT_COLOR_RED,  TEXT_COLOR_GREEN,    TEXT_COLOR_RED,  TEXT_COLOR_BLUE,      TEXT_COLOR_PURPLE, TEXT_COLOR_BLACK, TEXT_COLOR_BLACK };
unsigned int print_mini_mini_mode[NUMBER_OF_COLORS]  = { 0b01000100,      0b01000100,      0b01000001,      0b01000001,      0b01000100,          0b01000001,      0b01000001,           0b01000100,        0b01000001,       0b01000000       };
int color_index = 0;
unsigned char pgm_exit = 0;
unsigned char game_over = 0;
char digit[2];
char magic_code[6];
char guess_code[13][6];
char guess_result[13][6];
char intro_scroll_text_buffer[512];
char intro_scroll_text_display[INTRO_SCROLL_TEXT_LENGTH];
const char copyright[3]              = { 0xE5, 0x9E, 0 };
const char jj[3]                     = { 0x6A, 0x6A, 0 };
const char blank[3]                  = { 0xE6, 0x00, 0 };
const char bug[3]                    = { 0xE6, 0xA6, 0 };
const char smiley1[6]                = { 0x28, 0x5E, 0x5F, 0x5E, 0x29, 0 };
const char smiley2[6]                = { 0x28, 0x27, 0x2E, 0x27, 0x29, 0 };
const char smiley3[6]                = { 0x28, 0x9C, 0x5F, 0x9C, 0x29, 0 };
const char smiley4[8]                = { 0x28, 0xE5, 0xCC, 0x5F, 0xE5, 0xCC, 0x29, 0 };
const char title[13]                 = "CodeBreaker!";
const char version[5]                = "v1.0";
const char challenge[24]             = "Can you break the code?";
const char play_quit[35]             = "Press [EXE] to play [EXIT] to quit";
const char blank_code[]              = "     \0";
const char blank_result[]            = "     \0";
const char intro_scroll_text_blank[] = "                  \0";
const char intro_options[3][22]      = { "[F1] Number of digits",
                                         "[F2] Duplicate digits",
                                         "[F3] Incomplete code" };
const char intro_help_me[9][27]      = { "While playing:",
                                         "[0]~[9] Enter code",
                                         "[LEFT]/[RIGHT] Move cursor",
                                         "[EXE] Check code",
                                         "[(]/[)] Change color",
                                         "[(-)] Show intro",
                                         "[AC] Calc off",
                                         "[MENU]/[EXIT] Quit",
                                         "---" };
const char dialog_box_1[4][22]       = { "__ The code is not ",
                                         "__    complete!    ",
                                         "__                 ",
                                         "__   Press:[EXIT]  " };
const char dialog_box_2[4][22]       = { "__ Duplicate digits",
                                         "__   not allowed!  ",
                                         "__                 ",
                                         "__   Press:[EXIT]  " };
const char dialog_box_3[4][22]       = { "__  Code was       ",
                                         "__  You did it     ",
                                         "__                 ",
                                         "__   Press:[EXIT]  " };
const char dialog_box_4[5][22]       = { "__ Sorry, you lost!",
                                         "__  Code was       ",
                                         "__      Try again? ",
                                         "__                 ",
                                         "__   Press:[EXIT]  " };

int PRGM_GetKey(void)
{
    unsigned char buffer[12];
    PRGM_GetKey_OS(buffer);
    return (buffer[1] & 0x0F) * 10 + ((buffer[2] & 0xF0) >> 4);
}

unsigned int random(int seed, int value)
{
    static unsigned int lastrandom = 0x12345678;
    if (seed) lastrandom = seed;
    lastrandom = (0x41C64E6D * lastrandom) + 0x3039;
    return ((lastrandom >> 16) % value);
}

void save_settings(void)
{
    int file_handle;
    unsigned int file_size = 32;
    unsigned short file_name[sizeof(SAVEFILE) * 2];
    char line[file_size];
    char string[10];
    line[0] = '\0';
    string[0] = '\0';
    Bfile_StrToName_ncpy(file_name, SAVEFILE, sizeof(SAVEFILE));
    file_handle = Bfile_OpenFile_OS(file_name, 2, 0);
    if (file_handle < 0)
    {
        Bfile_CreateEntry_OS(file_name, 1, &file_size);
        file_handle = Bfile_OpenFile_OS(file_name, 2, 0);
        if (file_handle < 0) return;
    }
    itoa(color_index, (unsigned char*)string);
    strcat(line, string);
    itoa(number_of_digits, (unsigned char*)string);
    strcat(line, string);
    itoa(allow_duplicate_digits, (unsigned char*)string);
    strcat(line, string);
    itoa(allow_incomplete_code, (unsigned char*)string);
    strcat(line, string);
    Bfile_SeekFile_OS(file_handle, 0);
    Bfile_WriteFile_OS(file_handle, &line, strlen(line));
    Bfile_CloseFile_OS(file_handle);
}

void restore_settings(void)
{
    int file_handle;
    unsigned short file_name[sizeof(SAVEFILE) * 2];
    unsigned int saved_color_index;
    unsigned int saved_number_of_digits;
    unsigned int saved_allow_duplicate_digits;
    unsigned int saved_allow_incomplete_code;
    char string[10];
    string[0] = '\0';
    Bfile_StrToName_ncpy(file_name, SAVEFILE, sizeof(SAVEFILE));
    file_handle = Bfile_OpenFile_OS(file_name, 0, 0);
    if (file_handle >= 0)
    {
        Bfile_ReadFile_OS(file_handle, &string, 1, 0);
        saved_color_index = atoi(string);
        if (saved_color_index >= 0 &&
            saved_color_index < NUMBER_OF_COLORS) color_index = saved_color_index;
        else                                      color_index = 0;
        Bfile_ReadFile_OS(file_handle, &string, 1, 1);
        saved_number_of_digits = atoi(string);
        if (saved_number_of_digits == 3 ||
            saved_number_of_digits == 4 ||
            saved_number_of_digits == 5)          number_of_digits = saved_number_of_digits;
        else                                      number_of_digits = 5;
        Bfile_ReadFile_OS(file_handle, &string, 1, 2);
        saved_allow_duplicate_digits = atoi(string);
        if (saved_allow_duplicate_digits == 0 ||
            saved_allow_duplicate_digits == 1 ||
            saved_allow_duplicate_digits == 2)    allow_duplicate_digits = saved_allow_duplicate_digits;
        else                                      allow_duplicate_digits = 0;
        Bfile_ReadFile_OS(file_handle, &string, 1, 3);
        saved_allow_incomplete_code = atoi(string);
        if (saved_allow_incomplete_code == 0 ||
            saved_allow_incomplete_code == 1)     allow_incomplete_code = saved_allow_incomplete_code;
        else                                      allow_incomplete_code = 0;
        Bfile_CloseFile_OS(file_handle);
    }
}

void display_init(void)
{
    unsigned int grid_line;
    unsigned int grid_col;
    unsigned int grid_col_pos[6] = { 0, 27, 125, SCREEN_WIDTH / 2, 214, 311 };
    unsigned int point_x;
    unsigned int point_y;
    Bdisp_AllClr_VRAM();
    EnableStatusArea(3);
    Bdisp_EnableColor(1);
    Bdisp_Fill_VRAM(background_color[color_index], 3);
    DrawFrame(background_color[color_index]);
    struct display_fill area1 = { 0, 5, 228, 40, 1 };
    Bdisp_AreaClr(&area1, 1, foreground_color[color_index]);
    struct display_fill area2 = { 0, 40 - BORDER_SIZE, SCREEN_WIDTH, 40, 1 };
    Bdisp_AreaClr(&area2, 1, foreground_color[color_index]);
    struct display_fill area3 = { 0, 40, BORDER_SIZE, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area3, 1, foreground_color[color_index]);
    struct display_fill area4 = { SCREEN_WIDTH - BORDER_SIZE, 40, SCREEN_WIDTH, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area4, 1, foreground_color[color_index]);
    struct display_fill area5 = { 0, SCREEN_HEIGHT - BORDER_SIZE, SCREEN_WIDTH, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area5, 1, foreground_color[color_index]);
    PrintCXY(9, 11, title, 0x40, -1, background_color[color_index], foreground_color[color_index], 1, 0);
    PrintCXY(236, 3, copyright, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0);
    PrintCXY(253, 11, jj, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0);
    for (grid_line = 1; grid_line <= 5; grid_line++)
    {
        point_y = grid_line * 28 + 42;
        for (point_x = 0; point_x <= SCREEN_WIDTH; point_x++) Bdisp_SetPoint_VRAM(point_x, point_y, foreground_color[color_index]);
    }
    for (grid_col = 1; grid_col <= 5; grid_col++)
    {
        point_x = grid_col_pos[grid_col];
        for (point_y = 40; point_y <= SCREEN_HEIGHT; point_y++) Bdisp_SetPoint_VRAM(point_x, point_y, foreground_color[color_index]);
    }
    Bdisp_PutDisp_DD();
}

void build_empty_line(void)
{
    char string[10];
    char line[10];
    int print_x;
    int print_y;
    unsigned int i;
    string[0] = '\0';
    line[0] = '\0';
    if (guess_count <= 6) { item_position_x = 8;   item_position_y = guess_count * 28 + 18;       }
    else                  { item_position_x = 195; item_position_y = (guess_count - 6) * 28 + 18; }
    itoa(guess_count, (unsigned char*)string);
    if (guess_count <= 9) strcat(line, "0");
    strcat(line, string);
    print_x = item_position_x;
    print_y = item_position_y + 5;
    PrintMiniMini(&print_x, &print_y, line, print_mini_mini_mode[color_index], print_mini_mini_color[color_index], 0);
    digit_position_x = item_position_x + 23;
    digit_position_y = item_position_y;
    digit_count = 1;
    strcpy(guess_code[guess_count], blank_code);
    for (i = 0; i < number_of_digits; i++) guess_code[guess_count][i] = '_';
    guess_code[guess_count][number_of_digits] = '\0';
    PrintCXY(digit_position_x, digit_position_y, guess_code[guess_count], 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
    print_x = item_position_x + 120;
    print_y = item_position_y + 2;
    PrintMini(&print_x, &print_y, blank_result, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
}

void generate_magic_code(void)
{
    unsigned int magic_code_index;
    unsigned int valid_digits_index;
    char valid_digits[11] = "0123456789\0";
    magic_code_index = 0;
    strcpy(magic_code, blank_code);
    if (allow_duplicate_digits == 0 || allow_duplicate_digits == 2)
    {
        while (0 == 0)
        {
            if (magic_code_index == number_of_digits) { magic_code[number_of_digits] = '\0'; break; }
            itoa(random(0, 10), (unsigned char*)digit);
            for (valid_digits_index = 0; valid_digits_index <= 9; valid_digits_index++)
            {
                if (digit[0] == valid_digits[valid_digits_index])
                {
                    valid_digits[valid_digits_index] = ' ';
                    magic_code[magic_code_index] = digit[0];
                    magic_code_index++;
                    break;
                }
            }
        }
    }
    else
    {
        for (magic_code_index = 0; magic_code_index < number_of_digits; magic_code_index++)
        {
            itoa(random(0, 10), (unsigned char*)digit);
            magic_code[magic_code_index] = digit[0];
        }
        magic_code[number_of_digits] = '\0';
    }
}

void intro_scroll_text_on_display(void)
{
    unsigned int i;
    int print_mini_x = INTRO_FRAME_SIZE + 3;
    int print_mini_y = SCREEN_HEIGHT - (INTRO_FRAME_SIZE * 3) + 5;
    if (intro_scroll_text_buffer_position == INTRO_SCROLL_TEXT_LENGTH - 1)
    {
        intro_scrolling_wait++;
        if (intro_scrolling_wait > INTRO_SCROLL_TEXT_WAIT) intro_scroll_text_buffer_position++;
    }
    else
    {
        intro_scrolling++;
        if (intro_scrolling > INTRO_SCROLL_TEXT_SPEED)
        {
            intro_scrolling = 0;
            if (intro_scrolling_wait != 0) { intro_scrolling_wait = 0; intro_scroll_text_buffer_position--; }
            for (i = 0; i < INTRO_SCROLL_TEXT_LENGTH - 2; i++) intro_scroll_text_display[i] = intro_scroll_text_display[i + 1];
            if (intro_scroll_text_buffer[intro_scroll_text_buffer_position] == '\0') intro_scroll_text_buffer_position = 0;
            intro_scroll_text_display[INTRO_SCROLL_TEXT_LENGTH - 2] = intro_scroll_text_buffer[intro_scroll_text_buffer_position];
            intro_scroll_text_buffer_position++;
            PrintCXY(print_mini_x, print_mini_y - 4, intro_scroll_text_blank, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0);
            PrintMini(&print_mini_x, &print_mini_y, intro_scroll_text_display, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
            Bdisp_PutDisp_DD();
        }
    }
}

unsigned char sleepy_bug(unsigned char blocked)
{
    unsigned int min;
    unsigned int max     = random(0, 1024);
    unsigned int no_wait = random(0, 10);
    int key;
    if (!no_wait)
    {
        for (min = 0; min <= max; min++)
        {
            intro_scroll_text_on_display();
            key = PRGM_GetKey();
            if      (key == KEY_F1 && !blocked)          return 1;
            else if (key == KEY_F2 && !blocked)          return 2;
            else if (key == KEY_F3 && !blocked)          return 3;
            else if (key == KEY_RETURN)                  return 4;
            else if (key == KEY_MENU || key == KEY_EXIT) return 5;
            OS_InnerWait_ms(10);
        }
    }
    return 0;
}

void show_intro_screen(unsigned char blocked)
{
    unsigned int frame;
    unsigned int point_x;
    unsigned int point_y;
    unsigned int i;
    int print_mini_x;
    int print_mini_y;
    int key = 0;
    int bug_x = INTRO_BUG_X_MIN;
    int bug_y = INTRO_BUG_Y_MIN;
    unsigned char status = 0;
    unsigned char bug_right = 0;
    unsigned char bug_left = 0;
    unsigned char bug_down = 0;
    unsigned char bug_up = 0;
    unsigned char bug_clockwise = 0;
    unsigned char bug_corner_wait = 0;
    char string[10];
    string[0] = '\0';
    if (blocked) SaveVRAM_1();
    Bdisp_AllClr_VRAM();
    EnableStatusArea(3);
    Bdisp_EnableColor(1);
    Bdisp_Fill_VRAM(background_color[color_index], 3);
    DrawFrame(background_color[color_index]);
    for (frame = 0; frame <= INTRO_FRAME_SIZE; frame += INTRO_FRAME_SIZE)
    {
        for (point_x = 0 + frame; point_x <= SCREEN_WIDTH - frame; point_x++)
        {
            Bdisp_SetPoint_VRAM(point_x, INTRO_TOP_MARGIN + frame, foreground_color[color_index]);
            Bdisp_SetPoint_VRAM(point_x, SCREEN_HEIGHT - frame, foreground_color[color_index]);
        }
        for (point_y = INTRO_TOP_MARGIN + frame; point_y <= SCREEN_HEIGHT - frame; point_y++)
        {
            Bdisp_SetPoint_VRAM(0 + frame, point_y, foreground_color[color_index]);
            Bdisp_SetPoint_VRAM(SCREEN_WIDTH - frame, point_y, foreground_color[color_index]);
        }
    }
    for (point_x = 0 + INTRO_FRAME_SIZE; point_x <= SCREEN_WIDTH - INTRO_FRAME_SIZE; point_x++)
    Bdisp_SetPoint_VRAM(point_x, SCREEN_HEIGHT - INTRO_FRAME_SIZE * 3, foreground_color[color_index]);
    struct display_fill area1 = { INTRO_FRAME_SIZE + 2, INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 2, SCREEN_WIDTH - INTRO_FRAME_SIZE - 2, (INTRO_FRAME_SIZE * 2) + INTRO_TOP_MARGIN, 1 };
    Bdisp_AreaClr(&area1, 1, foreground_color[color_index]);
    struct display_fill area2 = { INTRO_FRAME_SIZE + 2, SCREEN_HEIGHT - (INTRO_FRAME_SIZE * 2), SCREEN_WIDTH - INTRO_FRAME_SIZE - 2, SCREEN_HEIGHT - INTRO_FRAME_SIZE - 2, 1 };
    Bdisp_AreaClr(&area2, 1, foreground_color[color_index]);
    print_mini_x = INTRO_FRAME_SIZE + 54;
    print_mini_y = INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 6;
    PrintMini(&print_mini_x, &print_mini_y, challenge, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    print_mini_x = INTRO_FRAME_SIZE + 3;
    print_mini_y = SCREEN_HEIGHT - (INTRO_FRAME_SIZE * 2) + 4;
    PrintMini(&print_mini_x, &print_mini_y, play_quit, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    for (i = 0; i < 3; i++)
    {
        print_mini_x = 35;
        print_mini_y = INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 35 + (i * 24);
        if (!blocked) PrintMini(&print_mini_x, &print_mini_y, intro_options[i],     0x40, 0xFFFFFFFF, 0, 0, foreground_color[color_index], background_color[color_index], 1, 0);
        else          PrintMini(&print_mini_x, &print_mini_y, intro_options[i] + 5, 0x40, 0xFFFFFFFF, 0, 0, foreground_color[color_index], background_color[color_index], 1, 0);
        print_mini_x = 260;
        if      (i == 0)   itoa(number_of_digits, (unsigned char*)string);
        else if (i == 1) { if      (allow_duplicate_digits == 0) strcpy(string, NO);
                           else if (allow_duplicate_digits == 1) strcpy(string, YES);
                           else if (allow_duplicate_digits == 2) strcpy(string, INPUT); }
        else if (i == 2) { if      (allow_incomplete_code  == 0) strcpy(string, NO);
                           else if (allow_incomplete_code  == 1) strcpy(string, YES); }
        PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
    }
    if (random(0, 2) == 1) { bug_right = 1; bug_clockwise = 1; } else { bug_down = 1; bug_clockwise = 0; }
    intro_scroll_text_buffer[0] = '\0';
    strcpy(intro_scroll_text_buffer, intro_help_me[0]);
    strcat(intro_scroll_text_buffer, " ");
    for (i = 1; i < 9; i++) { strcat(intro_scroll_text_buffer, intro_help_me[i]); strcat(intro_scroll_text_buffer, "     "); }
    intro_scrolling_wait = 0;
    intro_scrolling = 0;
    intro_scroll_text_buffer_position = INTRO_SCROLL_TEXT_LENGTH - 1;
    strncpy(intro_scroll_text_display, intro_scroll_text_buffer, INTRO_SCROLL_TEXT_LENGTH - 1);
    intro_scroll_text_display[INTRO_SCROLL_TEXT_LENGTH - 1] = '\0';
    print_mini_x = INTRO_FRAME_SIZE + 3;
    print_mini_y = SCREEN_HEIGHT - (INTRO_FRAME_SIZE * 3) + 5;
    PrintMini(&print_mini_x, &print_mini_y, intro_scroll_text_display, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
    while (0 == 0)
    {
        if (RTC_Elapsed_ms(main_timer, 400))
        {
            if (bug_corner_wait) { bug_corner_wait = 0; status = sleepy_bug(blocked); } else status = 0;
            key = PRGM_GetKey();
            if (key == KEY_RETURN                  || status == 4) { pgm_exit = 0; break;  }
            if (key == KEY_MENU || key == KEY_EXIT || status == 5) { pgm_exit = 1; return; }
            if (!blocked)
            {
                if (key == KEY_F1 || status == 1)
                {
                    number_of_digits++;
                    if (number_of_digits > 5) number_of_digits = 3;
                    itoa(number_of_digits, (unsigned char*)string);
                    print_mini_x = 260;
                    print_mini_y = INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 34;
                    PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
                    main_timer = RTC_GetTicks();
                }
                if (key == KEY_F2 || status == 2)
                {
                    allow_duplicate_digits++;
                    if (allow_duplicate_digits > 2) allow_duplicate_digits = 0;
                    if      (allow_duplicate_digits == 0) strcpy(string, NO);
                    else if (allow_duplicate_digits == 1) strcpy(string, YES);
                    else if (allow_duplicate_digits == 2) strcpy(string, INPUT);
                    print_mini_x = 260;
                    print_mini_y = INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 58;
                    PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
                    main_timer = RTC_GetTicks();
                }
                if (key == KEY_F3 || status == 3)
                {
                    allow_incomplete_code++;
                    if (allow_incomplete_code > 1) allow_incomplete_code = 0;
                    if      (allow_incomplete_code == 0) strcpy(string, NO);
                    else if (allow_incomplete_code == 1) strcpy(string, YES);
                    print_mini_x = 260;
                    print_mini_y = INTRO_FRAME_SIZE + INTRO_TOP_MARGIN + 82;
                    PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
                    main_timer = RTC_GetTicks();
                }
            }
        }
        PrintCXY(bug_x, bug_y, blank, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0);
        if      (bug_right) { bug_x += INTRO_BUG_SPEED; if (bug_x >= INTRO_BUG_X_MAX) { bug_x = INTRO_BUG_X_MAX; bug_corner_wait = 1; bug_right = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_down  = 1; else bug_left  = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_left  = 1; else bug_up    = 1; bug_clockwise = 0; } } }
        else if (bug_down)  { bug_y += INTRO_BUG_SPEED; if (bug_y >= INTRO_BUG_Y_MAX) { bug_y = INTRO_BUG_Y_MAX; bug_corner_wait = 1; bug_down  = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_left  = 1; else bug_up    = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_up    = 1; else bug_right = 1; bug_clockwise = 0; } } }
        else if (bug_left)  { bug_x -= INTRO_BUG_SPEED; if (bug_x <= INTRO_BUG_X_MIN) { bug_x = INTRO_BUG_X_MIN; bug_corner_wait = 1; bug_left  = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_up    = 1; else bug_right = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_right = 1; else bug_down  = 1; bug_clockwise = 0; } } }
        else if (bug_up)    { bug_y -= INTRO_BUG_SPEED; if (bug_y <= INTRO_BUG_Y_MIN) { bug_y = INTRO_BUG_Y_MIN; bug_corner_wait = 1; bug_up    = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_right = 1; else bug_down  = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_down  = 1; else bug_left  = 1; bug_clockwise = 0; } } }
        PrintCXY(bug_x, bug_y, bug, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0);
        Bdisp_PutDisp_DD();
        intro_scroll_text_on_display();
        OS_InnerWait_ms(10);
    }
    if (blocked) { LoadVRAM_1(); Bdisp_PutDisp_DD(); }
    main_timer = RTC_GetTicks();
}

void game_init(void)
{
    game_over = 0;
    guess_count = 1;
    display_init();
    build_empty_line();
    generate_magic_code();
    main_timer = RTC_GetTicks();
}

void pgm_init(void)
{
    restore_settings();
    random(RTC_GetTicks(), 1);
    ///////////////////////////////////////////////////////RTC_Reset(1);
    show_intro_screen(0);
    if (!pgm_exit) game_init();
}

void do_smiley(void)
{
    smiley++;
    if (smiley == 1)  { PrintCXY(300, 7, smiley1, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 5)  { PrintCXY(300, 7, smiley2, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 9)  { PrintCXY(300, 7, smiley3, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 13) { PrintCXY(300, 7, smiley4, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 17)   smiley = 0;
}

void blink_cursor(void)
{
    blink++;
    if (blink == 1) { PrintCXY(digit_position_x, digit_position_y, blank, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0);
                      Bdisp_PutDisp_DD(); return; }
    if (blink == 5) { digit[0] = guess_code[guess_count][digit_count - 1]; digit[1] = '\0';
                      PrintCXY(digit_position_x, digit_position_y, digit, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
                      Bdisp_PutDisp_DD(); return; }
    if (blink == 9)   blink = 0;
}

void set_digit(const char* input)
{
    PrintCXY(digit_position_x, digit_position_y, input, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
    guess_code[guess_count][digit_count - 1] = input[0];
    digit_count++;
    digit_position_x += 18;
    if (digit_count > number_of_digits) { digit_count = 1; digit_position_x = item_position_x + 23; }
    main_timer = RTC_GetTicks();
}

void cursor_next_digit(void)
{
    PrintCXY(item_position_x + 23, item_position_y, guess_code[guess_count], 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
    digit_count++;
    digit_position_x += 18;
    if (digit_count > number_of_digits) { digit_count = 1; digit_position_x = item_position_x + 23; }
    main_timer = RTC_GetTicks();
}

void cursor_previous_digit(void)
{
    PrintCXY(item_position_x + 23, item_position_y, guess_code[guess_count], 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
    digit_count--;
    digit_position_x -= 18;
    if (digit_count < 1) { digit_count = number_of_digits; digit_position_x = item_position_x + 23 + ((number_of_digits - 1) * 18); }
    main_timer = RTC_GetTicks();
}

void calculate_and_display_result(void)
{
    char magic_code_copy[6];
    unsigned int guess_result_index;
    unsigned int guess_code_index;
    unsigned int magic_code_index;
    int print_mini_x;
    int print_mini_y;
    strcpy(guess_result[guess_count], blank_result);
    strcpy(magic_code_copy, magic_code);
    guess_result_index = 0;
    for (guess_code_index = 0; guess_code_index < number_of_digits; guess_code_index++)
    {
        if (guess_code[guess_count][guess_code_index] == magic_code_copy[guess_code_index])
        {
            magic_code_copy[guess_code_index]             = ' ';
            guess_result[guess_count][guess_result_index] = '+';
            guess_result_index++;
        }
    }
    for (guess_code_index = 0; guess_code_index < number_of_digits; guess_code_index++)
    {
        for (magic_code_index = 0; magic_code_index < number_of_digits; magic_code_index++)
        {
            if (guess_code_index != magic_code_index)
            {
                if (guess_code[guess_count][guess_code_index] == magic_code_copy[magic_code_index])
                {
                    magic_code_copy[magic_code_index]             = ' ';
                    guess_result[guess_count][guess_result_index] = '-';
                    guess_result_index++;
                }
            }
        }
    }
    guess_result[guess_count][guess_result_index] = '\0';
    print_mini_x = item_position_x + 120;
    print_mini_y = item_position_y + 2;
    PrintMini(&print_mini_x, &print_mini_y, guess_result[guess_count], 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
}

void congratulations(void)
{
    const char congrats[] = "Congratulations!\0";
    char letter[] = "__ \0";
    unsigned int dialog_box_color[7] = { TEXT_COLOR_RED, TEXT_COLOR_GREEN, TEXT_COLOR_BLUE, TEXT_COLOR_CYAN, TEXT_COLOR_PURPLE, TEXT_COLOR_YELLOW, TEXT_COLOR_BLACK };
    unsigned int new_color = 9;
    unsigned int previous_color = 9;
    unsigned int i;
    for (i = 0; i < strlen(congrats); i++)
    {
        while (new_color == previous_color) new_color = random(0, 7);
        previous_color = new_color;
        letter[2] = congrats[i];
        PrintXY(4 + i, 2, letter, TEXT_MODE_NORMAL, dialog_box_color[new_color]);
    }
}

void show_dialog_box(int dialog)
{
    int i;
    int lines = 0;
    int mode = TEXT_MODE_INVERT;
    char magic[8];
    magic[0] = '\0';
    if (dialog == 1 || dialog == 2) lines = 4; else if (dialog == 3 || dialog == 4) lines = 5;
    DrawFrame(background_color[color_index]);
    MsgBoxPush(lines);
    if (dialog == 3) { congratulations(); lines--; mode = TEXT_MODE_NORMAL; }
    for (i = 0; i < lines; i++)
    {
        if      (dialog == 1) PrintXY(3, 2 + i, dialog_box_1[i], TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
        else if (dialog == 2) PrintXY(3, 2 + i, dialog_box_2[i], TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
        else if (dialog == 3) PrintXY(3, 3 + i, dialog_box_3[i], TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
        else if (dialog == 4) PrintXY(3, 2 + i, dialog_box_4[i], TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
    }
    if (dialog == 3 || dialog == 4)
    {
        game_over = 1;
        strcpy(magic, "__");
        strcat(magic, magic_code);
        PrintXY(14, 3, magic, mode, TEXT_COLOR_BLACK);
    }
    Bdisp_PutDisp_DD();
    while (PRGM_GetKey() != KEY_EXIT)
    {
        gizmo++;
        if (gizmo == 1)
        {
            if      (dialog == 1) PrintXY(15, 3, "__!",   TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
            else if (dialog == 2) PrintXY(17, 3, "__!",   TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
            else if (dialog == 3) PrintXY(16, 4, "__:-)", TEXT_MODE_NORMAL, TEXT_COLOR_RED);
            else if (dialog == 4) PrintXY( 5, 4, "__:-(", TEXT_MODE_NORMAL, TEXT_COLOR_RED);
            Bdisp_PutDisp_DD();
        }
        else if (gizmo == 3)
        {
            if      (dialog == 1) PrintXY(15, 3, "__ ",   TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
            else if (dialog == 2) PrintXY(17, 3, "__ ",   TEXT_MODE_NORMAL, TEXT_COLOR_BLACK);
            else if (dialog == 3) PrintXY(16, 4, "__:-D", TEXT_MODE_NORMAL, TEXT_COLOR_RED);
            else if (dialog == 4) PrintXY( 5, 4, "__:-|", TEXT_MODE_NORMAL, TEXT_COLOR_RED);
            Bdisp_PutDisp_DD();
        }
        else if (gizmo == 5) gizmo = 0;
        OS_InnerWait_ms(100);
    }
    MsgBoxPop();
    DrawFrame(background_color[color_index]);
    Bdisp_PutDisp_DD();
    main_timer = RTC_GetTicks();
}

void check_code(void)
{
    unsigned int guess_code_index;
    unsigned int valid_digits_index;
    char valid_digits[11] = "0123456789\0";
    unsigned char is_duplicate_digit = 0;
    PrintCXY(item_position_x + 23, item_position_y, guess_code[guess_count], 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
    Bdisp_PutDisp_DD();
    if (allow_incomplete_code == 0)
    {
        for (guess_code_index = 0; guess_code_index < number_of_digits; guess_code_index++)
        {
            if (!isdigit(guess_code[guess_count][guess_code_index])) { show_dialog_box(1); return; }
        }
    }
    if (allow_duplicate_digits == 0)
    {
        for (guess_code_index = 0; guess_code_index < number_of_digits; guess_code_index++)
        {
            is_duplicate_digit = 1;
            for (valid_digits_index = 0; valid_digits_index <= 9; valid_digits_index++)
            {
                if (guess_code[guess_count][guess_code_index] == valid_digits[valid_digits_index])
                {
                    valid_digits[valid_digits_index] = ' ';
                    is_duplicate_digit = 0;
                    break;
                }
            }
            if (is_duplicate_digit) { show_dialog_box(2); return; }
        }
    }
    calculate_and_display_result();
    if (strcmp(magic_code, guess_code[guess_count]) == 0) { show_dialog_box(3); return; }
    if (guess_count == 12)                                { show_dialog_box(4); return; }
    guess_count++;
    build_empty_line();
    main_timer = RTC_GetTicks();
}

void display_rebuild(void)
{
    char string[10];
    char line[10];
    unsigned int i;
    unsigned int stuff_position_x;
    unsigned int stuff_position_y;
    int print_x;
    int print_y;
    for (i = 1; i <= guess_count; i++)
    {
        string[0] = '\0';
        line[0] = '\0';
        if (i <= 6) { stuff_position_x = 8;   stuff_position_y = i * 28 + 18;       }
        else        { stuff_position_x = 195; stuff_position_y = (i - 6) * 28 + 18; }
        itoa(i, (unsigned char*)string);
        if (i <= 9) strcat(line, "0");
        strcat(line, string);
        print_x = stuff_position_x;
        print_y = stuff_position_y + 5;
        PrintMiniMini(&print_x, &print_y, line, print_mini_mini_mode[color_index], print_mini_mini_color[color_index], 0);
        PrintCXY(stuff_position_x + 23, stuff_position_y, guess_code[i], 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0);
        print_x = stuff_position_x + 120;
        print_y = stuff_position_y + 2;
        PrintMini(&print_x, &print_y, guess_result[i], 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
    }
    Bdisp_PutDisp_DD();
}

void change_color_up(void)
{
    color_index++;
    if (color_index >= NUMBER_OF_COLORS) color_index = 0;
    display_init();
    display_rebuild();
    main_timer = RTC_GetTicks();
}

void change_color_down(void)
{
    color_index--;
    if (color_index < 0) color_index = NUMBER_OF_COLORS - 1;
    display_init();
    display_rebuild();
    main_timer = RTC_GetTicks();
}

void calc_off(void)
{
    PowerOff(1);
}

int main(void)
{
    int key = 0;
    pgm_init();
    while (key != KEY_MENU && key != KEY_EXIT && !pgm_exit)
    {
        if (RTC_Elapsed_ms(main_timer, 400))
        {
            key = PRGM_GetKey();
            switch (key)
            {
                case KEY_0:          if (!game_over) set_digit("0");                   break;
                case KEY_1:          if (!game_over) set_digit("1");                   break;
                case KEY_2:          if (!game_over) set_digit("2");                   break;
                case KEY_3:          if (!game_over) set_digit("3");                   break;
                case KEY_4:          if (!game_over) set_digit("4");                   break;
                case KEY_5:          if (!game_over) set_digit("5");                   break;
                case KEY_6:          if (!game_over) set_digit("6");                   break;
                case KEY_7:          if (!game_over) set_digit("7");                   break;
                case KEY_8:          if (!game_over) set_digit("8");                   break;
                case KEY_9:          if (!game_over) set_digit("9");                   break;
                case KEY_RIGHT:      if (!game_over) cursor_next_digit();              break;
                case KEY_UP:         if (!game_over) cursor_next_digit();              break;
                case KEY_LEFT:       if (!game_over) cursor_previous_digit();          break;
                case KEY_DOWN:       if (!game_over) cursor_previous_digit();          break;
                case KEY_RETURN:     if (!game_over) check_code(); else game_init();   break;
                case KEY_RPAR:       change_color_up();                                break;
                case KEY_LPAR:       change_color_down();                              break;
                case KEY_PMINUS:     show_intro_screen(1);                             break;
                case KEY_ACON:       calc_off();                                       break;
            }
        }
        if (!game_over && !pgm_exit) do_smiley();
        if (!game_over && !pgm_exit) blink_cursor();
        // OS_InnerWait_ms(100);
        OS_InnerWait_ms(50);
    }
    Bdisp_AllClr_VRAM();
    save_settings();
    return 0;
}
