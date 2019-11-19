
// use static inline, because, spi flash code must reside in memory..
// these code may be embedd in flash code

_attribute_ram_code_ static inline void mspi_wait(void){
	while(reg_master_spi_ctrl & FLD_MASTER_SPI_BUSY)
		;
}

_attribute_ram_code_ static inline void mspi_high(void){
	reg_master_spi_ctrl = FLD_MASTER_SPI_CS;
}

_attribute_ram_code_ static inline void mspi_low(void){
	reg_master_spi_ctrl = 0;
}

_attribute_ram_code_ static inline u8 mspi_get(void){
	return reg_master_spi_data;
}

_attribute_ram_code_ static inline void mspi_write(u8 c){
	reg_master_spi_data = c;
}

_attribute_ram_code_ static inline void mspi_ctrl_write(u8 c){
	reg_master_spi_ctrl = c;
}

_attribute_ram_code_ static inline u8 mspi_read(void){
	mspi_write(0);		// dummy, issue clock 
	mspi_wait();
	return mspi_get();
}

