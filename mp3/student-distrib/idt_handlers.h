#ifndef IDT_HANDLERS_H
#define IDT_HANDLERS_H

void handle_divide_error();
void handle_debug();
void handle_NMI();
void handle_breakpoint();
void handle_overflow();
void handle_BOUND_range_exceeded();
void handle_invalid_opcode();
void handle_device_not_available();
void handle_double_fault();
void handle_coprocessor_segment_overrun();
void handle_invalid_TSS();
void handle_segment_not_present();
void handle_stack_fault();
void handle_general_protection();
void handle_page_fault();
void handle_FPU_floating_point();
void handle_alignment_check();
void handle_machine_check();
void handle_SIMD_floating_point();

/* temparary functions*/
void temp_sys_call();

#endif /* IDT_HANDLERS_H */
