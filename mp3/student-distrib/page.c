#include "page.h"
PTE_T first_page_table[1024] __attribute__ ((aligned(4096))); 
PDE_T page_directory[1024] __attribute__((aligned(4096)));

void init_page(){
    uint32_t i;
    for(i=0;i<1024;i++){
        // init PDE 
        // first init without special positions
        page_directory[i].val=0; 
        //i=0 using a page table and i=1 for kernel
        if(i==0){  // 0-4MB using 4KB and 
            page_directory[i].P_K=1;
            page_directory[i].RW_K=1;
            page_directory[i].addr_K=((uint32_t)first_page_table)>>12; // put the pointer of PTE in to PDE
        }
        else if(i==1){ //4-8 MB for kernel
            page_directory[i].G_M=1;
            page_directory[i].RW_M=1;
            page_directory[i].P_M=1;
            page_directory[i].PS_M=1;
            page_directory[i].addr_M=1; // kernel starts at physical 4MB
        }
        first_page_table[i].val = (i * 0x1000)|2 ; // page_table[i].addr=i and set rw  
        if(i==0xB8){// video memory in 0-4MB
            first_page_table[i].P=1;
            first_page_table[i].G=1;
        }   
    }
    page_start();
}
void
page_start(){
    asm volatile(
	"movl %0, %%eax             ;"
	"movl %%eax, %%cr3          ;"

	"movl %%cr4, %%eax          ;"
	"orl $0x00000010, %%eax     ;"
	"movl %%eax, %%cr4          ;"

	"movl %%cr0, %%eax          ;"
	"orl $0x80000000, %%eax     ;"
	"movl %%eax, %%cr0          ;"
	:  
    : "r"(page_directory)
    : "eax" );
}
