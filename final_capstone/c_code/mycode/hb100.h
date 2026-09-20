#ifndef HB100_H
#define HB100_H

#include <stdint.h>

void HB100_Init(void);
uint32_t HB100_GetFrequency(void);
uint32_t HB100_GetVelocity(void);
uint32_t HB100_GetPackedBCD(void);

#endif