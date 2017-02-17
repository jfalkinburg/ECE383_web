/*--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Feb 3, 2017
-- File:	lec17.c
-- Event:	Lecture 17
-- Crs:		ECE 383
--
-- Purp:	MicroBlaze Tutorial that implements a custom IP to microBlaze.
--
-- Documentation:	MicroBlaze Tutorial and Xilinx Templates
--
-- Academic Integrity Statement: I certify that, while others may have
-- assisted me in brain storming, debugging and validating this program,
-- the program itself is my own work. I understand that submitting code
-- which is the work of other individuals is a violation of the honor
-- code.  I also understand that if I knowingly give my original work to
-- another individual is also a violation of the honor code.
-------------------------------------------------------------------------*/
/***************************** Include Files ********************************/

#include "xparameters.h"
#include "xgpio.h"
#include "stdio.h"
#include "xstatus.h"

#include "platform.h"
#include "xil_printf.h"						// Contains xil_printf
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
//#include <xil_io.h>							// Contains Xil_Out8 and its variations

/************************** Constant Definitions ****************************/

/*
 * The following constant is used to wait after an LED is turned on to make
 * sure that it is visible to the human eye.  This constant might need to be
 * tuned for faster or slower processor speeds.
 */
#define LED_DELAY	  1000000

/* The following constant is used to determine which channel of the GPIO is
 * used if there are 2 channels supported in the GPIO.
 */
#define LED_CHANNEL 1

#define LED_MAX_BLINK	0x1	/* Number of times the LED Blinks */

#define GPIO_BITWIDTH	16	/* This is the width of the GPIO */

//#define printf xil_printf	/* A smaller footprint printf */

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define LED_OUTPUT_DEVICE_ID	XPAR_GPIO_0_DEVICE_ID
#define LED_INPUT_DEVICE_ID		XPAR_GPIO_0_DEVICE_ID

#define	uartRegAddr			0x40600000		// read <= RX, write => TX

//#define LedRegAddr			0x40000000		// 8 MSBs of axi_gpio_0 for LED bank

/************************** Function Prototypes ****************************/

int GpioOutputExample(u16 DeviceId, u32 GpioWidth);

/************************** Variable Definitions **************************/

/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */
XGpio GpioOutput; /* The driver instance for GPIO Device configured as O/P */
XGpio GpioInput;  /* The driver instance for GPIO Device configured as I/P */

int main()
{
	int Status;

	unsigned char c;
	u32 LedBitC;

	init_platform();

    print("Welcome to Lecture 17\n\r");

	Status = GpioOutputExample(LED_OUTPUT_DEVICE_ID, GPIO_BITWIDTH);
	if (Status != XST_SUCCESS) {
	    print("LED GPIO Failure\n\r");
	}
	else {
	    print("LED GPIO Success\n\r");
	}

	while(1) {

    	c = XUartLite_RecvByte(uartRegAddr);
        XUartLite_SendByte(uartRegAddr, c);

        LedBitC = 0x0 + c;
        /* Set the direction for all signals to be outputs */
		XGpio_SetDataDirection(&GpioOutput, LED_CHANNEL, 0x0);
		/* Set the GPIO outputs to the value of c */
		XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, LedBitC);

    }

    cleanup_platform();

    return 0;

} // end main


/*****************************************************************************/
/**
*
* This function does a minimal test on the GPIO device configured as OUTPUT
* and driver as a example.
*
*
* @param	DeviceId is the XPAR_<GPIO_instance>_DEVICE_ID value from
*		xparameters.h
* @param	GpioWidth is the width of the GPIO
*
* @return
*		- XST_SUCCESS if successful
*		- XST_FAILURE if unsuccessful
*
* @note		None
*
****************************************************************************/
int GpioOutputExample(u16 DeviceId, u32 GpioWidth)
{
	volatile int Delay;
	u32 LedBit;
	u32 LedLoop;
	int Status;

	/*
	 * Initialize the GPIO driver so that it's ready to use,
	 * specify the device ID that is generated in xparameters.h
	 */
	 Status = XGpio_Initialize(&GpioOutput, DeviceId);
	 if (Status != XST_SUCCESS)  {
		  return XST_FAILURE;
	 }

	 /* Set the direction for all signals to be outputs */
	 XGpio_SetDataDirection(&GpioOutput, LED_CHANNEL, 0x0);

	 /* Set the GPIO outputs to low */
	 XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL, 0x0);

	 for (LedBit = 0x0; LedBit < GpioWidth; LedBit++)  {

		for (LedLoop = 0; LedLoop < LED_MAX_BLINK; LedLoop++) {

			/* Set the GPIO Output to High */
			XGpio_DiscreteWrite(&GpioOutput, LED_CHANNEL,
						1 << LedBit);

#ifndef __SIM__
			/* Wait a small amount of time so the LED is visible */
			for (Delay = 0; Delay < LED_DELAY; Delay++);

#endif
			/* Clear the GPIO Output */
			XGpio_DiscreteClear(&GpioOutput, LED_CHANNEL,
						1 << LedBit);


#ifndef __SIM__
			/* Wait a small amount of time so the LED is visible */
			for (Delay = 0; Delay < LED_DELAY; Delay++);
#endif

		  }

	 }

	 return XST_SUCCESS;

}