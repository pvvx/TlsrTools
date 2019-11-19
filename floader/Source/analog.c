#include "common.h"

static inline void analog_wait(){
	while(reg_ana_ctrl & FLD_ANA_BUSY){}
}

_attribute_ram_code_ void analog_read_blk(u8 addr, u8 *v, int len){
#if USE_IRQ_SAVE
	u8 r = irq_disable();
#endif	
	reg_ana_ctrl = 0;		// issue clock
	reg_ana_addr = addr;
	while(len--){
		reg_ana_ctrl = FLD_ANA_CYC | FLD_ANA_START;
		analog_wait();
		*v++ = reg_ana_data;
	}
	reg_ana_ctrl = 0; 		// finish
#if USE_IRQ_SAVE
	irq_restore(r);
#endif	
}

_attribute_ram_code_ void analog_write_blk(u8 addr, u8 *v, int len){
#if USE_IRQ_SAVE
	u8 r = irq_disable();
#endif	
	reg_ana_addr = addr;
	while(len--){
		reg_ana_data = *v++;
		reg_ana_ctrl = FLD_ANA_CYC | FLD_ANA_START | FLD_ANA_RW; 	// multi write
		analog_wait();
	}
	reg_ana_ctrl = 0; 		// finish
#if USE_IRQ_SAVE
	irq_restore(r);
#endif	
}

_attribute_ram_code_ void analog_write(u8 addr, u8 v){
#if USE_IRQ_SAVE
	u8 r = irq_disable();
#endif	
	reg_ana_addr = addr;
	reg_ana_data = v;
	reg_ana_ctrl = (FLD_ANA_START | FLD_ANA_RW);
//	 Can't use one line setting "reg_ana_ctrl32 = ((FLD_ANA_START | FLD_ANA_RW) << 16) | (v << 8) | addr;"
//   This will fail because of time sequence and more over size is bigger
	analog_wait();
	reg_ana_ctrl = 0; 		// finish
#if USE_IRQ_SAVE
	irq_restore(r);
#endif	
}
