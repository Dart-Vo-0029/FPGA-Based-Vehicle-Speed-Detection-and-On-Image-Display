#include "apb.h"

void APB_Write(uint32_t addr, uint32_t data)
{
    *(volatile uint32_t*)addr = data;
}

void APB_SendString(uint32_t addr, const char* str, int len)
{
    for(int i = 0; i < len; i += 4)
    {
        uint32_t word =
            (uint8_t)str[i] |
            ((uint8_t)str[i+1] << 8) |
            ((uint8_t)str[i+2] << 16) |
            ((uint8_t)str[i+3] << 24);

        APB_Write(addr, word);
    }
}