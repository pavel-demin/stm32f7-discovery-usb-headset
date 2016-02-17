TARGET = stm32f7-discovery-usb-headset

OBJECTS = \
  wm8994.o \
  stm32746g_discovery.o \
  stm32746g_discovery_audio.o \
  stm32f7xx_hal.o \
  stm32f7xx_hal_cortex.o \
  stm32f7xx_hal_dma.o \
  stm32f7xx_hal_flash.o \
  stm32f7xx_hal_flash_ex.o \
  stm32f7xx_hal_gpio.o \
  stm32f7xx_hal_i2c.o \
  stm32f7xx_hal_i2s.o \
  stm32f7xx_hal_pcd.o \
  stm32f7xx_hal_pcd_ex.o \
  stm32f7xx_hal_pwr.o \
  stm32f7xx_hal_pwr_ex.o \
  stm32f7xx_hal_rcc.o \
  stm32f7xx_hal_rcc_ex.o \
  stm32f7xx_hal_sai.o \
  stm32f7xx_hal_sai_ex.o \
  stm32f7xx_hal_tim.o \
  stm32f7xx_hal_tim_ex.o \
  stm32f7xx_hal_uart.o \
  stm32f7xx_hal_usart.o \
  stm32f7xx_ll_usb.o \
  usbd_audio.o \
  usbd_core.o \
  usbd_ctlreq.o \
  usbd_ioreq.o \
  main.o \
  stm32f7xx_it.o \
  system_stm32f7xx.o \
  usbd_audio_if.o \
  usbd_conf.o \
  usbd_desc.o \
  startup_stm32f746xx.o \
  syscalls.o

SOURCES = \
  Drivers/BSP/Components/wm8994 \
  Drivers/BSP/STM32746G-Discovery \
  Drivers/CMSIS/Device/ST/STM32F7xx/Source \
  Drivers/STM32F7xx_HAL_Driver/Src \
  Middlewares/ST/STM32_USB_Device_Library/Class/AUDIO/Src \
  Middlewares/ST/STM32_USB_Device_Library/Core/Src \
  Src

vpath %.c $(SOURCES)

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

CFLAGS = \
  -Wall -O2 -mthumb -mcpu=cortex-m7 -mfpu=fpv5-sp-d16 -mfloat-abi=hard \
  -fdata-sections -ffunction-sections -ffast-math \
  -DUSE_HAL_DRIVER -DUSE_USB_FS -DUSE_IOEXPANDER \
  -DSTM32F746xx -DUSE_STM32746G_DISCO \
  -IDrivers/BSP/STM32746G-Discovery \
  -IDrivers/CMSIS/Device/ST/STM32F7xx/Include \
  -IDrivers/CMSIS/Include \
  -IDrivers/STM32F7xx_HAL_Driver/Inc \
  -IMiddlewares/ST/STM32_USB_Device_Library/Class/AUDIO/Inc \
  -IMiddlewares/ST/STM32_USB_Device_Library/Core/Inc \
  -IInc \

LDFLAGS = \
  -mthumb -mcpu=cortex-m7 -mfpu=fpv5-sp-d16 -mfloat-abi=hard \
  -fdata-sections -ffunction-sections -ffast-math \
  -specs=nano.specs -Wl,-T,STM32F746NGHx_FLASH.ld -Wl,--gc-sections \
  -lc -lm -lnosys

all: $(TARGET).bin

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary -S $< $@

clean:
	rm -rf $(OBJECTS) $(TARGET).elf $(TARGET).bin
