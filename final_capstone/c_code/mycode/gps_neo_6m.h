#ifndef GPS_NEO_6M_H
#define GPS_NEO_6M_H

void GPS_Init(void);
void GPS_Process(void);

const char* GPS_GetFrame(void);

int GPS_IsUpdated(void);
void GPS_ClearUpdated(void);

#endif
