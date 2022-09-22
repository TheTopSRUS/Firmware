/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.5 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 01.10.2009
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 16,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 100
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

#include <delay.h>


#define FIRST_ADC_INPUT 2
#define LAST_ADC_INPUT 3
unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x20

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
// Read the 8 most significant bits
// of the AD conversion result
adc_data[input_index]=ADCH;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}



// Declare your global variables here

unsigned char On = 1;
unsigned char Off = 0;        
unsigned char Fan1_Status;
unsigned char Fan2_Status;
unsigned char Fan3_Status;
unsigned  int PWM1_Value = 0x3FF;;
unsigned  int PWM2_Value = 0x3FF;;
unsigned char Tmp1_Value;
unsigned char Tmp2_Value; 

                              

unsigned char enterchar(void)
{
while(!rx_counter);
return getchar();
} 

unsigned int enterdata(unsigned char cnt)
{
unsigned char i = 0;
unsigned int k = 0;
unsigned char a;

for (i=1; i<= cnt; i++)
{
a=enterchar();

switch (a)
{
 case '1': { k = k*10+1; break;}
 case '2': { k = k*10+2; break;}
 case '3': { k = k*10+3; break;}
 case '4': { k = k*10+4; break;}
 case '5': { k = k*10+5; break;}
 case '6': { k = k*10+6; break;}
 case '7': { k = k*10+7; break;}
 case '8': { k = k*10+8; break;}
 case '9': { k = k*10+9; break;}
 case '0': { k = k*10+0; break;}
 default:{ i--; printf("NO"); }
}
}

return k;
}

void Set_Fan(unsigned char num, unsigned char status)   //Устанавливает статус куллера num - номер куллера, status - вкл/выкл
{    
switch (num)
{
        case 1:
        {
        if (status == Off)
                {
                PORTD.2=Off;
                Fan1_Status=Off;
                } else
                {
                PORTD.2=On;
                Fan1_Status=On;
                } 
        break;
        }
        case 2:
        {
        if (status == Off)
                {
                PORTD.3=Off;
                Fan2_Status=Off;
                } else
                {
                PORTD.3=On;
                Fan2_Status=On;
                }
        break;
        }    
        case 3:
        {
        if (status == Off)
                {
                PORTD.4=Off;
                Fan3_Status=Off;
                } else
                {
                PORTD.4=On;
                Fan3_Status=On;
                }
        break;
        }
 
}  

}

void Set_PWM_Value(unsigned char num, unsigned  int PWM)//Устанавливает величину ШИМ нагревателя num - номер нагревателя, PWM - величина ШИМ 
{    
switch (num)
{
case 1:
        {
        PWM1_Value=PWM;  
        OCR1AH=(unsigned char) (PWM1_Value>>8);
        OCR1AL=(unsigned char) (PWM1_Value);     
        break;
        }
case 2:
        {
        PWM2_Value=PWM;
        OCR1BH=(unsigned char) (PWM2_Value>>8);
        OCR1BL=(unsigned char) (PWM2_Value);
        break;}
}
}

unsigned char Get_Fan_Status(unsigned char num) // Возвращает статус куллера, num - номер куллера
{
switch (num)
{
        case 1:return Fan1_Status;
        case 2:return Fan2_Status;
        case 3:return Fan3_Status; 
 break;
}

}

unsigned int Get_PWM(unsigned char num)        // Возвращает величину ШИМ нагревателя, num - номер нагревателя
{
switch (num)
{
        case 1:return PWM1_Value;
        case 2:return PWM2_Value; 

}
}

unsigned char Get_Tmp(unsigned char num)       //Возвращает значение температуры термопары, num - номер термопары
{ 
switch (num)
{
        case 1:{Tmp1_Value=adc_data[0]; return Tmp1_Value;}
        case 2:{Tmp2_Value=adc_data[1]; return Tmp2_Value;}
        default:; 
break;
}
} 
                         

void UART(void)
{   
unsigned int buff=0;  
unsigned int buff1=0;
unsigned int buff2=0; 
unsigned int buff3=0; 
unsigned int f=0;    
unsigned int p=0;    
unsigned int t=0;    

if (rx_counter)
{
        buff = getchar();
        if (buff == '#')
        {                                      //Начало  приема команды
                                               
        buff1 = enterchar();                    // Определяем тип команды SET/GET
        switch (buff1) 
        {                        
                case 'S':
                 {                             // Определяем устанавливаемый параметр Fan/PWM
                 buff2 = enterchar();
                 switch (buff2)  
                   {
                        case 'F': { Set_Fan(((unsigned char) enterdata(1)),((unsigned char) enterdata(1))); printf("OK"); break;}
                        case 'P': { Set_PWM_Value(((unsigned char) enterdata(1)),(enterdata(4))); printf("OK"); break;} 
                        default:printf("NO"); 
                   } 
                 break;
                 } 
                 
                   
                 case 'G':                      // Определяем запрашиваемый параметр Fan/PWM/Tmp
                 {
                 buff3 = enterchar();
                 switch (buff3)  
                   {
                        case 'F': { f=enterdata(1); printf("F%d%d",f,Get_Fan_Status(f)); break;}
                        case 'P': { p=enterdata(1); printf("P%d%04d",p,Get_PWM(p)); break;}
                        case 'T': { t=enterdata(1); printf("T%d%03d",t,Get_Tmp(t));  break;}
                        default:printf("NO"); 
                   }
                  break;
                 }
            default:printf("NO");      
        }   
        }   else printf("NO");
} 
}  


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=T 
PORTB=0x00;
DDRB=0x06;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=P State5=P State4=P State3=T State2=T State1=P State0=P 
PORTC=0x73;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=T 
PORTD=0x00;
DDRD=0x1E;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;



// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 5120,000 kHz
// Mode: Ph. correct PWM top=03FFh
// OC1A output: Inverted
// OC1B output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xF3;
TCCR1B=0x01;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;   


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x20;



// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;


// ADC initialization
// ADC Clock frequency: 160,000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCD;
ADCSRA|=0x40;

// Global enable interrupts
#asm("sei")



Set_Fan(2,1);
Set_PWM_Value(1,1023);
Set_PWM_Value(2,1023);

while (1)
        {          
        
   UART(); 
        


        }
}