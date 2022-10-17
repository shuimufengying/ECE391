# include "idt_handlers.h"
# include "lib.h"
# include "x86_desc.h"
/*void handle_divide_error
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_divide_error(){
    printf("DIVIDE EXCEPTION!\n");
    while(1);
}
/*void handle_debug
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_debug(){
    printf("DEBUG EXCEPTION!\n");
    while(1);
}
/*void handle_NMI
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_NMI(){
    printf("NMI EXCEPTION!\n");
    while(1);
}
/*void handle_breakpoint
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_breakpoint(){
    printf("BREAKPOINT EXCEPTION!\n");
    while(1);
}
/*void handle_overflow
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_overflow(){
    printf("OVERFLOW EXCEPTION!\n");
    while(1);
}
/*void handle_BOUND_range_exceeded
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_BOUND_range_exceeded(){
    printf("BOUND RANGE EXCEEDED EXCEPTION!\n");
    while(1);
}
/*void handle_invalid_opcode
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_invalid_opcode(){
    printf("INVALID OPCODE EXCEPTION!\n");
    while(1);
}
/*void handle_device_not_available
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_device_not_available(){
    printf("DEVICE NOT AVAILABLE EXCEPTION!\n");
    while(1);
}
/*void handle_double_fault
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_double_fault(){
    printf("DOUBLE FAULT EXCEPTION!\n");
    while(1);
}
/*void handle_coprocessor_segment_overrun
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_coprocessor_segment_overrun(){
    printf("COPROCESSOR SEGMENT OVERRUN EXCEPTION!\n");
    while(1);
}
/*void handle_invalid_TSS
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_invalid_TSS(){
    printf("INVALID TSS EXCEPTION!\n");
    while(1);
}
/*void handle_segment_not_present
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_segment_not_present(){
    printf("SEGMENT NOT PRESENT EXCEPTION!\n");
    while(1);
}
/*void handle_stack_fault
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_stack_fault(){
    printf("STACK FAULT EXCEPTION!\n");
    while(1);
}
/*void handle_general_protection
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_general_protection(){
    printf("GENERAL PROTECTION EXCEPTION!\n");
    while(1);
}
/*void handle_page_fault
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_page_fault(){
    printf("PAGE FAULT EXCEPTION!\n");
    while(1);
}
/*void handle_FPU_floating_point
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_FPU_floating_point(){
    printf("X87 FPU FLAOTING POINT EXCEPTION!\n");
    while(1);
}
/*void handle_alignment_check
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_alignment_check(){
    printf("ALIGNMENT CHECK EXCEPTION!\n");
    while(1);
}
/*void handle_machine_check
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_machine_check(){
    printf("MACHINE CEHCK EXCEPTION!\n");
    while(1);
}
/*void handle_SIMD_floating_point
* print exception and freeze using a while loop
* input:none
* output:print exception infomation
* return value: none
*/
void handle_SIMD_floating_point(){
    printf("SIMD FLOATING POITN EXCEPTION!\n");
    while(1);
}
//temparary to print a system call for cp1
void temp_sys_call(){
    printf("A SYSTEM CALL IS CALLED!\n");
    while(1);

}
