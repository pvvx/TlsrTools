#ifndef _SPI_DMA_H_
#define _SPI_DMA_H_

#define USE_SPI

/*
speed:
	0: 36 MHz (72 MHz / 2)
	1: 18 MHz (72 MHz / 4)
	2: 9 MHz (72 MHz / 8)
	3: 4.5 MHz (72 MHz / 16)
	4: 2.25 MHz (72 MHz / 32)
	5: 1.125 MHz (72 MHz / 64)
	6: 562 kHz (72 MHz / 128)
	7: 281 kHz (72 MHz / 256
*/
void SPIInit(uint8_t speed);
void SPI_tx_rx(uint8_t *data_tx, uint8_t *data_rx, uint16_t len);
extern volatile uint8_t spi_ready;

#endif // _SPI_DMA_H_
