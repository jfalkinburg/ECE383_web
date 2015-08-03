//--------------------------------------------------------------------
//-- Name:	Chris Coulston
//-- Date:	March 2, 2015
//-- File:	lec19.c
//-- Event:	Lecture 19
//-- Crs:	ECE 383
//--
//-- Purp:	Examines how to interface custom IP to microBlaze.
//--
//-- Documentation:	I borrowed some techniques from my ECE382 examples
//--
//-- Academic Integrity Statement: I certify that, while others may have
//-- assisted me in brain storming, debugging and validating this program,
//-- the program itself is my own work. I understand that submitting code
//-- which is the work of other individuals is a violation of the honor
//-- code.  I also understand that if I knowingly give my original work to
//-- another individual is also a violation of the honor code.
//-------------------------------------------------------------------------
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
#include <xparameters.h>
#include <xil_io.h>							// Contains Xil_Out8 and its variations
#include <stdio.h>							// Contains xil_printf
#include <xil_exception.h>

#define	uartReadReg		0x84000000			// read <= RX, write=>TX

#define countBase		0x7B200000
#define countQReg		countBase			// 8 LSBs of slv_reg0 read=Q, write=D
#define	countCrtlReg	countBase+4			// 2 LSBs of slv_reg1 are control
#define	countFlagReg	countBase+8			// 2 LSBs of slv_reg2 (1) MSB of Q, (0) roll flag

#define count_HOLD		0x00				// The control bits are defined in the VHDL
#define	count_COUNT		0x01				// code contained in lec17.vhdl.  They are
#define	count_LOAD		0x02				// added here to centralize the bit values in
#define count_RESET		0x03				// a single place.

u16 isrCount = 0;
void myISR(void);

int main(void) {

    u8  c;

    microblaze_register_handler((XInterruptHandler) myISR, (void *) 0);
    microblaze_enable_interrupts();

    while(1) {

    	c=XUartLite_RecvByte(uartReadReg);

    	switch(c) {

    		//-------------------------------------------------
    		// Reply with the help menu
    		//-------------------------------------------------
    		case '?':
    			xil_printf("--------------------------\r\n");
    			xil_printf("	count Q  = %x\r\n",Xil_In16(countQReg));
    			xil_printf("	isr count= %x\r\n",isrCount);
    			xil_printf("	flag= %x\r\n",Xil_In8(countFlagReg));
    			xil_printf("--------------------------\r\n");
    			xil_printf("?: help menu\r\n");
    			xil_printf("o: k\r\n");
    			xil_printf("c: COUNTER	count up LEDs (by 9)\r\n");
    			xil_printf("s/S: start/Stop COUNTER counting up\r\n");
    			xil_printf("l: COUNTER	load counter\r\n");
    			xil_printf("r: COUNTER	reset counter\r\n");
    			xil_printf("f: flush terminal\r\n");
    			break;

    		//-------------------------------------------------
    		// Basic I/O loopback
    		//-------------------------------------------------
    		case 'o':
    			xil_printf("k \r\n");
    			break;

    		//-------------------------------------------------
    		// Tell the counter to count up
    		//-------------------------------------------------
    		case 'c':
    			Xil_Out8(countCrtlReg,count_COUNT);
    			Xil_Out8(countCrtlReg,count_HOLD);
    			break;

        	//-------------------------------------------------
        	// Tell the counter to count up
        	//-------------------------------------------------
        	case 's':
        		Xil_Out8(countCrtlReg,count_COUNT);
        		break;

        	//-------------------------------------------------
        	// Tell the counter to count up
        	//-------------------------------------------------
        	case 'S':
        		Xil_Out8(countCrtlReg,count_HOLD);
        		break;

        	//-------------------------------------------------
        	// Tell the counter to load a value
        	//-------------------------------------------------
        	case 'l':
        		xil_printf("Enter a 0-9 value to store in the counter: ");
            	c=XUartLite_RecvByte(uartReadReg) - 0x30;
        		Xil_Out8(countQReg,c);					// put value into slv_reg1
        		Xil_Out8(countCrtlReg,count_LOAD);				// load command
    			xil_printf("%c\r\n",c+0x30);
        		break;

            //-------------------------------------------------
            // Reset the counter
            //-------------------------------------------------
            case 'r':
            	Xil_Out8(countCrtlReg,count_RESET);				// reset command
            	break;

            //-------------------------------------------------
            // Clear the terminal window
            //-------------------------------------------------
            case 'f':
            	for (c=0; c<40; c++) xil_printf("\r\n");
               	break;

          //-------------------------------------------------
          // Unknown character was
          //-------------------------------------------------
    		default:
    			xil_printf("unrecognized character: %c\r\n",c);
    			break;
    	} // end case
    } // end while 1
    return 0;
} // end main


void myISR(void) {
	isrCount = isrCount + 1;
	Xil_Out8(countFlagReg, 0x01);					// Clear the flag and then you MUST
	Xil_Out8(countFlagReg, 0x00);					// allow the flag to be reset later
}

