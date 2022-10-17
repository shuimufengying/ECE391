#ifndef IDT_H
#define IDT_H

#define exception_devide 0x00
#define exception_debug 0x01
#define exception_NMI 0x02
#define exception_breakpoint 0x03
#define exception_overflow 0x04
#define exception_exceed_range 0x05
#define exception_opcode 0x06
#define exception_device 0x07
#define exception_double_fault 0x08
#define exception_overrun 0x09
#define exception_TSS 0x0A
#define exception_segment_not_present 0x0B
#define exception_stack 0x0C
#define exception_protection 0x0D
#define exception_page 0x0E
#define exception_FPU_floating 0x10
#define exception_alignment 0x11
#define exception_machine 0x12
#define exception_SIMD_floating 0x13

#define itrp_kbd 0x21
#define itrp_rtc 0x28
#define syst_call 0x80



//intialize IDT
extern void init_idt();


#endif /* IDT_H */
