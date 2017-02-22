/*--------------------------------------------------------------------
-- Name:	Maj Jeff Falkinburg
-- Date:	Feb 19, 2017
-- File:	lec19.c
-- Event:	Lecture 19
-- Crs:		ECE 383
--
-- Purp:	MicroBlaze Tutorial that implements a custom IP with interrupt 
--			to MicroBlaze.
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
#include <xil_exception.h>

/************************** Constant Definitions ****************************/

/*
 * The following constants define the slave registers used for our Counter PCORE
 */
#define countBase		0x44a00000
#define countQReg		countBase			// 8 LSBs of slv_reg0 read=Q, write=D
#define	countCtrlReg	countBase+4			// 2 LSBs of slv_reg1 are control
#define	countRollReg	countBase+8			// 1 LSBs of slv_reg2 for roll flag
#define	countClearReg	countBase+0xc		// 1 LSBs of slv_reg3 (0) roll clear flag
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
void myISR(void);

/************************** Variable Definitions **************************/
/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */
u16 isrCount = 0;

int main(void) {

	unsigned char c;

	init_platform();

	print("Welcome to Lecture 19\n\r");

    microblaze_register_handler((XInterruptHandler) myISR, (void *) 0);
    microblaze_enable_interrupts();

    Xil_Out8(countClearReg, 0x01);					// Clear the flag and then you MUST
	Xil_Out8(countClearReg, 0x00);					// allow the flag to be reset later

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
    			printf("	isr count = %x\r\n",isrCount);
    			printf("	Roll = %x\r\n",Xil_In16(countRollReg));
    			printf("--------------------------\r\n");
    			printf("?: help menu\r\n");
    			printf("o: k\r\n");
    			printf("c:   COUNTER	count up LEDs (by x26)\r\n");
    			printf("s/S: COUNTER 	start/Stop counter\r\n");
    			printf("S:   COUNTER	stop counter\r\n");
    			printf("l:   COUNTER	load counter\r\n");
    			printf("r:   COUNTER	reset counter\r\n");
    			printf("i:   Clear ISR counter\r\n");
    			printf("f:   flush terminal\r\n");
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
			 * Start the counter to count up
			 *-------------------------------------------------
			 */
        	case 's':
        		Xil_Out8(countCtrlReg,count_COUNT);
        		break;

			/*-------------------------------------------------
			 * Stop the counter from counting
			 *-------------------------------------------------
			 */
        	case 'S':
        		Xil_Out8(countCtrlReg,count_HOLD);
        		break;

			/*-------------------------------------------------
			 * Tell the counter to load a value
			 *-------------------------------------------------
			 */
        	case 'l':
        		printf("Enter a 0-9 value to store in the counter: ");
            	c=XUartLite_RecvByte(uartRegAddr) - 0x30;
        		Xil_Out8(countQReg,c);						// put value into slv_reg1
        		Xil_Out8(countCtrlReg,count_LOAD);			// load command
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
			 * Clear the ISR counter
			 *-------------------------------------------------
			 */
			case 'i':
				isrCount = 0;				// clear ISR Count
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

    } // end while 1

    cleanup_platform();

    return 0;
} // end main


void myISR(void) {
	isrCount = isrCount + 1;
	Xil_Out8(countClearReg, 0x01);					// Clear the flag and then you MUST
	Xil_Out8(countClearReg, 0x00);					// allow the flag to be reset later
}
