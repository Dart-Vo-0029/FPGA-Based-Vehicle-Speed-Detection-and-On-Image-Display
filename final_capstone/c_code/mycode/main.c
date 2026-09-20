#include "hb100.h"
#include "gps_neo_6m.h"
#include "apb.h"
#include "gw1ns4c.h"
#define APB_VEL 0x40002400
#define APB_GPS 0x40002500

void delay_ticks();
int main(void)
{
    SystemInit();

    HB100_Init();
    GPS_Init();
    uint32_t hb100_counter = 0;
    APB_SendString(APB_GPS, GPS_GetFrame(), 36);
    while(1)
    {
        //===== HB100 =====
        uint32_t vel_data = HB100_GetPackedBCD();
        if(vel_data)
            APB_Write(APB_VEL, vel_data);
        delay_ticks(27000000/27000);
        // ===== GPS =====
        // ===== FAST TASK (GPS) =====
        GPS_Process();

        if(GPS_IsUpdated())
        {
            APB_SendString(APB_GPS, GPS_GetFrame(), 36);
            GPS_ClearUpdated();
        }

        // ===== SLOW TASK (HB100) =====
        if(hb100_counter++ > 100)
        {
            hb100_counter = 0;

            uint32_t vel = HB100_GetPackedBCD();
            if(vel)
                APB_Write(APB_VEL, vel);
        }
    }
}
