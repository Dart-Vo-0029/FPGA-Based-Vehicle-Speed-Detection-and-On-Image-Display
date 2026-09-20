################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../mycode/apb.c \
../mycode/gps_neo_6m.c \
../mycode/gw1ns4c_it.c \
../mycode/hb100.c \
../mycode/main.c \
../mycode/retarget.c 

OBJS += \
./mycode/apb.o \
./mycode/gps_neo_6m.o \
./mycode/gw1ns4c_it.o \
./mycode/hb100.o \
./mycode/main.o \
./mycode/retarget.o 

C_DEPS += \
./mycode/apb.d \
./mycode/gps_neo_6m.d \
./mycode/gw1ns4c_it.d \
./mycode/hb100.d \
./mycode/main.d \
./mycode/retarget.d 


# Each subdirectory must supply rules for building sources it contributes
mycode/%.o: ../mycode/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\CoreSupport\gmd" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\DeviceSupport\system" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\StdPeriph_Driver\Includes" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\mycode" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


