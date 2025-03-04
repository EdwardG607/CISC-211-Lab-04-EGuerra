/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Edward Guerra Ramirez"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
.align

    
/* Tell the assembler that what follows is in instruction memory    */
.text
.align


    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/

    /* Load memory values */
    LDR r1, =balance         /* Loads address of balance */
    LDR r2, [r1]             /* Loads value of balance into r2 */
    LDR r3, =transaction     /* Loads address of transaction */
    LDR r4, =we_have_a_problem /* Loads address of we_have_a_problem */
    LDR r5, =eat_out         /* Loads address of eat_out */
    LDR r6, =stay_in         /* Loads address of stay_in */
    LDR r7, =eat_ice_cream   /* Loads address of eat_ice_cream */

/* Set output variables to 0 */
    MOV r8, #0
    STR r8, [r3]             /* transaction = 0 */
    STR r8, [r4]             /* we_have_a_problem = 0 */
    STR r8, [r5]             /* eat_out = 0 */
    STR r8, [r6]             /* stay_in = 0 */
    STR r8, [r7]             /* eat_ice_cream = 0 */

/* Store transaction value */
    STR r0, [r3]             /* transaction = r0 */

/* Check if transaction > 1000 */
    CMP r0, #1000
    BGT invalid_transaction

/* Check if transaction < -1000 */
    CMP r0, #-1000
    BLT invalid_transaction

/* Calculate tmpBalance = balance + transaction */
    ADDS r8, r2, r0          /* r8 = balance + transaction */
    BVS overflow_case        /* If overflow occurs, jump to handling */

/* Store new balance */
    STR r8, [r1]             /* balance = tmpBalance */

/* Determine output flags */
    CMP r8, #0
    BGT set_eat_out
    BLT set_stay_in

/* If balance == 0 */
    MOV r9, #1
    STR r9, [r7]             /* eat_ice_cream = 1 */
    B finalize

set_eat_out:
    MOV r9, #1
    STR r9, [r5]             /* eat_out = 1 */
    B finalize

set_stay_in:
    MOV r9, #1
    STR r9, [r6]             /* stay_in = 1 */
    B finalize

overflow_case:
    MOV r9, #1
    STR r9, [r4]             /* we_have_a_problem = 1 */
    MOV r8, #0
    STR r8, [r3]             /* transaction = 0 */
    B finalize

invalid_transaction:
    MOV r9, #1
    STR r9, [r4]             /* we_have_a_problem = 1 */
    B finalize

finalize:
    LDR r0, [r1]             /* r0 = balance */
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




