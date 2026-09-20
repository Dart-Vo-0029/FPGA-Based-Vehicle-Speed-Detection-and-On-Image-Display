#include "gps_neo_6m.h"
#include "uart.h"
#include <string.h>
#include <stdio.h>

#define UART_GPS 0
#define NMEA_BUFFER_SIZE 128
#define FRAME_SIZE 36

/* ===== GLOBAL SAFE BUFFERS ===== */
static char nmea_buf[NMEA_BUFFER_SIZE];
static char parse_buf[NMEA_BUFFER_SIZE];
static char lat[16];
static char lon[16];

static uint8_t idx = 0;
static int gps_updated = 0;

static char gps_frame[FRAME_SIZE] =
"Long: 000.000000_E Lat: 00.000000_N ";

/* ================= INIT ================= */

void GPS_Init(void)
{
    uart_init(UART_GPS, 2812);
}

/* ================= HELPERS ================= */

static char* getField(char* str, int index)
{
    int count = 0;

    while(*str)
    {
        if(*str == ',')
        {
            count++;
            if(count == index)
                return str + 1;
        }
        str++;
    }
    return NULL;
}

/* ================= CONVERT ================= */

static void NMEA_To_String(char *in, char *out, int isLon)
{
    int deg, min, frac;

    if(isLon)
    {
        deg = (in[0]-'0')*100 + (in[1]-'0')*10 + (in[2]-'0');
        min = (in[3]-'0')*10 + (in[4]-'0');
        frac = (in[6]-'0')*1000 +
               (in[7]-'0')*100 +
               (in[8]-'0')*10 +
               (in[9]-'0');

        sprintf(out, "%03d.%06d",
                deg,
                (min * 1000000 + frac * 100) / 60);
    }
    else
    {
        deg = (in[0]-'0')*10 + (in[1]-'0');
        min = (in[2]-'0')*10 + (in[3]-'0');
        frac = (in[5]-'0')*1000 +
               (in[6]-'0')*100 +
               (in[7]-'0')*10 +
               (in[8]-'0');

        sprintf(out, "%02d.%06d",
                deg,
                (min * 1000000 + frac * 100) / 60);
    }
}

/* ================= PARSE ================= */

static void parse(void)
{
    if(strncmp(nmea_buf, "$GPRMC", 6) != 0)
        return;

    strncpy(parse_buf, nmea_buf, NMEA_BUFFER_SIZE-1);
    parse_buf[NMEA_BUFFER_SIZE-1] = '\0';

    char *status  = getField(parse_buf, 2);
    char *lat_raw = getField(parse_buf, 3);
    char *lat_dir = getField(parse_buf, 4);
    char *lon_raw = getField(parse_buf, 5);
    char *lon_dir = getField(parse_buf, 6);

    if(!status || status[0] != 'A')
    {
        memcpy(gps_frame,
        "Long: 000.000000_E Lat: 00.000000_N ", FRAME_SIZE);
        return;
    }

    NMEA_To_String(lat_raw, lat, 0);
    NMEA_To_String(lon_raw, lon, 1);

    memcpy(gps_frame, "Long: ", 6);
    memcpy(&gps_frame[6], lon, 10);
    gps_frame[16] = '_';
    gps_frame[17] = lon_dir ? lon_dir[0] : 'E';

    memcpy(&gps_frame[18], " Lat: ", 6);
    memcpy(&gps_frame[24], lat, 9);
    gps_frame[33] = '_';
    gps_frame[34] = lat_dir ? lat_dir[0] : 'N';

    gps_frame[35] = ' ';
}

/* ================= PROCESS (NON-BLOCKING) ================= */

void GPS_Process(void)
{
    if(!uart_available(UART_GPS))
        return;

    char c = uart_getchar(UART_GPS);

    if(c == '$') idx = 0;

    if(idx >= NMEA_BUFFER_SIZE - 1)
    {
        idx = 0;
    }
    else
    {
        nmea_buf[idx++] = c;
    }

    if(c == '\n')
    {
        nmea_buf[idx] = '\0';
        parse();
        idx = 0;

        gps_updated = 1;
    }
}

/* ================= INTERFACE ================= */

const char* GPS_GetFrame(void)
{
    return gps_frame;
}

int GPS_IsUpdated(void)
{
    return gps_updated;
}

void GPS_ClearUpdated(void)
{
    gps_updated = 0;
}
