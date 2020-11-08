	area    appcode ,code,readonly
	import printMsg1
	import printMsg2
	import printMsg3
	import printMsg4
	import printMsg5
	import printMsg4p
    export __main
    ENTRY
__main    FUNCTION
	
				
	VLDR.F32 S0,=1 ; for storing final value sum e^x  
	VLDR.F32 S1,=1; temperorary variable
	VLDR.F32 S6,=1; variable for factorail
	
	VLDR.F32 S4,=1; 
	VLDR.F32 S25,=0.5; threshold value check for logic high or low; used as case statement 
	
    MOV R10,#30; No of terms
	MOV R9,#1; count initialization
        
ANDGATE	BL printMsg1
	VLDR.F32 S7,=-0.1  ; substitute values as provided given in python file
	VLDR.F32 S8,=0.2
	VLDR.F32 S9,=0.2
	VLDR.F32 S10,=-0.2
	B compute
		
ORGATE	BL printMsg2
	VLDR.F32 S7,=-0.1  ;substitute values as provided given in python file
	VLDR.F32 S8,=0.7
	VLDR.F32 S9,=0.7
	VLDR.F32 S10,=-0.1
	B compute
		
NOTGATE	BL printMsg3
	VLDR.F32 S7,=0.5  ;substitute values as provided given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=0
	VLDR.F32 S10,=0.1
	B compute
		
NANDGATE	BL printMsg4
	VLDR.F32 S7,=0.6  ;substitute values as provided given in python file
	VLDR.F32 S8,=-0.8
	VLDR.F32 S9,=-0.8
	VLDR.F32 S10,=0.3
	B compute
		
NORGATE	BL printMsg5
	VLDR.F32 S7,=0.5  ;substitute values as provided given in python file
	VLDR.F32 S8,=-0.7
	VLDR.F32 S9,=-0.7
	VLDR.F32 S10,=0.1
	B compute
		
		
compute	BL Set1

Set1	MOV R0, #1; 1st input
			VMOV.F32 S16,R0; Shifting 1st input to fp register
			VCVT.F32.S32 S16,S16; converting 1st inputto signed fp number
			
			MOV R1, #0; 2ed input of logic gate
			VMOV.F32 S17, R1; Shifting 2ed input to fp register
			VCVT.F32.S32 S17,S17; converting 2ed input to signed fp number
			
			MOV R2, #0; 3ed input of logic gate
			VMOV.F32 S18,R2; Shifting 3ed input to fp 
			VCVT.F32.S32 S18,S18; converting 3ed input to signed fp
			B WEIGHT
			
Set2	MOV R0, #1; 
			VMOV.F32 S16,R0;
			VCVT.F32.S32 S16,S16; 
			MOV R1, #0; 
			VMOV.F32 S17, R1; 
			VCVT.F32.S32 S17,S17;
			MOV R2, #1; 
			VMOV.F32 S18,R2; 
			VCVT.F32.S32 S18,S18; 
			B WEIGHT
			
Set3	MOV R0, #1; 
			VMOV.F32 S16,R0; 
			VCVT.F32.S32 S16,S16; 
			MOV R1, #1; 
			VMOV.F32 S17, R1;
			VCVT.F32.S32 S17,S17; 
			MOV R2, #0; 
			VMOV.F32 S18,R2; 
			VCVT.F32.S32 S18,S18; 
			B WEIGHT
			
Set4	MOV R0, #1;
			VMOV.F32 S16,R0; 
			VCVT.F32.S32 S16,S16;
			MOV R1, #1;
			VMOV.F32 S17, R1; 
			VCVT.F32.S32 S17,S17; 
			MOV R2, #1; 
			VMOV.F32 S18,R2; 
			VCVT.F32.S32 S18,S18; 
			B WEIGHT

WEIGHT	VMUL.F32 S19,S7,S16;
					VMOV.F32 S22,S19
					VMUL.F32 S20,S8,S17
					VADD.F32 S22, S22, S20
					VMUL.F32 S21,S9,S18
					VADD.F32 S22, S22, S21
					VADD.F32 S22, S22, S10; Final value is computed and stored in S22		
					B exp
				
exp   CMP R9,R10; 	cmp i and n
      BLE loop; 	
      B sigmoid_func;		
		
loop  VMUL.F32 S1,S1,S22; multiply terms
	  VMOV.F32 S3,S1;
      VMOV.F32 S5,R9; 	Moving from register R9 to floating register S5
      VCVT.F32.S32 S5, S5;	Converting to floating point number
		
	VMUL.F32 S6,S6,S5;	for factorial
    VDIV.F32 S3,S3,S6;	divide by factorial
    VADD.F32 S0,S0,S3;	Final result
		
    ADD R9,R9,#1;	Increment count
    B exp;	

sigmoid_func 
	VADD.F32 S14,S4,S0 ;	Calculating (1 + e^x)
	VDIV.F32 S15,S0,S14;	Calculating value of sigmoid (e^x/(1+e^x))
	VCMP.F32 S15,S25;	Compare with 0.5 
	VMRS.F32 APSR_NZCV, FPSCR
	ITE HI
	MOVHI R3,#1
	MOVLS R3,#0
	BL printMsg4p
	
	
	MOV R9,#1
	VLDR.F32 S0,=1 ; Used to store the final sum of the exponent(e^x)  
	VLDR.F32 S1,=1; Temp variable to store intermediate multiplication result
	VLDR.F32 S6,=1; Temp variable to store the result of the factorial

	;Iterations for inputs
	ADD R4, R4,#1
	CMP R4,#1
	BEQ Set2
	CMP R4,#2
	BEQ Set3
	CMP R4,#3
	BEQ Set4
	MOV R4,#0
	ADD R5, R5,#1
	
; for LOGIC GATES
	CMP R5,#1 
	BEQ ORGATE

	CMP R5,#2	
	BEQ NOTGATE

	CMP R5,#3	
	BEQ NANDGATE

	CMP R5,#4	
	BEQ NORGATE

	B stop
		
stop    B stop
        ENDFUNC
        END
