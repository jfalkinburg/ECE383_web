/*--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Feb 16, 2017
-- File:	lec17.c
-- Event:	Lecture 17
-- Crs:	ECE 383
--
-- Purp:	MicroBlaze Tutorial that implements a custom IP to microBlaze.
--
-- Documentation:	MicroBlaze Tutorial
--
-- Academic Integrity Statement: I certify that, while others may have
-- assisted me in brain storming, debugging and validating this program,
-- the program itself is my own work. I understand that submitting code
-- which is the work of other individuals is a violation of the honor
-- code.  I also understand that if I knowingly give my original work to
-- another individual is also a violation of the honor code.
-------------------------------------------------------------------------*/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"						// Contains xil_printf
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
#include <xparameters.h>
//#include <xil_io.h>							// Contains Xil_Out8 and its variations

#define	uartRegAddr			0x40600000		// read <= RX, write => TX

//#define LedRegAddr			0x83000000		// 8 MSBs of slv_reg0 for LED bank

int main()
{
	unsigned char c;

	init_platform();

    print("Welcome to Lecture 17\n\r");

    while(1) {

    	c = XUartLite_RecvByte(uartRegAddr);
        XUartLite_SendByte(uartRegAddr, c);
//        Xil_Out8(LedReg, c);
    }

    cleanup_platform();

    return 0;

} // end main
