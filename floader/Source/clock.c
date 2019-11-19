
#include "common.h"
#include "clock.h"


_attribute_ram_code_ void clock_init(){

	reg_rst_clk0 = 0xff000000;

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
	//reg_clk_en = 0xff | CLK_EN_TYPE;
/*
	reg_tmr_ctrl = MASK_VAL(FLD_TMR0_EN, 1
		, FLD_TMR_WD_CAPT, (MODULE_WATCHDOG_ENABLE ? (WATCHDOG_INIT_TIMEOUT * CLOCK_SYS_CLOCK_1MS >> WATCHDOG_TIMEOUT_COEFF):0)
		, FLD_TMR_WD_EN, (MODULE_WATCHDOG_ENABLE?1:0));
*/
}

/**
 * @brief     This function performs to gets system timer0 address.
 * @param[in] none.
 * @return    timer0 address.
 */

static inline unsigned long clock_time(void)
{
	return reg_system_tick;
}

/**
 * @brief     This function performs to calculation exceed us of the timer.
 * @param[in] ref - Variable of reference timer address.
 * @param[in] span_us - Variable of span us.
 * @return    the exceed.
 */
static inline unsigned int clock_time_exceed(unsigned int ref, unsigned int us)
{
	return ((unsigned int)(clock_time() - ref) > us * 16);
}

_attribute_ram_code_ void sleep_us (u32 us)
{
	u32 t = clock_time();
	while(!clock_time_exceed(t, us)){
	}
}



