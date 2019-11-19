#pragma once

/* Enable C linkage for C++ Compilers: */
#if defined(__cplusplus)
extern "C" {
#endif

#define	MCU_CORE_8266 		1
#define	MCU_CORE_8366 		2
#define MCU_CORE_8368		3
#define	MCU_CORE_8267 		4
#define MCU_CORE_8263 		5
#define MCU_CORE_8261 		6
#define MCU_CORE_8269 		7

#define MCU_CORE_TYPE MCU_CORE_8269
#define CHIP_TYPE	 MCU_CORE_8269

/////////////////// Clock  /////////////////////////////////
#define	CLOCK_TYPE_PLL	0
#define	CLOCK_TYPE_OSC	1
#define	CLOCK_TYPE_PAD	2
#define	CLOCK_TYPE_ADC	3

#define CLOCK_SYS_TYPE  		CLOCK_TYPE_OSC // one of the following:  CLOCK_TYPE_PLL, CLOCK_TYPE_OSC, CLOCK_TYPE_PAD, CLOCK_TYPE_ADC
#define CLOCK_SYS_CLOCK_HZ  	32000000

/////////////////// watchdog  //////////////////////////////

#define MODULE_WATCHDOG_ENABLE		0
#define WATCHDOG_INIT_TIMEOUT		100  //ms


/////////////////// IRQ  /////////////////////////////////
#define USE_IRQ_SAVE 			0

/* Disable C linkage for C++ Compilers: */
#if defined(__cplusplus)
}
#endif
