################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../lib/CMSIS/CoreSupport/gmd/core_cm3.c 

OBJS += \
./lib/CMSIS/CoreSupport/gmd/core_cm3.o 

C_DEPS += \
./lib/CMSIS/CoreSupport/gmd/core_cm3.d 


# Each subdirectory must supply rules for building sources it contributes
lib/CMSIS/CoreSupport/gmd/%.o: ../lib/CMSIS/CoreSupport/gmd/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\CoreSupport\gmd" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\CMSIS\DeviceSupport\system" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\lib\StdPeriph_Driver\Includes" -I"E:\Hais_files\HK_252\DA_TN\lab\final_capstone\c_code\mycode" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


