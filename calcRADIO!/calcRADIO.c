/*
*******************************************************************
*                                                                 *
*   CASIO fx-CG10/20/50 SDK Library                               *
*                                                                 *
*   File name : calcRADIO.c                                       *
*                                                                 *
*   FM / DAB+ / INTERNET / MP3 Player                             *
*                                                                 *
*   Compiled with non-official CASIO SDK: PrizmSDK+libfxcg v0.6   *
*   https://github.com/Jonimoose/libfxcg/releases                 *
*                                                                 *
*   JJR / February 2025                                           *
*                                                                 *
*******************************************************************
*/

#include <fxcg/keyboard.h>
#include <fxcg/display.h>
#include <fxcg/system.h>
#include <fxcg/serial.h>
#include <fxcg/misc.h>
#include <fxcg/file.h>
#include <fxcg/rtc.h>
#include <string.h>
#include <stdlib.h>

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
#define KEY_SIN      46
#define KEY_COS      36
#define KEY_TAN      26
#define KEY_ABC      75
#define KEY_LOG      66
#define KEY_COMMA    35

#define SAVEFILE "\\\\fls0\\calcRADIO.sav"
#define SCREEN_WIDTH            383
#define SCREEN_HEIGHT           215
#define BORDER_SIZE               4
#define TEXT_ALL_POS_X           10
#define TEXT_2_POS_X            200
#define TEXT_3_POS_X            300
#define TEXT_1_POS_Y             11
#define TEXT_2_POS_Y             49
#define TEXT_3_POS_Y             90
#define TEXT_4_POS_Y            134
#define TEXT_5_POS_Y            180
#define TEXT_6_POS_Y              7
#define HELP_PAGE_TOP_MARGIN      7
#define HELP_PAGE_FRAME_SIZE     25
#define HELP_PAGE_TEXT_POS_X     35
#define HELP_PAGE_CHANGE_WAIT    99
#define HELP_PAGE_NB_OF_PAGES     5
#define HELP_PAGE_NB_OF_ITEMS    20
#define BUG_X_MIN                 1
#define BUG_Y_MIN                 8
#define BUG_X_MAX               364
#define BUG_Y_MAX               191
#define BUG_SPEED                 5
#define NUMBER_OF_COLORS         10

unsigned int main_timer = 0;
unsigned int mode = 1;
unsigned int preset = 0;
unsigned int volume = 10;
unsigned int last_mode = 0;
unsigned int last_preset = 0;
unsigned int smiley = 0;
unsigned int scrolling = 0;
unsigned int scroll_text_buffer_position = 0;
unsigned int scroll_text_separator = 0;
unsigned int song_station_http = 0;
unsigned int change_help_page = HELP_PAGE_CHANGE_WAIT;
unsigned int foreground_color[NUMBER_OF_COLORS] = { COLOR_INDIGO, COLOR_NAVY,    COLOR_MAROON,    COLOR_DARKRED,   COLOR_DARKSLATEGRAY, COLOR_FIREBRICK, COLOR_MIDNIGHTBLUE,   COLOR_KHAKI,       COLOR_WHITE, COLOR_BLACK };
unsigned int background_color[NUMBER_OF_COLORS] = { COLOR_YELLOW, COLOR_GOLD,    COLOR_BURLYWOOD, COLOR_MISTYROSE, COLOR_ROSYBROWN,     COLOR_ORANGE,    COLOR_CORNFLOWERBLUE, COLOR_FORESTGREEN, COLOR_BLACK, COLOR_WHITE };
unsigned int others_color[NUMBER_OF_COLORS]     = { COLOR_RED,    COLOR_CRIMSON, COLOR_ORANGERED, COLOR_ORANGERED, COLOR_ANTIQUEWHITE,  COLOR_DIMGRAY,   COLOR_AQUA,           COLOR_LIME,        COLOR_WHITE, COLOR_BLACK };
int color_index = 0;
unsigned char mute = 0;
unsigned char equalizer = 0;
unsigned char do_scrolling = 0;
unsigned char shutdown = 0;
char scroll_text_buffer[256];
char scroll_text_display[21];
const char title[11] = "calcRADIO!";
const char version[5] = "v1.0";
const char mute_desc[9] = "[ mute ]";
const char equalizer_on[6] = "EQ:on";
const char equalizer_off[7] = "EQ:off";
const char blank_line_short[9] = "        ";
const char blank_line_shorter[7] = "      ";
const char blank_line_long[21] = "                    ";
const char blank_line_help[46] = "                                             ";
const char help[7] = { 0x7F, 0x50, 0x3D, 0x28, 0x2D, 0x29, 0 };
const char smiley1[6] = { 0x28, 0x5E, 0x5F, 0x5E, 0x29, 0 };
const char smiley2[6] = { 0x28, 0x27, 0x2E, 0x27, 0x29, 0 };
const char smiley3[6] = { 0x28, 0x9C, 0x5F, 0x9C, 0x29, 0 };
const char smiley4[8] = { 0x28, 0xE5, 0xCC, 0x5F, 0xE5, 0xCC, 0x29, 0 };
const char point[3] = { 0xE5, 0xA7, 0 };
const char arrow[3] = { 0xE6, 0x91, 0 };
const char bug[3] = { 0xE6, 0xA6, 0 };
const char blank[3] = { 0xE6, 0x00, 0 };
const char copyright[3] = { 0xE5, 0x9E, 0 };
const char jj[3] = { 0x6A, 0x6A, 0 };
const char CRLF[3] = { '\r', '\n', '\0' };
const char degree[2] = { 0x9C, 0 };
const char mode_desc[10][21] =   { "",
                                   "FM RADIO",
                                   "DAB+ RADIO #1",
                                   "DAB+ RADIO #2",
                                   "INTERNET RADIO #1",
                                   "INTERNET RADIO #2",
                                   "INTERNET RADIO #3",
                                   "INTERNET RADIO #4",
                                   "RANDOM INTERNET",
                                   "MP3 PLAYER" };
const char preset_desc[10][6] =  { "zero",
                                   "one",
                                   "two",
                                   "three",
                                   "four",
                                   "five",
                                   "six",
                                   "seven",
                                   "eight",
                                   "nine" };
const char random_desc[10][12] = { "everything",
                                   "talk",
                                   "pop",
                                   "alternative",
                                   "country",
                                   "oldies",
                                   "60s",
                                   "70s",
                                   "80s",
                                   "90s" };
const char help_desc_1[20][15] = { "[F1]~[F6]",
                                   "[Arrows]",
                                   "[0]~[9]",
                                   "[+] [-]",
                                   "[DEL]",
                                   "[ABC]",
                                   "[EXE]",
                                   "[EXP]",
                                   "[.]",
                                   "[)]",
                                   "[(]",
                                   "[^]",
                                   "[TAN]",
                                   "[LOG]",
                                   "[x2]",
                                   "[->]",
                                   "[AC]",
                                   "[SHIFT] (Mute)",
                                   "[ALPHA] (Mute)",
                                   "[(-)]" };
const char help_desc_2[20][27] = { "Set Mode (Fast)",
                                   "Set Mode (Slow)",
                                   "Set Preset",
                                   "Adjust Volume",
                                   "Mute / Unmute",
                                   "Set Equalizer",
                                   "Play Random Radio",
                                   "Play Special Radio",
                                   "Radio Play / Stop",
                                   "Play Next",
                                   "Play Previous",
                                   "Show Song / Station / http",
                                   "Show CPU and Temp",
                                   "Show Up Since",
                                   "Speaker Test",
                                   "Recall Previous",
                                   "Calc Off",
                                   "Update DB",
                                   "Power Down",
                                   "This Help" };

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
    itoa(volume, (unsigned char*)string);
    if      (strlen(string) == 0) strcat(line, "000");
    else if (strlen(string) == 1) strcat(line, "00");
    else if (strlen(string) == 2) strcat(line, "0");
    strcat(line, string);
    Bfile_SeekFile_OS(file_handle, 0);
    Bfile_WriteFile_OS(file_handle, &line, strlen(line));
    Bfile_CloseFile_OS(file_handle);
}

void restore_settings(void)
{
    int file_handle;
    unsigned short file_name[sizeof(SAVEFILE) * 2];
    char string[10];
    string[0] = '\0';
    Bfile_StrToName_ncpy(file_name, SAVEFILE, sizeof(SAVEFILE));
    file_handle = Bfile_OpenFile_OS(file_name, 0, 0);
    if (file_handle >= 0)
    {
        Bfile_ReadFile_OS(file_handle, &string, 1, 0);
        color_index = atoi(string);
        Bfile_ReadFile_OS(file_handle, &string, 3, 1);
        volume = atoi(string);
        Bfile_CloseFile_OS(file_handle);
    }
}

void open_serial_port(void)
{
    unsigned char open_mode[6];
    open_mode[0] = 0;
    open_mode[1] = 9; // 0=300, 1=600, 2=1200, 3=2400, 4=4800, 5=9600, 6=19200, 7=38400, 8=57600, 9=115200 baud
    open_mode[2] = 0; // parity: 0=no; 1=odd; 2=even
    open_mode[3] = 0; // datalength: 0=8 bit; 1=7 bit
    open_mode[4] = 0; // stop bits: 0=one; 1=two
    open_mode[5] = 0;
    if (Serial_IsOpen() != 1) Serial_Open(open_mode);
}

void close_serial_port(void)
{
    if (Serial_IsOpen() == 1) Serial_Close(1);
}

void receive_serial_data(void)
{
    unsigned int status;
    unsigned char end_of_line_character;
    unsigned int receive_buffer_size = 256;
    char receive_buffer[receive_buffer_size];
    short actual_receive_size;
    char *action       = "\0";
    char operation[64] = "\0";
    char parameter[64] = "\0";
    if (Serial_IsOpen() == 1 && Serial_PollRX() > 0)
    {
        status = Serial_Peek(Serial_PollRX() - 2, &end_of_line_character);
        if (status == 0 && end_of_line_character == '^')
        {
            status = Serial_Read((unsigned char*)&receive_buffer, receive_buffer_size, &actual_receive_size);
            if (status == 0)
            {
                receive_buffer[actual_receive_size - 2] = '\0';
                action = strchr(receive_buffer, '=');
                if (action != NULL)
                {
                    strcpy(parameter, action + 1);
                    strcpy(operation, receive_buffer);
                    strtok(operation, "=");
                    if (operation != NULL)
                    {
                        if (strcmp(operation, "PRESET") == 0 && strcmp(parameter, "") != 0)
                        {
                            PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
                            PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, parameter, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                            Bdisp_PutDisp_DD();
                            return;
                        }
                        if (strcmp(operation, "TEMPERATURE") == 0 && strcmp(parameter, "") != 0)
                        {
                            for (int i = 0; i < strlen(parameter); i++)
                            {
                                if (parameter[i] == '|') parameter[i] = degree[0];
                            }
                            strcpy(receive_buffer, parameter);
                        }
                    }
                }
                if (actual_receive_size <= 22)
                {
                    do_scrolling = 0;
                    strncpy(scroll_text_display, receive_buffer, 20);
                }
                else
                {
                    do_scrolling = 1;
                    scrolling = 0;
                    scroll_text_buffer_position = 20;
                    scroll_text_separator = 0;
                    strcpy(scroll_text_buffer, receive_buffer);
                    scroll_text_buffer[actual_receive_size - 2] = '\0';
                    strncpy(scroll_text_display, scroll_text_buffer, 20);
                }
                scroll_text_display[20] = '\0';
                PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
                PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, scroll_text_display, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                Bdisp_PutDisp_DD();
                OS_InnerWait_ms(2000);
            }
            Serial_ClearRX();
        }
    }
}

void send_serial_data(char* operation, unsigned int parameter)
{
    char line[25];
    char string[10];
    line[0] = '\0';
    string[0] = '\0';
    strcat(line, operation);
    itoa(parameter, (unsigned char*)string);
    strcat(line, string);
    PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, line, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
    if (Serial_IsOpen() == 1)
    {
        Serial_ClearTX();
        strcat(line, CRLF);
        Serial_Write((unsigned char*)&line, strlen(line));
    }
    main_timer = RTC_GetTicks();
}

void display_mode(void)
{
    char line[25];
    line[0] = '\0';
    strcat(line, point);
    strcat(line, mode_desc[mode]);
    strcat(line, point);
    PrintCXY(TEXT_ALL_POS_X, TEXT_2_POS_Y, blank_line_long, 0x40, -1, foreground_color[color_index], foreground_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_2_POS_Y, line, 0x40, -1, background_color[color_index], foreground_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void display_preset(void)
{
    char line[25];
    line[0] = '\0';
    strcat(line, arrow);
    if (mode == 1 || mode == 2 || mode == 3 || mode == 4 || mode == 5 || mode == 6 || mode == 7)
    {
        strcat(line, " Preset ");
        strcat(line, preset_desc[preset]);
    }
    if (mode == 8)
    {
        strcat(line, " Random ");
        strcat(line, random_desc[preset]);
    }
    if (mode == 9)
    {
        strcat(line, " Random mp3");
    }
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, line, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void display_volume(void)
{
    char line[25];
    char string[10];
    line[0] = '\0';
    string[0] = '\0';
    strcat(line, "Vol:");
    itoa(volume, (unsigned char*)string);
    strcat(line, string);
    strcat(line, "%");
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, blank_line_short, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, line, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void display_mute(void)
{
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, blank_line_short, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, mute_desc, 0x40, -1, background_color[color_index], foreground_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void display_equalizer(void)
{
    PrintCXY(TEXT_2_POS_X, TEXT_4_POS_Y, blank_line_shorter, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    if (equalizer) PrintCXY(TEXT_2_POS_X, TEXT_4_POS_Y, equalizer_on, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    else           PrintCXY(TEXT_2_POS_X, TEXT_4_POS_Y, equalizer_off, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void display_init(void)
{
    Bdisp_AllClr_VRAM();
    EnableStatusArea(3);
    Bdisp_EnableColor(1);
    Bdisp_Fill_VRAM(background_color[color_index], 3);
    DrawFrame(background_color[color_index]);
    struct display_fill area1 = { 0, 5, 195, 40, 1 };
    Bdisp_AreaClr(&area1, 1, foreground_color[color_index]);
    struct display_fill area2 = { 0, 40, SCREEN_WIDTH, 80, 1 };
    Bdisp_AreaClr(&area2, 1, foreground_color[color_index]);
    struct display_fill area3 = { 0, 80, BORDER_SIZE, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area3, 1, foreground_color[color_index]);
    struct display_fill area4 = { SCREEN_WIDTH - BORDER_SIZE, 80, SCREEN_WIDTH, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area4, 1, foreground_color[color_index]);
    struct display_fill area5 = { 0, SCREEN_HEIGHT - BORDER_SIZE, SCREEN_WIDTH, SCREEN_HEIGHT, 1 };
    Bdisp_AreaClr(&area5, 1, foreground_color[color_index]);
    struct display_fill area6 = { 0, 120, SCREEN_WIDTH, 120 + BORDER_SIZE, 1 };
    Bdisp_AreaClr(&area6, 1, foreground_color[color_index]);
    struct display_fill area7 = { 0, 164, SCREEN_WIDTH, 164 + BORDER_SIZE, 1 };
    Bdisp_AreaClr(&area7, 1, foreground_color[color_index]);
    struct display_fill area8 = { 313, 120, 313 + BORDER_SIZE, 164, 1 };
    Bdisp_AreaClr(&area8, 1, foreground_color[color_index]);
    PrintCXY(TEXT_ALL_POS_X, TEXT_1_POS_Y, title, 0x40, -1, background_color[color_index], foreground_color[color_index], 1, 0 );
    PrintCXY(TEXT_2_POS_X, TEXT_6_POS_Y, help, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(322, 128, copyright, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(340, 137, jj, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0 );
    display_mode();
    display_preset();
    display_volume();
    display_equalizer();
    if (mute) display_mute();
}

void radio_init(void)
{
    /////////////////////////////////////////RTC_Reset(1);
    main_timer = RTC_GetTicks();
    restore_settings();
    open_serial_port();
    display_init();
    send_serial_data("init_mode=", mode);
    send_serial_data("init_preset=", preset);
    send_serial_data("init_volume=", volume);
}

void do_smiley(void)
{
    smiley++;
    if (smiley == 1)  { PrintCXY(TEXT_3_POS_X, TEXT_6_POS_Y, smiley1, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 5)  { PrintCXY(TEXT_3_POS_X, TEXT_6_POS_Y, smiley2, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 9)  { PrintCXY(TEXT_3_POS_X, TEXT_6_POS_Y, smiley3, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 13) { PrintCXY(TEXT_3_POS_X, TEXT_6_POS_Y, smiley4, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
                        Bdisp_PutDisp_DD(); return; }
    if (smiley == 17)   smiley = 0;
}

void scroll_text_on_display(void)
{
    unsigned int i;
    if (do_scrolling)
    {
        scrolling++;
        if (scrolling == 4)
        {
            scrolling = 0;
            for (i = 0; i < 19; i++) scroll_text_display[i] = scroll_text_display[i + 1];
            if (scroll_text_buffer[scroll_text_buffer_position] == '\0')
            {
                scroll_text_display[19] = ' ';
                scroll_text_separator++;
                if (scroll_text_separator == 3)
                {
                    scroll_text_separator = 0;
                    scroll_text_buffer_position = 0;
                }
            }
            else
            {
                scroll_text_display[19] = scroll_text_buffer[scroll_text_buffer_position];
                scroll_text_buffer_position++;
            }
            scroll_text_display[20] = '\0';
            PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
            PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, scroll_text_display, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
            Bdisp_PutDisp_DD();
        }
    }
}

void clear_scroll_text(void)
{
    do_scrolling = 0;
    PrintCXY(TEXT_ALL_POS_X, TEXT_5_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
}

void set_mode(int M)
{
    mode = M;
    display_mode();
    clear_scroll_text();
    send_serial_data("set_mode=", mode);
}

void change_mode_up(void)
{
    mode += 1;
    if (mode > 9) mode = 1;
    set_mode(mode);
}

void change_mode_down(void)
{
    mode -= 1;
    if (mode < 1) mode = 9;
    set_mode(mode);
}

void set_preset(int P)
{
    preset = P;
    display_preset();
    clear_scroll_text();
    last_mode = mode;
    last_preset = preset;
    send_serial_data("set_preset=", preset);
}

void set_volume_up(void)
{
    if (volume < 100)
    {
        volume += 1;
        if (volume > 100) volume = 100;
        display_volume();
        send_serial_data("set_volume_up=", volume);
    }
}

void set_volume_down(void)
{
    if (volume > 0)
    {
        volume -= 1;
        if (volume < 0) volume = 0;
        display_volume();
        send_serial_data("set_volume_down=", volume);
    }
}

void set_mute(void)
{
    if (mute) { mute = 0; display_volume(); } else { mute = 1; display_mute(); }
    send_serial_data("set_mute=", mute);
}

void set_equalizer(void)
{
    if (equalizer) { equalizer = 0; display_equalizer(); } else { equalizer = 1; display_equalizer(); }
    send_serial_data("set_equalizer=", equalizer);
}

void show_song_station_http(void)
{
    song_station_http++;
    if      (song_station_http == 1)   send_serial_data("show_song=",    1);
    else if (song_station_http == 2)   send_serial_data("show_station=", 1);
    else if (song_station_http == 3) { send_serial_data("show_http=",    1); song_station_http = 0; }
}

void play_random_radio(void)
{
    char line[25];
    mode = 8;
    display_mode();
    clear_scroll_text();
    line[0] = '\0';
    strcat(line, arrow);
    strcat(line, " play random radio");
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, line, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
    send_serial_data("play_random=", 1);
}

void play_special_radio(void)
{
    char line[25];
    mode = 4;
    display_mode();
    clear_scroll_text();
    line[0] = '\0';
    strcat(line, arrow);
    strcat(line, " play special radio");
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, line, 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    Bdisp_PutDisp_DD();
    send_serial_data("play_special=", 1);
}

void recall_previous_preset(void)
{
    if (last_mode != 0) { set_mode(last_mode); set_preset(last_preset); }
}

void radio_play_stop(void)
{
    clear_scroll_text();
    send_serial_data("play_stop=", 1);
}

void play_next(void)
{
    clear_scroll_text();
    send_serial_data("play_next=", 1);
}

void play_previous(void)
{
    clear_scroll_text();
    send_serial_data("play_previous=", 1);
}

void test_speaker(void)
{
    clear_scroll_text();
    send_serial_data("test_speaker=", 1);
}

void update_database(void)
{
    clear_scroll_text();
    send_serial_data("update_database=", 1);
}

void show_cpu_and_temp(void)
{
    clear_scroll_text();
    send_serial_data("show_cpu_and_temp=", 1);
}

void show_up_since(void)
{
    clear_scroll_text();
    send_serial_data("show_up_since=", 1);
}

void test_key(void)
{
    clear_scroll_text();
    send_serial_data("test_key=", 1);
}

unsigned char sleepy_bug(void)
{
    unsigned int min = 0;
    unsigned int max = random(0, 256);
    unsigned int no_wait = random(0, 10);
    if (!no_wait)
    {
        for (min = 0; min <= max; min++)
        {
            OS_InnerWait_ms(30);
            change_help_page += 3;
            if (change_help_page > HELP_PAGE_CHANGE_WAIT) return 0;
            if (PRGM_GetKey() == KEY_RETURN)              return 1;
        }
    }
    return 0;
}

void show_help(void)
{
    unsigned int frame;
    unsigned int point_x;
    unsigned int point_y;
    unsigned int help_page_number = 0;
    unsigned int help_desc_index = 0;
    int help_desc_row = 0;
    int help_desc_col[6] = { 0, 160, 140, 80, 130, 210 };
    int print_mini_x;
    int print_mini_y;
    int bug_x = BUG_X_MIN;
    int bug_y = BUG_Y_MIN;
    unsigned char bug_right = 0;
    unsigned char bug_left = 0;
    unsigned char bug_down = 0;
    unsigned char bug_up = 0;
    unsigned char bug_clockwise = 0;
    unsigned char bug_corner_wait = 0;
    char string[10];
    string[0] = '\0';
    change_help_page = HELP_PAGE_CHANGE_WAIT;
    random(RTC_GetTicks(), 1);
    SaveVRAM_1();
    Bdisp_AllClr_VRAM();
    EnableStatusArea(3);
    Bdisp_EnableColor(1);
    Bdisp_Fill_VRAM(background_color[color_index], 3);
    DrawFrame(background_color[color_index]);
    for (frame = 0; frame <= HELP_PAGE_FRAME_SIZE; frame += HELP_PAGE_FRAME_SIZE)
    {
        for (point_x = 0 + frame; point_x <= SCREEN_WIDTH - frame; point_x++)
        {
            Bdisp_SetPoint_VRAM(point_x, HELP_PAGE_TOP_MARGIN + frame, foreground_color[color_index]);
            Bdisp_SetPoint_VRAM(point_x, SCREEN_HEIGHT - frame, foreground_color[color_index]);
        }
        for (point_y = HELP_PAGE_TOP_MARGIN + frame; point_y <= SCREEN_HEIGHT - frame; point_y++)
        {
            Bdisp_SetPoint_VRAM(0 + frame, point_y, foreground_color[color_index]);
            Bdisp_SetPoint_VRAM(SCREEN_WIDTH - frame, point_y, foreground_color[color_index]);
        }
    }
    struct display_fill area1 = { HELP_PAGE_FRAME_SIZE + 2, HELP_PAGE_FRAME_SIZE + HELP_PAGE_TOP_MARGIN + 2, SCREEN_WIDTH - HELP_PAGE_FRAME_SIZE - 2, (HELP_PAGE_FRAME_SIZE * 2) + HELP_PAGE_TOP_MARGIN, 1 };
    Bdisp_AreaClr(&area1, 1, foreground_color[color_index]);
    struct display_fill area2 = { HELP_PAGE_FRAME_SIZE + 2, SCREEN_HEIGHT - (HELP_PAGE_FRAME_SIZE * 2), SCREEN_WIDTH - HELP_PAGE_FRAME_SIZE - 2, SCREEN_HEIGHT - HELP_PAGE_FRAME_SIZE - 2, 1 };
    Bdisp_AreaClr(&area2, 1, foreground_color[color_index]);
    print_mini_x = HELP_PAGE_TEXT_POS_X;
    print_mini_y = HELP_PAGE_FRAME_SIZE + HELP_PAGE_TOP_MARGIN + 6;
    PrintMini(&print_mini_x, &print_mini_y, title, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    print_mini_x = 160;
    PrintMini(&print_mini_x, &print_mini_y, version, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    print_mini_x = 257;
    PrintMini(&print_mini_x, &print_mini_y, "Help(  /  )", 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    print_mini_x = 103;
    print_mini_y = SCREEN_HEIGHT - (HELP_PAGE_FRAME_SIZE * 2) + 4;
    PrintMini(&print_mini_x, &print_mini_y, "Press [EXE] to exit", 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
    if (random(0, 2) == 1)
    {
        bug_right = 1;
        bug_clockwise = 1;
    }
    else
    {
        bug_down = 1;
        bug_clockwise = 0;
    }
    while (PRGM_GetKey() != KEY_RETURN)
    {
        change_help_page++;
        if (change_help_page > HELP_PAGE_CHANGE_WAIT)
        {
            change_help_page = 0;
            help_page_number++;
            if (help_page_number > HELP_PAGE_NB_OF_PAGES) help_page_number = 1;
            itoa(help_page_number, (unsigned char*)string);
            print_mini_x = 308;
            print_mini_y = HELP_PAGE_FRAME_SIZE + HELP_PAGE_TOP_MARGIN + 6;
            PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
            itoa(HELP_PAGE_NB_OF_PAGES, (unsigned char*)string);
            print_mini_x = 331;
            PrintMini(&print_mini_x, &print_mini_y, string, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], foreground_color[color_index], 1, 0);
            for (help_desc_row = 71; help_desc_row <= 137; help_desc_row += 22)
            {
                print_mini_x = HELP_PAGE_TEXT_POS_X;
                print_mini_y = help_desc_row;
                PrintMini(&print_mini_x, &print_mini_y, blank_line_help, 0x40, 0xFFFFFFFF, 0, 0, background_color[color_index], background_color[color_index], 1, 0);
                if (help_desc_index < HELP_PAGE_NB_OF_ITEMS)
                {
                    print_mini_x = HELP_PAGE_TEXT_POS_X;
                    PrintMini(&print_mini_x, &print_mini_y, help_desc_1[help_desc_index], 0x40, 0xFFFFFFFF, 0, 0, others_color[color_index], background_color[color_index], 1, 0);
                    print_mini_x = help_desc_col[help_page_number];
                    PrintMini(&print_mini_x, &print_mini_y, help_desc_2[help_desc_index], 0x40, 0xFFFFFFFF, 0, 0, foreground_color[color_index], background_color[color_index], 1, 0);
                }
                help_desc_index++;
            }
            if (help_desc_index == HELP_PAGE_NB_OF_ITEMS) help_desc_index = 0;
        }
        PrintCXY(bug_x, bug_y, blank, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0);
        if      (bug_right) { bug_x += BUG_SPEED; if (bug_x >= BUG_X_MAX) { bug_x = BUG_X_MAX; bug_corner_wait = 1; bug_right = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_down  = 1; else bug_left  = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_left  = 1; else bug_up    = 1; bug_clockwise = 0; }}}
        else if (bug_down)  { bug_y += BUG_SPEED; if (bug_y >= BUG_Y_MAX) { bug_y = BUG_Y_MAX; bug_corner_wait = 1; bug_down  = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_left  = 1; else bug_up    = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_up    = 1; else bug_right = 1; bug_clockwise = 0; }}}
        else if (bug_left)  { bug_x -= BUG_SPEED; if (bug_x <= BUG_X_MIN) { bug_x = BUG_X_MIN; bug_corner_wait = 1; bug_left  = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_up    = 1; else bug_right = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_right = 1; else bug_down  = 1; bug_clockwise = 0; }}}
        else if (bug_up)    { bug_y -= BUG_SPEED; if (bug_y <= BUG_Y_MIN) { bug_y = BUG_Y_MIN; bug_corner_wait = 1; bug_up    = 0; if (random(0, 2) == 1) { if (bug_clockwise) bug_right = 1; else bug_down  = 1; bug_clockwise = 1; } else { if (bug_clockwise) bug_down  = 1; else bug_left  = 1; bug_clockwise = 0; }}}
        PrintCXY(bug_x, bug_y, bug, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0);
        Bdisp_PutDisp_DD();
        if (bug_corner_wait)
        {
            bug_corner_wait = 0;
            if (sleepy_bug()) break;
        }
        OS_InnerWait_ms(10);
    }
    LoadVRAM_1();
    main_timer = RTC_GetTicks();
}

void set_calc_off(void)
{
    send_serial_data("set_calc_off=", 1);
    OS_InnerWait_ms(1000);
    close_serial_port();
    PowerOff(1);
    open_serial_port();
    OS_InnerWait_ms(1000);
    send_serial_data("set_calc_on=", 1);
}

void shut_down_radio(void)
{
    int i;
    char string[10];
    string[0] = '\0';
    shutdown = 1;
    clear_scroll_text();
    PrintCXY(TEXT_ALL_POS_X, TEXT_2_POS_Y, blank_line_long, 0x40, -1, foreground_color[color_index], foreground_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, blank_line_long, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, blank_line_short, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_2_POS_X, TEXT_4_POS_Y, blank_line_shorter, 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_3_POS_Y, "Shutting down ...", 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    PrintCXY(TEXT_ALL_POS_X, TEXT_4_POS_Y, "the radio!", 0x40, -1, foreground_color[color_index], background_color[color_index], 1, 0 );
    send_serial_data("shut_down_radio=", 1);
    for (i = 15; i >= 0; i--)
    {
        itoa(i, (unsigned char*)string);
        PrintCXY(245, TEXT_4_POS_Y, "  ", 0x40, -1, background_color[color_index], background_color[color_index], 1, 0 );
        PrintCXY(245, TEXT_4_POS_Y, string, 0x40, -1, others_color[color_index], background_color[color_index], 1, 0 );
        Bdisp_PutDisp_DD();
        OS_InnerWait_ms(1000);
    }
}

void change_color_up(void)
{
    color_index++;
    if (color_index >= NUMBER_OF_COLORS) color_index = 0;
    display_init();
    main_timer = RTC_GetTicks();
}

void change_color_down(void)
{
    color_index--;
    if (color_index < 0) color_index = NUMBER_OF_COLORS - 1;
    display_init();
    main_timer = RTC_GetTicks();
}

int main(void)
{
    int key = 0;
    radio_init();
    while (key != KEY_MENU && key != KEY_EXIT && !shutdown)
    {
        if (RTC_Elapsed_ms(main_timer, 400))
        {
            key = PRGM_GetKey();
            switch (key)
            {
                case KEY_F1:        if (!mute) set_mode(1);                 break;
                case KEY_F2:        if (!mute) set_mode(2);                 break;
                case KEY_F3:        if (!mute) set_mode(3);                 break;
                case KEY_F4:        if (!mute) set_mode(4);                 break;
                case KEY_F5:        if (!mute) set_mode(8);                 break;
                case KEY_F6:        if (!mute) set_mode(9);                 break;
                case KEY_UP:        if (!mute) change_mode_up();            break;
                case KEY_RIGHT:     if (!mute) change_mode_up();            break;
                case KEY_DOWN:      if (!mute) change_mode_down();          break;
                case KEY_LEFT:      if (!mute) change_mode_down();          break;
                case KEY_0:         if (!mute) set_preset(0);               break;
                case KEY_1:         if (!mute) set_preset(1);               break;
                case KEY_2:         if (!mute) set_preset(2);               break;
                case KEY_3:         if (!mute) set_preset(3);               break;
                case KEY_4:         if (!mute) set_preset(4);               break;
                case KEY_5:         if (!mute) set_preset(5);               break;
                case KEY_6:         if (!mute) set_preset(6);               break;
                case KEY_7:         if (!mute) set_preset(7);               break;
                case KEY_8:         if (!mute) set_preset(8);               break;
                case KEY_9:         if (!mute) set_preset(9);               break;
                case KEY_PLUS:      if (!mute) set_volume_up();             break;
                case KEY_MINUS:     if (!mute) set_volume_down();           break;
                case KEY_ABC:       if (!mute) set_equalizer();             break;
                case KEY_RETURN:    if (!mute) play_random_radio();         break;
                case KEY_EXP:       if (!mute) play_special_radio();        break;
                case KEY_STORE:     if (!mute) recall_previous_preset();    break;
                case KEY_DP:        if (!mute) radio_play_stop();           break;
                case KEY_RPAR:      if (!mute) play_next();                 break;
                case KEY_LPAR:      if (!mute) play_previous();             break;
                case KEY_SQUARE:    if (!mute) test_speaker();              break;
                case KEY_COMMA:     if (!mute) test_key();                  break;
                case KEY_SHIFT:     if (mute)  update_database();           break;
                case KEY_ALPHA:     if (mute)  shut_down_radio();           break;
                case KEY_DEL:                  set_mute();                  break;
                case KEY_PMINUS:               show_help();                 break;
                case KEY_ACON:                 set_calc_off();              break;
                case KEY_SIN:                  change_color_down();         break;
                case KEY_COS:                  change_color_up();           break;
                case KEY_POW:                  show_song_station_http();    break;
                case KEY_TAN:                  show_cpu_and_temp();         break;
                case KEY_LOG:                  show_up_since();             break;
            }
        }
        do_smiley();
        receive_serial_data();
        scroll_text_on_display();
        OS_InnerWait_ms(100);
    }
    close_serial_port();
    save_settings();
    Bdisp_AllClr_VRAM();
    return 0;
}
