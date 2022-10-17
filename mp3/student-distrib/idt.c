#include "idt.h"
#include "lib.h"
#include "x86_desc.h"
#include "idt_handlers.h"

/* void init_idt()
* initialzie IDT by setting the numbers and entries to the registers
* Input: none
* Output:nono
* Return value: none
* Side effect: idt values changed
*/
void init_idt(){
    // first loop to set everything but offset
    int i;
    for(i=0; i<NUM_VEC; i++){
        idt[i].seg_selector=KERNEL_CS;
        idt[i].reserved4 =0 ;
        idt[i].reserved3 =1 ; //1-exception; 0-interrupt
        idt[i].reserved2 =1 ;
        idt[i].reserved1 =1 ;
        idt[i].size      =1 ;//size:1-32bits
        idt[i].reserved0 =0 ;
        idt[i].dpl       =0 ; //privilege level:for exception/interrupt handler set to 0
        idt[i].present   =0 ; //set to 1 after entry for use
  
    }

    //set entries using SET_IDT_ENTRY
    SET_IDT_ENTRY(idt[exception_devide],handle_divide_error);
    SET_IDT_ENTRY(idt[exception_debug],handle_debug);
    SET_IDT_ENTRY(idt[exception_NMI],handle_NMI);
    SET_IDT_ENTRY(idt[exception_breakpoint],handle_breakpoint);
    SET_IDT_ENTRY(idt[exception_overflow],handle_overflow);
    SET_IDT_ENTRY(idt[exception_exceed_range],handle_BOUND_range_exceeded);
    SET_IDT_ENTRY(idt[exception_opcode],handle_invalid_opcode);
    SET_IDT_ENTRY(idt[exception_device],handle_device_not_available);
    SET_IDT_ENTRY(idt[exception_double_fault],handle_double_fault);
    SET_IDT_ENTRY(idt[exception_overrun],handle_coprocessor_segment_overrun);
    SET_IDT_ENTRY(idt[exception_TSS],handle_invalid_TSS);
    SET_IDT_ENTRY(idt[exception_segment_not_present],handle_segment_not_present);
    SET_IDT_ENTRY(idt[exception_stack],handle_stack_fault);
    SET_IDT_ENTRY(idt[exception_protection],handle_general_protection);
    SET_IDT_ENTRY(idt[exception_page],handle_page_fault);
    SET_IDT_ENTRY(idt[exception_FPU_floating],handle_FPU_floating_point);
    SET_IDT_ENTRY(idt[exception_alignment],handle_alignment_check);
    SET_IDT_ENTRY(idt[exception_machine],handle_machine_check);
    SET_IDT_ENTRY(idt[exception_SIMD_floating],handle_SIMD_floating_point);
    for (i=0;i<15;i++){
        idt[i].present=1;
    }for (i=16;i<=19;i++){
        idt[i].present=1;
    }

    //deal with interrupt and system call
    //SET_IDT_ENTRY(idt[itrp_kbd],);
    idt[itrp_kbd].reserved3=0;
    idt[itrp_kbd].present=1;
    //SET_IDT_ENTRY(idt[itrp_rtc],);
    idt[itrp_rtc].reserved3=0;
    idt[itrp_rtc].present=1;
    SET_IDT_ENTRY(idt[syst_call],temp_sys_call);//for cp1
    //idt[i].reserved3 =0 ; 
    idt[syst_call].present=1;
    idt[syst_call].dpl=3;


}
