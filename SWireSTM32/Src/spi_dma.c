#include "stm32f103x6.h"
/*
 * http://dimoon.ru/obuchalka/stm32f1/programmirovanie-stm32-chast-10-spi-dma.html
 */
/*
speed:
	0: 36 MHz (72 MHz / 2)
	1: 18 MHz (72 MHz / 4)
	2: 9 MHz (72 MHz / 8)
	3: 4.5 MHz (72 MHz / 16)
	4: 2.25 MHz (72 MHz / 32)
	5: 1.125 MHz (72 MHz / 64)
	6: 562 kHz (72 MHz / 128)
	7: 281 kHz (72 MHz / 256)
*/

void SPIInit(uint8_t speed)
{
  RCC->APB2ENR |= RCC_APB2ENR_SPI1EN; //Включаем тактирование SPI1
//  RCC->APB2ENR |= RCC_APB2ENR_IOPAEN; //включаем тактирование порта GPIOA
  RCC->AHBENR |= RCC_AHBENR_DMA1EN; //Включаем тактирование DMA1
  
  //Настройка GPIO
  
  //	PA7 - MOSI
  //	PA6 - MISO
  //	PA5 - SCK
  //Для начала сбрасываем все конфигурационные биты в нули

  GPIOA->CRL &= ~(GPIO_CRL_CNF5_Msk | GPIO_CRL_MODE5_Msk |
                GPIO_CRL_CNF6_Msk | GPIO_CRL_MODE6_Msk |
                GPIO_CRL_CNF7_Msk | GPIO_CRL_MODE7_Msk);
  
  //Настраиваем
  //SCK: MODE5 = 0x03 (11b); CNF5 = 0x02 (10b)
  GPIOA->CRL |= (0x02U<<GPIO_CRL_CNF5_Pos) | (0x03U<<GPIO_CRL_MODE5_Pos);
  
  //MISO: MODE6 = 0x00 (00b); CNF6 = 0x01 (01b)
  GPIOA->CRL |= (0x01U<<GPIO_CRL_CNF6_Pos) | (0x00U<<GPIO_CRL_MODE6_Pos);
  
  //MOSI: MODE7 = 0x03 (11b); CNF7 = 0x02 (10b)
  GPIOA->CRL |= (0x02U<<GPIO_CRL_CNF7_Pos) | (0x03U<<GPIO_CRL_MODE7_Pos);
  
  
  //Настройка SPI
  SPI1->CR1 = 0<<SPI_CR1_DFF_Pos  //Размер кадра 8 бит
    | 0<<SPI_CR1_LSBFIRST_Pos     //MSB first
    | 1<<SPI_CR1_SSM_Pos          //Программное управление SS
    | 1<<SPI_CR1_SSI_Pos          //SS в высоком состоянии
    | speed<<SPI_CR1_BR_Pos       //Скорость передачи: F_PCLK/speed 72/speed = 9 MHz
    | 1<<SPI_CR1_MSTR_Pos         //Режим Master (ведущий)
    | 0<<SPI_CR1_CPOL_Pos | 0<<SPI_CR1_CPHA_Pos; //Режим работы SPI: 0
  
  
  SPI1->CR2 |= 1<<SPI_CR2_TXDMAEN_Pos;
  SPI1->CR2 |= 1<<SPI_CR2_RXDMAEN_Pos;
  SPI1->CR1 |= 1<<SPI_CR1_SPE_Pos; //Включаем SPI
}

void SPI_Send(uint8_t *data, uint16_t len)
{
  //отключаем канал DMA после предыдущей передачи данных
  DMA1_Channel3->CCR &= ~(1 << DMA_CCR_EN_Pos); 
  
  DMA1_Channel3->CPAR = (uint32_t)(&SPI1->DR); //заносим адрес регистра DR в CPAR
  DMA1_Channel3->CMAR = (uint32_t)data; //заносим адрес данных в регистр CMAR
  DMA1_Channel3->CNDTR = len; //количество передаваемых данных
  
  //Настройка канала DMA
  DMA1_Channel3->CCR = 0 << DMA_CCR_MEM2MEM_Pos //режим MEM2MEM отключен
    | 0x00 << DMA_CCR_PL_Pos //приоритет низкий
    | 0x00 << DMA_CCR_MSIZE_Pos //разрядность данных в памяти 8 бит
    | 0x01 << DMA_CCR_PSIZE_Pos //разрядность регистра данных 16 бит 
    | 1 << DMA_CCR_MINC_Pos //Включить инкремент адреса памяти
    | 0 << DMA_CCR_PINC_Pos //Инкремент адреса периферии отключен
    | 0 << DMA_CCR_CIRC_Pos //кольцевой режим отключен
    | 1 << DMA_CCR_DIR_Pos;  //1 - из памяти в периферию
  
  DMA1_Channel3->CCR |= 1 << DMA_CCR_EN_Pos; //включаем передачу данных
}

void SPI_Receive(uint8_t *data, uint16_t len)
{
  static uint8_t _filler = 0xFF;
  
  //отключаем канал DMA после предыдущей передачи данных
  DMA1_Channel2->CCR &= ~(1 << DMA_CCR_EN_Pos); 
  
  DMA1_Channel2->CPAR = (uint32_t)(&SPI1->DR); //заносим адрес регистра DR в CPAR
  DMA1_Channel2->CMAR = (uint32_t)data; //заносим адрес данных в регистр CMAR
  DMA1_Channel2->CNDTR = len; //количество передаваемых данных
  
  //Настройка канала DMA
  DMA1_Channel2->CCR = 0 << DMA_CCR_MEM2MEM_Pos //режим MEM2MEM отключен
    | 0x00 << DMA_CCR_PL_Pos //приоритет низкий
    | 0x00 << DMA_CCR_MSIZE_Pos //разрядность данных в памяти 8 бит
    | 0x01 << DMA_CCR_PSIZE_Pos //разрядность регистра данных 16 бит 
    | 1 << DMA_CCR_MINC_Pos //Включить инкремент адреса памяти
    | 0 << DMA_CCR_PINC_Pos //Инкремент адреса периферии отключен
    | 0 << DMA_CCR_CIRC_Pos //кольцевой режим отключен
    | 0 << DMA_CCR_DIR_Pos;  //0 - из периферии в память
  
  DMA1_Channel2->CCR |= 1 << DMA_CCR_EN_Pos; //включаем прием данных
  
  
  //////////////////////////////////////////////////////////////////////////////
  
  //отключаем канал DMA после предыдущей передачи данных
  DMA1_Channel3->CCR &= ~(1 << DMA_CCR_EN_Pos); 
  
  DMA1_Channel3->CPAR = (uint32_t)(&SPI1->DR); //заносим адрес регистра DR в CPAR
  DMA1_Channel3->CMAR = (uint32_t)(&_filler); //заносим адрес данных в регистр CMAR
  DMA1_Channel3->CNDTR = len; //количество передаваемых данных
  
  //Настройка канала DMA
  DMA1_Channel3->CCR = 0 << DMA_CCR_MEM2MEM_Pos //режим MEM2MEM отключен
    | 0x00 << DMA_CCR_PL_Pos //приоритет низкий
    | 0x00 << DMA_CCR_MSIZE_Pos //разрядность данных в памяти 8 бит
    | 0x01 << DMA_CCR_PSIZE_Pos //разрядность регистра данных 16 бит 
    | 0 << DMA_CCR_MINC_Pos //Инкремент адреса памяти отключен
    | 0 << DMA_CCR_PINC_Pos //Инкремент адреса периферии отключен
    | 0 << DMA_CCR_CIRC_Pos //кольцевой режим отключен
    | 1 << DMA_CCR_DIR_Pos;  //1 - из памяти в периферию
  
  DMA1_Channel3->CCR |= 1 << DMA_CCR_EN_Pos; //Запускаем процесс
}

void SPI_tx_rx(uint8_t *data_tx, uint8_t *data_rx, uint16_t len)
{
  // отключаем канал DMA после предыдущей передачи данных
  DMA1_Channel2->CCR &= ~(1 << DMA_CCR_EN_Pos); 
  // отключаем канал DMA после предыдущей передачи данных
  DMA1_Channel3->CCR &= ~(1 << DMA_CCR_EN_Pos); 
  
	
  DMA1_Channel2->CPAR = (uint32_t)(&SPI1->DR); //заносим адрес регистра DR в CPAR
  DMA1_Channel2->CMAR = (uint32_t)data_rx; //заносим адрес данных в регистр CMAR
  DMA1_Channel2->CNDTR = len; //количество передаваемых данных
  
  // Настройка канала DMA
  DMA1_Channel2->CCR = 0 << DMA_CCR_MEM2MEM_Pos //режим MEM2MEM отключен
    | 0x00 << DMA_CCR_PL_Pos //приоритет низкий
    | 0x00 << DMA_CCR_MSIZE_Pos //разрядность данных в памяти 8 бит
    | 0x01 << DMA_CCR_PSIZE_Pos //разрядность регистра данных 16 бит 
    | 1 << DMA_CCR_MINC_Pos //Включить инкремент адреса памяти
    | 0 << DMA_CCR_PINC_Pos //Инкремент адреса периферии отключен
    | 0 << DMA_CCR_CIRC_Pos //кольцевой режим отключен
    | 0 << DMA_CCR_DIR_Pos  //0 - из периферии в память
	| 1 << DMA_CCR_TCIE_Pos; //Прерывание при завершении передачи
  
  DMA1_Channel2->CCR |= 1 << DMA_CCR_EN_Pos; //включаем прием данных

  DMA1->IFCR = 1<<DMA_IFCR_CTCIF2_Pos; //сбрасываем флаг прерывания
  NVIC_EnableIRQ(DMA1_Channel2_IRQn); //разрешаем прерывания от канала 2 DMA1  

  DMA1_Channel3->CPAR = (uint32_t)(&SPI1->DR); //заносим адрес регистра DR в CPAR
  DMA1_Channel3->CMAR = (uint32_t)data_tx; //заносим адрес данных в регистр CMAR
  DMA1_Channel3->CNDTR = len; //количество передаваемых данных
  
  // Настройка канала DMA
  DMA1_Channel3->CCR = 0 << DMA_CCR_MEM2MEM_Pos //режим MEM2MEM отключен
    | 0x00 << DMA_CCR_PL_Pos //приоритет низкий
    | 0x00 << DMA_CCR_MSIZE_Pos //разрядность данных в памяти 8 бит
    | 0x01 << DMA_CCR_PSIZE_Pos //разрядность регистра данных 16 бит 
    | 1 << DMA_CCR_MINC_Pos //Включить инкремент адреса памяти
    | 0 << DMA_CCR_PINC_Pos //Инкремент адреса периферии отключен
    | 0 << DMA_CCR_CIRC_Pos //кольцевой режим отключен
    | 1 << DMA_CCR_DIR_Pos;  //1 - из памяти в периферию
  
  DMA1_Channel3->CCR |= 1 << DMA_CCR_EN_Pos; //включаем передачу данных
}

extern void SPI_RxCallback(void);

void DMA1_Channel2_IRQHandler(void)
{
  DMA1->IFCR = 1<<DMA_IFCR_CTCIF2_Pos; //сбрасываем флаг прерывания
  //добавить код обработки
  //...
  SPI_RxCallback();	
}
