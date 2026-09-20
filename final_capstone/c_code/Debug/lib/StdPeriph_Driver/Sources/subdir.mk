################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../lib/StdPeriph_Driver/Sources/gpio.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_gpio.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_i2c.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_misc.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_rtc.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_spi.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_syscon.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_timer.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_uart.c \
../lib/StdPeriph_Driver/Sources/gw1ns4c_wdog.c \
../lib/StdPeriph_Driver/Sources/pwm_controller.c \
../lib/StdPeriph_Driver/Sources/uart.c 

OBJS += \
./lib/StdPeriph_Driver/Sources/gpio.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_gpio.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_i2c.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_misc.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_rtc.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_spi.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_syscon.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_timer.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_uart.o \
./lib/StdPeriph_Driver/Sources/gw1ns4c_wdog.o \
./lib/StdPeriph_Driver/Sources/pwm_controller.o \
./lib/StdPeriph_Driver/Sources/uart.o 

C_DEPS += \
./lib/StdPeriph_Driver/Sources/gpio.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_gpio.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_i2c.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_misc.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_rtc.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_spi.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_syscon.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_timer.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_uart.d \
./lib/StdPeriph_Driver/Sources/gw1ns4c_wdog.d \
./lib/StdPeriph_Driver/Sources/pwm_controller.d \
./lib/StdPeriph_Driver/Sources/uart.d 


# Each subdirectory must supply rules for building sources it contributes
lib/StdPeriph_Driver/Sources/%.o: ../lib/StdPeriph_Driver/Sources/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\CoreSupport\gmd" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\DeviceSupport\system" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\StdPeriph_Driver\Includes" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\mycode" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


