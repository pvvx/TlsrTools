/*
 * Poject TlsrTool FLOADER
 * pvvx 09/2019
 */
#include "common.h"
//#include "irq_i.h"
#include "analog.h"
#include "spi_i.h"
#include "flash.h"
#include "clock.h"

// Some place holder for the firmware version etc.

typedef struct {
	volatile u32 faddr;
	volatile u32 pbuf;
	volatile u16 count;
	volatile u16 cmd;
	volatile u16 iack;
	volatile u16 oack;
} sext;

sext ext;

u8	buff[8192+4096];


_attribute_ram_code_ void flash_write_sector(u32 addr, u32 len, u8 *buf) {
	u32 sz = 256;
	while(len) {
		if (len < sz) sz = len;
		flash_write_page(addr, sz, buf);
		addr += sz;
		buf += sz;
		len -= sz;
	}
}

_attribute_ram_code_ int main (void) {

	reg_irq_en = 0; // irq_disable (); //#include "irq_i.h"
	// Open clk for MCU running
#if 1
	REG_ADDR8(0x60) = 0x00;
	REG_ADDR8(0x61) = 0x00;
	REG_ADDR8(0x62) = 0x00;
	REG_ADDR8(0x63) = 0xff;
	REG_ADDR8(0x64) = 0xff;
	REG_ADDR8(0x65) = 0xff;
	REG_ADDR32(0x60) = 0x00000000 // reg_rst_clk0
	| FLD_CLK_SPI_EN
//	| FLD_CLK_I2C_EN
//	| FLD_CLK_USB_EN
//	| FLD_CLK_USB_PHY_EN
	| FLD_CLK_MCU_EN
	| FLD_CLK_MAC_EN
//	| FLD_CLK_ADC_EN	// ADC interface
	| FLD_CLK_ZB_EN
		;

	REG_ADDR32(0x64) = 0
	// reg_clk_sel:
    | (6 << 16) 	  	// reg_clk_sel CLOCK_TYPE_PLL : 192MHz/32MHz = 6
//	| (1 << (7+16))	  	// reg_clk_sel CLOCK_TYPE_OSC
    | (0 << (5+16)) 	// 0:32m clock from rc
//    | (1 << (5+16)) 	// 1:hs divider clk
    // reg_clk_en:
	| FLD_CLK_GPIO_EN
//	| FLD_CLK_ALGM_EN
	| FLD_CLK_DMA_EN
//	| FLD_CLK_UART_EN
//	| FLD_CLK_PWM_EN
//	| FLD_CLK_AES_EN
//	| FLD_CLK_32K_TIMER_EN
	| FLD_CLK_SWIRE_EN
//	| FLD_CLK_32K_QDEC_EN
//	| FLD_CLK_AUD_EN
//	| FLD_CLK_DIFIO_EN
//	| FLD_CLK_KEYSCAN_EN
	| FLD_CLK_MCIC_EN
//	| FLD_CLK_QDEC_EN
	;
	reg_fhs_sel =
		FHS_SEL_192M_PLL;
//		FHS_SEL_32M_OSC;
#else
#if(CLOCK_SYS_TYPE == CLOCK_TYPE_PLL)
	reg_clk_sel = MASK_VAL(FLD_CLK_SEL_DIV, (CLOCK_PLL_CLOCK / CLOCK_SYS_CLOCK_1S), FLD_CLK_SEL_SRC, CLOCK_SEL_HS_DIV);
#elif(CLOCK_SYS_TYPE == CLOCK_TYPE_PAD)

	//STATIC_ASSERT(CLK_FHS_MZ == 32);
	#if(CLOCK_SYS_CLOCK_HZ == 12000000)
		reg_clk_sel = 0x40;
	#else
		#error clock not set properly
	#endif

#elif(CLOCK_SYS_TYPE == CLOCK_TYPE_OSC)
	#if(MCU_CORE_TYPE == MCU_CORE_8267 || MCU_CORE_TYPE == MCU_CORE_8261 || MCU_CORE_TYPE == MCU_CORE_8269)
		#if(CLOCK_SYS_CLOCK_HZ == 32000000)
			reg_fhs_sel = 0;
			reg_clk_sel = 0x80;	// bit[7] must be "1"
		#elif(CLOCK_SYS_CLOCK_HZ == 16000000)
			reg_fhs_sel = 0;
			reg_clk_sel = 0xa2;
		#elif(CLOCK_SYS_CLOCK_HZ == 8000000)
			reg_fhs_sel = 0;
			reg_clk_sel = 0xa4;
		#else
			#error clock not set properly
		#endif
	#else
		#if(CLOCK_SYS_CLOCK_HZ == 32000000)
			reg_fhs_sel = 0;
			reg_clk_sel = 0;	// must be zero
		#elif(CLOCK_SYS_CLOCK_HZ == 16000000)
			reg_fhs_sel = FHS_SEL_32M_OSC;
			reg_clk_sel = MASK_VAL(FLD_CLK_SEL_DIV, 2, FLD_CLK_SEL_SRC, CLOCK_SEL_HS_DIV);
		#elif(CLOCK_SYS_CLOCK_HZ == 8000000)
			reg_fhs_sel = FHS_SEL_32M_OSC;
			reg_clk_sel = MASK_VAL(FLD_CLK_SEL_DIV, 4, FLD_CLK_SEL_SRC, CLOCK_SEL_HS_DIV);
		#else
			#error clock not set properly
		#endif
	#endif
#else
	#error clock not set properly
#endif
#if 0
	REG_ADDR8(0x64) = 0xff;
#else
	reg_clk_en = 0
			| FLD_CLK_GPIO_EN
		//	| FLD_CLK_ALGM_EN
			| FLD_CLK_DMA_EN
		//	| FLD_CLK_UART_EN
		//	| FLD_CLK_PWM_EN
		//	| FLD_CLK_AES_EN
		//	| FLD_CLK_32K_TIMER_EN
			| FLD_CLK_SWIRE_EN
		//	| FLD_CLK_32K_QDEC_EN
		//	| FLD_CLK_AUD_EN
		//	| FLD_CLK_DIFIO_EN
		//	| FLD_CLK_KEYSCAN_EN
			| FLD_CLK_MCIC_EN
		//	| FLD_CLK_QDEC_EN
			;
#endif
#if 0
	reg_tmr_ctrl = MASK_VAL(FLD_TMR0_EN, 1
		, FLD_TMR_WD_CAPT, (MODULE_WATCHDOG_ENABLE ? (WATCHDOG_INIT_TIMEOUT * CLOCK_SYS_CLOCK_1MS >> WATCHDOG_TIMEOUT_COEFF):0)
		, FLD_TMR_WD_EN, (MODULE_WATCHDOG_ENABLE?1:0));
#endif
#endif
	// enable system tick ( clock_time() )
	reg_system_tick_ctrl = FLD_SYSTEM_TICK_START; //	REG_ADDR8(0x74f) = 0x01;

	/////////////////////////// app floader /////////////////////////////
	ext.faddr = 0;
	ext.pbuf = (u32) buff;
	ext.count = sizeof(buff);
	ext.cmd = FLASH_GET_JEDEC_ID;
	ext.iack = 3; // Version, in BCD 0x1234 = 1.2.3.4
	ext.oack = 0;
	u16 ack = 0xffff;
	while(1) {
#if MODULE_WATCHDOG_ENABLE
		WATCHDOG_CLEAR;  //in case of watchdog timeout
#endif
		while(ack == ext.iack);
		ack = ext.iack;
		switch(ext.cmd) {
			case FLASH_READ_CMD:
				flash_read_page(ext.faddr, ext.count, (u8 *)ext.pbuf);
				break;
			case FLASH_WRITE_CMD:
				flash_write_sector(ext.faddr, ext.count, (u8 *)ext.pbuf);
				break;
			case FLASH_SECT_ERASE_CMD:
				flash_erase_sector(ext.faddr);
				break;
			case FLASH_GET_JEDEC_ID:
				ext.faddr = flash_get_jedec_id();
				break;
/*
			case 0xF3:
				analog_write_blk((u8)ext.faddr, (u8 *)ext.pbuf, ext.count);
				break;
			case 0xF4:
				analog_read_blk((u8)ext.faddr, (u8 *)ext.pbuf, ext.count);
				break;
*/
		}
		ext.oack++;
	}

	REG_ADDR8(0x6f) = 0x20;   //mcu reboot
	while (1);
}


