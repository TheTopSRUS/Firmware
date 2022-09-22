
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

char rx_buffer[100];

unsigned char rx_wr_index,rx_rd_index,rx_counter;

bit rx_buffer_overflow;

interrupt [12] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer[rx_wr_index]=data;
if (++rx_wr_index == 100) rx_wr_index=0;
if (++rx_counter == 100)
{
rx_counter=0;
rx_buffer_overflow=1;
};
};
}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 100) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned char adc_data[3-2+1];

interrupt [15] void adc_isr(void)
{
static unsigned char input_index=0;

adc_data[input_index]=ADCH;

if (++input_index > (3-2))
input_index=0;
ADMUX=(2 | (0x20 & 0xff))+input_index;

delay_us(10);

ADCSRA|=0x40;
}

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

void Set_Fan(unsigned char num, unsigned char status)   
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

void Set_PWM_Value(unsigned char num, unsigned  int PWM)
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

unsigned char Get_Fan_Status(unsigned char num) 
{
switch (num)
{
case 1:return Fan1_Status;
case 2:return Fan2_Status;
case 3:return Fan3_Status; 
break;
}

}

unsigned int Get_PWM(unsigned char num)        
{
switch (num)
{
case 1:return PWM1_Value;
case 2:return PWM2_Value; 

}
}

unsigned char Get_Tmp(unsigned char num)       
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
{                                      

buff1 = enterchar();                    
switch (buff1) 
{                        
case 'S':
{                             
buff2 = enterchar();
switch (buff2)  
{
case 'F': { Set_Fan(((unsigned char) enterdata(1)),((unsigned char) enterdata(1))); printf("OK"); break;}
case 'P': { Set_PWM_Value(((unsigned char) enterdata(1)),(enterdata(4))); printf("OK"); break;} 
default:printf("NO"); 
} 
break;
} 

case 'G':                      
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

PORTB=0x00;
DDRB=0x06;

PORTC=0x73;
DDRC=0x00;

PORTD=0x00;
DDRD=0x1E;

TCCR0=0x00;
TCNT0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x00;   

UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x20;

ACSR=0x80;
SFIOR=0x00;

ADMUX=2 | (0x20 & 0xff);
ADCSRA=0xCD;
ADCSRA|=0x40;

#asm("sei")

Set_Fan(2,1);
Set_PWM_Value(1,1023);
Set_PWM_Value(2,1023);

while (1)
{          

UART(); 

}
}
