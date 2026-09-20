#include "hb100.h"
#include "gw1ns4c_timer.h"
#include "gw1ns4c_gpio.h"

#define SYS_CLK     27000000
#define HB100_PIN   (1 << 0)
#define LED_PIN     (1 << 1)

#define TIMER_MAX   0xFFFFFFFF
#define AVERAGE     4

/* ================= INIT ================= */

static void timer_init(void)
{
    TIMER_InitTypeDef t;

    t.Reload = TIMER_MAX;
    t.TIMER_Int = DISABLE;
    t.TIMER_Exti = TIMER_DISABLE;

    TIMER_Init(TIMER0, &t);
    TIMER_StartTimer(TIMER0);
}

static void gpio_init(void)
{
    GPIO_InitTypeDef g;

    g.GPIO_Pin = HB100_PIN;
    g.GPIO_Mode = GPIO_Mode_IN;
    g.GPIO_Int = GPIO_Int_Disable;
    GPIO_Init(GPIO0, &g);

    g.GPIO_Pin = LED_PIN;
    g.GPIO_Mode = GPIO_Mode_OUT;
    g.GPIO_Int = GPIO_Int_Disable;
    GPIO_Init(GPIO0, &g);
}

void HB100_Init(void)
{
    timer_init();
    gpio_init();
}

/* ================= EDGE ================= */

static void wait_rising(void)
{
    while (!(GPIO_ReadBits(GPIO0) & HB100_PIN));
}

static void wait_falling(void)
{
    while (GPIO_ReadBits(GPIO0) & HB100_PIN);
}

/* ================= PERIOD ================= */

static uint32_t measure_period(void)
{
    uint32_t t1, t2;

    wait_rising();
    t1 = TIMER_GetValue(TIMER0);

    wait_falling();
    wait_rising();

    t2 = TIMER_GetValue(TIMER0);

    if (t1 >= t2)
        return (t1 - t2);
    else
        return (t1 + (TIMER_MAX - t2));
}

/* ================= FREQUENCY ================= */

uint32_t HB100_GetFrequency(void)
{
    uint32_t samples[AVERAGE];
    uint32_t sum = 0;

    for (int i = 0; i < AVERAGE; i++)
    {
        samples[i] = measure_period();
        if (samples[i] == 0) return 0;
    }

    for (int i = 1; i < AVERAGE; i++)
    {
        if ((samples[i] > samples[0] * 2) ||
            (samples[i] < samples[0] / 2))
            return 0;
    }

    for (int i = 0; i < AVERAGE; i++)
        sum += samples[i];

    uint32_t avg = sum / AVERAGE;

    return (SYS_CLK*100 ) / avg;
}

/* ================= VELOCITY ================= */

uint32_t HB100_GetVelocity(void)
{
    uint32_t f = HB100_GetFrequency();
    if (!f) return 0;

    return (f * 100) / 1949;
}

/* ================= PACK ================= */

uint32_t HB100_GetPackedBCD(void)
{
    uint32_t v = HB100_GetVelocity();
    if (v > 9999) v = 9999;

    uint32_t x = (v / 1000) % 10;
    uint32_t y = (v / 100) % 10;
    uint32_t z = (v / 10) % 10;
    uint32_t t = v % 10;

    return (x << 26) | (y << 18) | (z << 10) | (t << 2);
}
void delay_ticks(unsigned int ticks)
{
    unsigned int start = TIMER_GetValue(TIMER0);
    unsigned int now;

    while (1)
    {
        now = TIMER_GetValue(TIMER0);

        if (start >= now)
        {
            if ((start - now) >= ticks) break;
        }
        else
        {
            if ((start + (TIMER_MAX - now)) >= ticks) break;
        }
    }
}
