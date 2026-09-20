#ifndef APB_H
#define APB_H

#include <stdint.h>

void APB_Write(uint32_t addr, uint32_t data);
void APB_SendString(uint32_t addr, const char* str, int len);

#endif