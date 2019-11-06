/**
  ******************************************************************************
  * @file    USB_Device/CDC_Standalone/Src/usbd_cdc_interface.c
  * @author  MCD Application Team
  * @version V1.4.0
  * @date    29-April-2016
  * @brief   Source file for USBD CDC interface
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright © 2016 STMicroelectronics International N.V.
  * All rights reserved.</center></h2>
  *
  * Redistribution and use in source and binary forms, with or without 
  * modification, are permitted, provided that the following conditions are met:
  *
  * 1. Redistribution of source code must retain the above copyright notice, 
  *    this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  *    this list of conditions and the following disclaimer in the documentation
  *    and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of other 
  *    contributors to this software may be used to endorse or promote products 
  *    derived from this software without specific written permission.
  * 4. This software, including modifications and/or derivative works of this 
  *    software, must execute solely and exclusively on microcontroller or
  *    microprocessor devices manufactured by or for STMicroelectronics.
  * 5. Redistribution and use of this software other than as permitted under 
  *    this license is void and will automatically terminate your rights under 
  *    this license. 
  *
  * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT 
  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
  * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT 
  * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
  * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "spi_dma.h"

//#define SET_INVERSE_SWOUT

/** @addtogroup STM32_USB_OTG_DEVICE_LIBRARY
  * @{
  */

/** @defgroup USBD_CDC 
  * @brief usbd core module
  * @{
  */ 

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define APP_RX_DATA_SIZE  64
#define APP_TX_DATA_SIZE  (APP_RX_DATA_SIZE*2)
#define SPI_RXTX_DATA_SIZE  1024

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
USBD_CDC_LineCodingTypeDef LineCoding =
  {
    115200, /* baud rate*/
    0x00,   /* stop bits-1*/
    0x00,   /* parity - none*/
    0x08    /* nb. of bits 8*/
  };

// полученные данные из USB в буфере USB_RxBuffer 
uint8_t USB_RxBuffer[APP_RX_DATA_SIZE];/* Received Data over USB are stored in this buffer */
// полученные данные от UART сохраняются в буфере USB_TxBuffer 
uint8_t USB_TxBuffer[APP_TX_DATA_SIZE];/* Received Data over UART (CDC interface) are stored in this buffer */
//uint32_t BuffLength;
uint32_t spi_rxlen = 0;
uint32_t spi_txlen = 0;
uint32_t spi_txlen_tst = 0;
uint16_t tst_cnt = 0;

uint8_t spi_rx_buf[SPI_RXTX_DATA_SIZE];
uint8_t spi_tx_buf[SPI_RXTX_DATA_SIZE];  
uint16_t swbuf(uint8_t *swdata, uint8_t *data, uint16_t len);
  
#ifdef USE_UART  
uint32_t UserTxBufPtrIn = 0;/* Increment this pointer or roll it back to start address when data are received over USART */
uint32_t UserTxBufPtrOut = 0; /* Increment this pointer or roll it back to start address when data are sent over USB */

/* UART handler declaration */
UART_HandleTypeDef UartHandle;
/* TIM handler declaration */
TIM_HandleTypeDef    TimHandle;
#endif // USE_UART 

/* USB handler declaration */
extern USBD_HandleTypeDef  USBD_Device;

/* Private function prototypes -----------------------------------------------*/
static int8_t CDC_Itf_Init     (void);
static int8_t CDC_Itf_DeInit   (void);
static int8_t CDC_Itf_Control  (uint8_t cmd, uint8_t* pbuf, uint16_t length);
static int8_t CDC_Itf_Receive  (uint8_t* pbuf, uint32_t *Len);

#ifdef USE_UART
static void ComPort_Config(void);
static void TIM_Config(void);
#endif

USBD_CDC_ItfTypeDef USBD_CDC_fops =
{
  CDC_Itf_Init,
  CDC_Itf_DeInit,
  CDC_Itf_Control,
  CDC_Itf_Receive
};

/* Private functions ---------------------------------------------------------*/

/**
  * @brief  CDC_Itf_Init
  *         Initializes the CDC media low layer
  * @param  None
  * @retval Result of the opeartion: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Itf_Init(void)
{
#ifdef USE_UART	
  /*##-1- Configure the UART peripheral ######################################*/
  /* Put the USART peripheral in the Asynchronous mode (UART Mode) */
  /* USART configured as follows:
      - Word Length = 8 Bits
      - Stop Bit    = One Stop bit
      - Parity      = No parity
      - BaudRate    = 115200 baud
      - Hardware flow control disabled (RTS and CTS signals) */
  UartHandle.Instance        = USARTx;
  UartHandle.Init.BaudRate   = 115200;
  UartHandle.Init.WordLength = UART_WORDLENGTH_8B;
  UartHandle.Init.StopBits   = UART_STOPBITS_1;
  UartHandle.Init.Parity     = UART_PARITY_NONE;
  UartHandle.Init.HwFlowCtl  = UART_HWCONTROL_NONE;
  UartHandle.Init.Mode       = UART_MODE_TX_RX;

  if(HAL_UART_Init(&UartHandle) != HAL_OK)
  {
    /* Initialization Error */
    Error_Handler();
  }

  /*##-2- Put UART peripheral in IT reception process ########################*/
  /* Any data received will be stored in "USB_TxBuffer" buffer  */
  if(HAL_UART_Receive_IT(&UartHandle, (uint8_t *)USB_TxBuffer, 1) != HAL_OK)
  {
    /* Transfer error in reception process */
    Error_Handler();
  }
  /*##-3- Configure the TIM Base generation  #################################*/
  TIM_Config();

  /*##-4- Start the TIM Base generation in interrupt mode ####################*/
  /* Start Channel1 */
  if(HAL_TIM_Base_Start_IT(&TimHandle) != HAL_OK)
  {
    /* Starting Error */
    Error_Handler();
  }
#endif // USE_UART

#ifdef USE_SPI
  spi_rxlen = 0;
  SPIInit(0x02); // 2!!
#endif  
  /*##-5- Set Application Buffers ############################################*/
  USBD_CDC_SetTxBuffer(&USBD_Device, USB_TxBuffer, 0);
  USBD_CDC_SetRxBuffer(&USBD_Device, USB_RxBuffer);
//#ifndef SET_INVERSE_SWOUT
  USB_RxBuffer[0] = 0xff;
  USB_RxBuffer[1] = 0xff;
  spi_rxlen = 2;
  SPI_tx_rx(spi_tx_buf, spi_rx_buf, swbuf(spi_tx_buf, USB_RxBuffer, spi_rxlen));
//#endif  
  return (USBD_OK);
}

/**
  * @brief  CDC_Itf_DeInit
  *         DeInitializes the CDC media low layer
  * @param  None
  * @retval Result of the opeartion: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Itf_DeInit(void)
{
#ifdef USE_UART	
  /* DeInitialize the UART peripheral */
  if(HAL_UART_DeInit(&UartHandle) != HAL_OK)
  {
    /* Initialization Error */
    Error_Handler();
  }
#endif // USE_UART 
  return (USBD_OK);
}

/**
  * @brief  CDC_Itf_Control
  *         Manage the CDC class requests
  * @param  Cmd: Command code
  * @param  Buf: Buffer containing command data (request parameters)
  * @param  Len: Number of data to be sent (in bytes)
  * @retval Result of the opeartion: USBD_OK if all operations are OK else USBD_FAIL
  */
static int8_t CDC_Itf_Control (uint8_t cmd, uint8_t* pbuf, uint16_t length)
{ 
  switch (cmd)
  {
  case CDC_SEND_ENCAPSULATED_COMMAND:
    /* Add your code here */
    break;

  case CDC_GET_ENCAPSULATED_RESPONSE:
    /* Add your code here */
    break;

  case CDC_SET_COMM_FEATURE:
    /* Add your code here */
    break;

  case CDC_GET_COMM_FEATURE:
    /* Add your code here */
    break;

  case CDC_CLEAR_COMM_FEATURE:
    /* Add your code here */
    break;

  case CDC_SET_LINE_CODING:
    LineCoding.bitrate    = (uint32_t)(pbuf[0] | (pbuf[1] << 8) |\
                            (pbuf[2] << 16) | (pbuf[3] << 24));
    LineCoding.format     = pbuf[4];
    LineCoding.paritytype = pbuf[5];
    LineCoding.datatype   = pbuf[6];

    /* Set the new configuration */
#ifdef USE_UART
    ComPort_Config();
#endif // USE_UART 
    break;

  case CDC_GET_LINE_CODING:
    pbuf[0] = (uint8_t)(LineCoding.bitrate);
    pbuf[1] = (uint8_t)(LineCoding.bitrate >> 8);
    pbuf[2] = (uint8_t)(LineCoding.bitrate >> 16);
    pbuf[3] = (uint8_t)(LineCoding.bitrate >> 24);
    pbuf[4] = LineCoding.format;
    pbuf[5] = LineCoding.paritytype;
    pbuf[6] = LineCoding.datatype;

    /* Add your code here */
    break;

  case CDC_SET_CONTROL_LINE_STATE:
    /* Add your code here */
    break;

  case CDC_SEND_BREAK:
     /* Add your code here */
    break;    
    
  default:
    break;
  }

  return (USBD_OK);
}
#ifdef USE_UART
/**
  * @brief  TIM period elapsed callback
  * @param  htim: TIM handle
  * @retval None
  */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  uint32_t buffptr;
  uint32_t buffsize;

  if(UserTxBufPtrOut != UserTxBufPtrIn)
  {
    if(UserTxBufPtrOut > UserTxBufPtrIn) /* rollback */
    {
      buffsize = APP_RX_DATA_SIZE - UserTxBufPtrOut;
    }
    else
    {
      buffsize = UserTxBufPtrIn - UserTxBufPtrOut;
    }

    buffptr = UserTxBufPtrOut;

    USBD_CDC_SetTxBuffer(&USBD_Device, (uint8_t*)&USB_TxBuffer[buffptr], buffsize);

    if(USBD_CDC_TransmitPacket(&USBD_Device) == USBD_OK)
    {
      UserTxBufPtrOut += buffsize;
      if (UserTxBufPtrOut == APP_RX_DATA_SIZE)
      {
        UserTxBufPtrOut = 0;
      }
    }
  }
}

/**
  * @brief  Rx Transfer completed callback (DMAStop)
  * @param  huart: UART handle
  * @retval None
  */
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  /* Increment Index for buffer writing */
  UserTxBufPtrIn++;

  /* To avoid buffer overflow */
  if(UserTxBufPtrIn == APP_RX_DATA_SIZE)
  {
    UserTxBufPtrIn = 0;
  }
  /* Start another reception: provide the buffer pointer with offset and the buffer size */
  HAL_UART_Receive_IT(huart, (uint8_t *)(USB_TxBuffer + UserTxBufPtrIn), 1);
  
  Toggle_Leds();
}
#endif // USE_UART

/*
Swire Bit:
  12345 (5 CLK swire)
0 _----
1 ____-
 
Передача байта:
Стартовый бит (cmd), 8 бит команды/данных (старший бит первым), bit end
Итого 10 бит.
 
Порядок передачи:
 1-ый байт: Команда START = cmd бит "1", 8 бит байта 0x5A, end бит "0"
 2-ый байт: Адрес addrH = cmd бит "0", 8 старших бит адреса, end бит "0"
 3-ый байт: Адрес addrL = cmd бит "0", 8 младших бит адреса, end бит "0"
 4-ый байт: WR_ID = cmd бит "0", 1 бит чтение/записи ("1" - чтение, "0" - запись), 7 бит ID устройства, end бит "0"
 5-ый байт: Данные:
            1. При чтении мастер запускает cmd бит "0", далее устройство отвечает 8-ю битами данных и end битом "0"
            2. При записи мастер передает cmd бит "0", 8 бит данных, end бит "0"
            Адрес автоматически увеличивается на единицу.  
 ...
 N-ый байт: Команда END = cmd бит "1", байт 0xFF, end бит "0"
 
 0.58675 us на Q 16 MHz
*/
#define SW_SPI_BITS 7
#define SW_SPI_BITS_TST 4
#define SW_MAX_BUF_BITS (64*10*SW_SPI_BITS)	// 4480
#define SW_MAX_BUF  (SW_MAX_BUF_BITS/8 + 2) // 560 + 2
#if SPI_RXTX_DATA_SIZE < SW_MAX_BUF
#error Low APP_TX_DATA_SIZE!
#endif

#ifdef SET_INVERSE_SWOUT
#define setbit(b, p) p[(b) >> 3] |= 0x80 >> ((b) & 7)
#else
#define setbit(b, p) p[(b) >> 3] ^= 0x80 >> ((b) & 7)
#endif	
uint32_t slbSbit(uint32_t sl, uint8_t *ptr, uint8_t bit) {
	setbit(sl, ptr);
	setbit(sl+1, ptr);
	if(bit) {
		setbit(sl+2, ptr);
		setbit(sl+3, ptr);
		setbit(sl+4, ptr);
	}
	return sl + SW_SPI_BITS;
}
	
uint16_t swbuf(uint8_t *swdata, uint8_t *data, uint16_t len) {
	uint32_t i, sl = 1;
	uint8_t mask, rd_flag = 0;
	if(len) {
#ifdef SET_INVERSE_SWOUT
		memset(swdata, 0, SW_MAX_BUF );
#else
		memset(swdata, 0xff, SW_MAX_BUF);
#endif		
		for(i = 0; i < len; i++) {
			// старт бит cmd, для данных = "0", для START и END = "1"
			sl = slbSbit(sl, swdata, i == 0 || i == len-1); // START и END байты с битом cmd = "1" 
			// будет чтение (бит 7 в RW_ID = "1") ?
			if(rd_flag && i != len-1) {
				// старт (cmd = "0") чтения 8 бит + bit end (итого 10 бит)
				sl += 9*SW_SPI_BITS;
			}
			else {
				// data bytes 
				for(mask = 0x80; mask != 0; mask >>= 1) {
					// 8 bits of byte
					sl = slbSbit(sl, swdata, data[i] & mask);
				}
				// bit end
				sl = slbSbit(sl, swdata, 0);
			}
			if(i == 3 && (data[3] & 0x80)) 
				rd_flag = 1;
		}
	}
	return ((sl+7)>>3)+1;
}

int swdecode(uint8_t *data, uint8_t *swdata, uint8_t len) {
	uint32_t obi = 0, slx = 0, msk = 0x200;
	uint32_t sle = SW_SPI_BITS * 2;
	do {
		if ((swdata[slx >> 3] & (0x80 >> (slx & 7))) == 0) { // еcть строб?
			// найден строб '\'
			sle = slx + SW_SPI_BITS * 2; // установим новое ограничение от старта строба до нового строба
			if(sle > SW_MAX_BUF_BITS)
				return -1;
			slx += SW_SPI_BITS_TST - 1;	// шаг
			if((swdata[slx >> 3] & (0x80 >> (slx & 7))) == 0) { // low -> передана "1"
				slx++;
				obi |= msk;
				while ((swdata[slx >> 3] & (0x80 >> (slx & 7))) == 0 && slx < sle) 
					slx++;
			}
			msk >>= 1;
			if(msk == 0) { // приняли все 10 бит ?
				*data++ = ((obi >> 8) & 2) | (obi & 1);
				*data++ = obi >> 1;
				if(--len == 0) 
					return 0;
				msk = 0x200;
				obi = 0;
			}
		}
		slx++;					  // смотрим следующий
	} while (slx < sle);
	return -1;
}

/**
  * @brief  CDC_Itf_DataRx
  *         Data received over USB OUT endpoint are sent over CDC interface 
  *         through this function.
  * @param  Buf: Buffer of data to be transmitted
  * @param  Len: Number of data received (in bytes)
  * @retval Result of the opeartion: USBD_OK if all operations are OK else USBD_FAIL
  */
static uint8_t sw_cpu_stop[6]   = { 0x5a, 0x06, 0x02, 0x00, 0x05, 0xff };
// #define reg_swire_clk_div		REG_ADDR8(0xb2)
static uint8_t sw_reg_clkdiv[6] = { 0x5a, 0x00, 0xb2, 0x80, 0xff, 0xff };

static int8_t CDC_Itf_Receive(uint8_t* Buf, uint32_t *Len)
{
  uint32_t reg;
#ifdef USE_UART	
  HAL_UART_Transmit_DMA(&UartHandle, Buf, *Len);
#endif // USE_UART	
#ifdef USE_SPI
  // принят блок Buf из USB
  spi_rxlen = (*Len) & 0x7F; 	
  if(spi_rxlen) {
      HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
	  if(Buf[0] == 0x55 && spi_rxlen > 1) {
		  switch(Buf[1]) {
			case 0: // Pull RST pin to GND 
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_RESET);
			    spi_rxlen = 2;
				break;
			case 1: // Release pin RST
				HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_SET);
			    spi_rxlen = 2;
				break;
			case 2: // Function 'Activate'
			    if (spi_rxlen == 4) {
					tst_cnt = (Buf[2]<<8) | Buf[3];
					HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_SET);
					spi_txlen = swbuf(spi_tx_buf, sw_cpu_stop, sizeof(sw_cpu_stop));
					spi_txlen_tst = swbuf(&spi_tx_buf[spi_txlen], sw_reg_clkdiv, sizeof(sw_reg_clkdiv));
					SPI_tx_rx(spi_tx_buf, spi_rx_buf, spi_txlen);
					spi_rxlen = 0;
				}
				break;
			case 3: // Break 'Activate'
				tst_cnt = 0;
				spi_txlen_tst = 0;
				spi_txlen = 2;
				break;
			case 4: // Get version && GPIO
				Buf[2] = 0x00; // version hi
				Buf[3] = 0x02; // version lo
				reg = GPIOA->IDR;
				Buf[4] = reg >> 8;	// PA8..15
				Buf[5] = reg;		// PA0..7
				reg = GPIOB->IDR;   
				Buf[6] = reg >> 8;	// PB8..15
				Buf[7] = reg;		// PB0..7
				reg = GPIOC->IDR;
				Buf[8] = reg >> 8;  // PC8..15 (STM32F103C8 only PC13..15)
				Buf[9] = reg;		// PC0..7
				spi_rxlen = 10;
				break;
			case 5: // Set Swire Speed
				if (spi_rxlen == 3) {
					Buf[2] &= 7;
					SPIInit(Buf[2]);
					spi_rxlen = 3;
				}
				break;
			default:
				if (spi_rxlen == 6) {
					reg = (Buf[2]<<24) | (Buf[3]<<16) | (Buf[4]<<8) | Buf[5];
					switch(Buf[1]) {
						case 0x10: 
							GPIOA->BSRR = reg;
							reg = GPIOA->ODR;
							break;
						case 0x11: 
							GPIOB->BSRR = reg;
							reg = GPIOB->ODR;
							break;
						case 0x12: 
							GPIOC->BSRR = reg;
							reg = GPIOC->ODR;
							break;
						
						case 0x20: 
							GPIOA->CRL &= reg;
							reg = GPIOA->CRL;
							break;
						case 0x21: 
							GPIOA->CRH &= reg;
							reg = GPIOA->CRH;
							break;
						case 0x22: 
							GPIOB->CRL &= reg;
							reg = GPIOB->CRL;
							break;
						case 0x23: 
							GPIOB->CRH &= reg;
							reg = GPIOB->CRH;
							break;
						case 0x24: 
							GPIOC->CRL &= reg;
							reg = GPIOC->CRL;
							break;
						case 0x25: 
							GPIOC->CRH &= reg;
							reg = GPIOC->CRH;
							break;

						case 0x30: 
							GPIOA->CRL |= reg;
							reg = GPIOA->CRL;
							break;
						case 0x31: 
							GPIOA->CRH |= reg;
							reg = GPIOA->CRH;
							break;
						case 0x32: 
							GPIOB->CRL |= reg;
							reg = GPIOB->CRL;
							break;
						case 0x33: 
							GPIOB->CRH |= reg;
							reg = GPIOB->CRH;
							break;
						case 0x34: 
							GPIOC->CRL |= reg;
							reg = GPIOC->CRL;
							break;
						case 0x35: 
							GPIOC->CRH |= reg;
							reg = GPIOC->CRH;
							break;
/*
						case 0x40: 
							reg = GPIOA->LCKR;
							break;
						case 0x41: 
							reg = GPIOB->LCKR;
							break;
						case 0x42: 
							reg = GPIOC->LCKR;
							break;
*/						
						default:
							Buf[1] |= 0x80;
					}
					Buf[2] = reg >> 24;
					Buf[3] = reg >> 16;
					Buf[4] = reg >> 8;
					Buf[5] = reg;
				}
				break;		
		  };
		  if(spi_rxlen) {
			USBD_CDC_SetTxBuffer(&USBD_Device, Buf, spi_rxlen);
			USBD_CDC_TransmitPacket(&USBD_Device);
			/* Initiate next USB packet transfer once UART completes transfer (transmitting data over Tx line) */
			USBD_CDC_ReceivePacket(&USBD_Device);
			HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);  
		  }
	  }
	  else {
		spi_txlen = 0;  
		SPI_tx_rx(spi_tx_buf, spi_rx_buf, swbuf(spi_tx_buf, Buf, spi_rxlen));
	  }
  }
#endif	
  return (USBD_OK);
}
#ifdef USE_UART
/**
  * @brief  Tx Transfer completed callback
  * @param  huart: UART handle
  * @retval None
  */
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
  /* Initiate next USB packet transfer once UART completes transfer (transmitting data over Tx line) */
  USBD_CDC_ReceivePacket(&USBD_Device);
  Toggle_Leds();
}
/**
  * @brief  ComPort_Config
  *         Configure the COM Port with the parameters received from host.
  * @param  None.
  * @retval None.
  * @note   When a configuration is not supported, a default value is used.
  */
static void ComPort_Config(void)
{
  if(HAL_UART_DeInit(&UartHandle) != HAL_OK)
  {
    /* Initialization Error */
    Error_Handler();
  }

  /* set the Stop bit */
  switch (LineCoding.format)
  {
  case 0:
    UartHandle.Init.StopBits = UART_STOPBITS_1;
    break;
  case 2:
    UartHandle.Init.StopBits = UART_STOPBITS_2;
    break;
  default :
    UartHandle.Init.StopBits = UART_STOPBITS_1;
    break;
  }

  /* set the parity bit*/
  switch (LineCoding.paritytype)
  {
  case 0:
    UartHandle.Init.Parity = UART_PARITY_NONE;
    break;
  case 1:
    UartHandle.Init.Parity = UART_PARITY_ODD;
    break;
  case 2:
    UartHandle.Init.Parity = UART_PARITY_EVEN;
    break;
  default :
    UartHandle.Init.Parity = UART_PARITY_NONE;
    break;
  }

  /*set the data type : only 8bits and 9bits is supported */
  switch (LineCoding.datatype)
  {
  case 0x07:
    /* With this configuration a parity (Even or Odd) must be set */
    UartHandle.Init.WordLength = UART_WORDLENGTH_8B;
    break;
  case 0x08:
    if(UartHandle.Init.Parity == UART_PARITY_NONE)
    {
      UartHandle.Init.WordLength = UART_WORDLENGTH_8B;
    }
    else
    {
      UartHandle.Init.WordLength = UART_WORDLENGTH_9B;
    }

    break;
  default :
    UartHandle.Init.WordLength = UART_WORDLENGTH_8B;
    break;
  }

  UartHandle.Init.BaudRate = LineCoding.bitrate;
  UartHandle.Init.HwFlowCtl  = UART_HWCONTROL_NONE;
  UartHandle.Init.Mode       = UART_MODE_TX_RX;

  if(HAL_UART_Init(&UartHandle) != HAL_OK)
  {
    /* Initialization Error */
    Error_Handler();
  }

  /* Start reception: provide the buffer pointer with offset and the buffer size */
  HAL_UART_Receive_IT(&UartHandle, (uint8_t *)(USB_TxBuffer + UserTxBufPtrIn), 1);
}

/**
  * @brief  TIM_Config: Configure TIMx timer
  * @param  None.
  * @retval None.
  */
static void TIM_Config(void)
{
  /* Set TIMx instance */
  TimHandle.Instance = TIMx;

  /* Initialize TIM3 peripheral as follows:
       + Period = 10000 - 1
       + Prescaler = ((SystemCoreClock/2)/10000) - 1
       + ClockDivision = 0
       + Counter direction = Up
  */
  TimHandle.Init.Period = (CDC_POLLING_INTERVAL*1000) - 1;
  TimHandle.Init.Prescaler = 84-1;
  TimHandle.Init.ClockDivision = 0;
  TimHandle.Init.CounterMode = TIM_COUNTERMODE_UP;
  if(HAL_TIM_Base_Init(&TimHandle) != HAL_OK)
  {
    /* Initialization Error */
    Error_Handler();
  }
}

/**
  * @brief  UART error callbacks
  * @param  UartHandle: UART handle
  * @retval None
  */
void HAL_UART_ErrorCallback(UART_HandleTypeDef *UartHandle)
{
  /* Transfer error occured in reception and/or transmission process */
  Error_Handler();
}
#endif // USE_UART

#ifdef USE_SPI
// принят блок пор SPI
void SPI_RxCallback(void)
{
  if(spi_rxlen)	{
	memset(USB_TxBuffer, 0xff, spi_rxlen << 1);
	swdecode(USB_TxBuffer, spi_rx_buf, spi_rxlen);  
	USBD_CDC_SetTxBuffer(&USBD_Device, USB_TxBuffer, spi_rxlen << 1);
	USBD_CDC_TransmitPacket(&USBD_Device);
    /* Initiate next USB packet transfer once UART completes transfer (transmitting data over Tx line) */
    USBD_CDC_ReceivePacket(&USBD_Device);
  }
  else if(spi_txlen) {
	  if(tst_cnt) {
		tst_cnt--;
		SPI_tx_rx(spi_tx_buf, spi_rx_buf, spi_txlen);
	  }
	  else if(spi_txlen_tst) {
		SPI_tx_rx(&spi_tx_buf[spi_txlen], spi_rx_buf, spi_txlen_tst);
		spi_txlen = 0;  
	    spi_rxlen = sizeof(sw_reg_clkdiv);
	  }
  }
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
}
#endif
/**
  * @}
  */ 

/**
  * @}
  */ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

