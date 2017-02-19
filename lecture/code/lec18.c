/*--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Feb 16, 2017
-- File:	lec18.c
-- Event:	Lecture 18
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

/***************************** Include Files ********************************/

#include "xparameters.h"
#include "stdio.h"
#include "xstatus.h"
#include "platform.h"
#include "xil_printf.h"						// Contains xil_printf
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
#include <xil_io.h>							// Contains Xil_Out8 and its variations

/************************** Constant Definitions ****************************/

/*
 * The following constants define the slave registers used for our Counter PCORE
 */
#define countQReg		0x44a00000			// 8 LSBs of slv_reg0 read=Q, write=D
#define	countCtrlReg	0x44a00004			// 2 LSBs of slv_reg1 are control
#define	countRollReg	0x44a00008			// 1 LSBs of slv_reg2 for roll

/*
 * The following constants define the Counter commands
 */
#define count_HOLD		0x00		// The control bits are defined in the VHDL
#define	count_COUNT		0x01		// code contained in lec18.vhdl.  They are
#define	count_LOAD		0x02		// added here to centralize the bit values in
#define count_RESET		0x03		// a single place.

#define printf xil_printf			/* A smaller footprint printf */

#define	uartRegAddr			0x40600000		// read <= RX, write => TX

/************************** Function Prototypes ****************************/


/************************** Variable Definitions **************************/

/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */

int main()
{
	unsigned char c;

	init_platform();

	print("Welcome to Lecture 18\n\r");

	while(1) {

    	c=XUartLite_RecvByte(uartRegAddr);

    	switch(c) {

    		/*-------------------------------------------------
    		 * Reply with the help menu
    		 *-------------------------------------------------
			 */
    		case '?':
    			printf("--------------------------\r\n");
    			printf("	count Q = %x\r\n",Xil_In16(countQReg));
    			printf("--------------------------\r\n");
    			printf("?: help menu\r\n");
    			printf("o: k\r\n");
    			printf("c: COUNTER	count up LEDs (by x26)\r\n");
    			printf("l: COUNTER	load counter\r\n");
    			printf("r: COUNTER	reset counter\r\n");
    			printf("f: flush terminal\r\n");
    			break;

			/*-------------------------------------------------
			 * Basic I/O loopback
			 *-------------------------------------------------
			 */
    		case 'o':
    			printf("k \r\n");
    			break;

			/*-------------------------------------------------
			 * Tell the counter to count up
			 *-------------------------------------------------
			 */
    		case 'c':
    			Xil_Out8(countCtrlReg,count_COUNT);
    			Xil_Out8(countCtrlReg,count_HOLD);
    			break;
				
			/*-------------------------------------------------
			 * Tell the counter to load a value
			 *-------------------------------------------------
			 */
        	case 'l':
        		printf("Enter a 0-9 value to store in the counter: ");
            	c=XUartLite_RecvByte(uartRegAddr) - 0x30;
        		Xil_Out8(countQReg,c);					// put value into slv_reg1
        		Xil_Out8(countCtrlReg,count_LOAD);				// load command
    			printf("%c\r\n",c+0x30);
        		break;

			/*-------------------------------------------------
			 * Reset the counter
			 *-------------------------------------------------
			 */
            case 'r':
            	Xil_Out8(countCtrlReg,count_RESET);				// reset command
            	break;

			/*-------------------------------------------------
			 * Clear the terminal window
			 *-------------------------------------------------
			 */
            case 'f':
            	for (c=0; c<40; c++) printf("\r\n");
               	break;

			/*-------------------------------------------------
			 * Unknown character was
			 *-------------------------------------------------
			 */
    		default:
    			printf("unrecognized character: %c\r\n",c);
    			break;
    	} // end case
    } // end while

    cleanup_platform();

    return 0;

} // end main

