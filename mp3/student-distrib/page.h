#ifndef _PAGE_H
#define _PAGE_H
#include "x86_desc.h"
#include "lib.h"/*
void PDE_KB_SET();
void PDE_MB_SET();
void PTE_SET();*/
void init_page();
void page_start();
//void loadPageDirectory();
//void enablePaging();
typedef struct PDE
{   
    union{
    uint32_t val;
    struct { //page directory entry 4MB | see picture in https://wiki.osdev.org/Paging 
        uint32_t P_M    :1; //0 present
        uint32_t RW_M   :1 ; //1 read write
        uint32_t US_M   :1; //2 user superviosor
        uint32_t PWT_M  :1; //3 write through
        uint32_t PCD_M  :1; //4 cash_disable
        uint32_t A_M    :1;   //5 accessed
        uint32_t D_M    :1; //AVL 6 dirty
        uint32_t PS_M   :1; // 7 page size
        uint32_t G_M    :1; // 8 global
        uint32_t AVL_M  :3; // 9-11 available for user
        uint32_t PAT_M  :1; // 12 page table aindex
        uint32_t B39_M  :8; // 13-20  
        uint32_t RV_M   :1; // 21 reserved
        uint32_t addr_M :10; // 22-31 
    } __attribute__((packed)); 
    struct {//page directory entry 4KB | see picture in https://wiki.osdev.org/Paging 
        uint32_t P_K    :1; //0
        uint32_t RW_K   :1 ; //1
        uint32_t US_K   :1; //2
        uint32_t PWT_K  :1; //3
        uint32_t PCD_K  :1; //4
        uint32_t A_K    :1;   //5
        uint32_t D_K    :1; //AVL 6
        uint32_t PS_K   :1; // 7
        uint32_t G_K    :1; // 8
        uint32_t AVL_K  :3; // 9-11
        uint32_t addr_K :20; // 22-31
    } __attribute__((packed)); 
    };
}PDE_T;

typedef struct PTE
{  union{
    uint32_t val;
    struct{
    uint32_t P   :1; //0
    uint32_t RW  :1; //1
    uint32_t US  :1; //2
    uint32_t PWT :1; //3
    uint32_t PCD :1; //4
    uint32_t A   :1;   //5
    uint32_t D   :1; //AVL 6
    uint32_t PAT :1; // 7
    uint32_t G   :1; //8
    uint32_t AVL :3; // 9-11
    uint32_t addr :20; // 12-31
    }__attribute__((packed)); 
};
} PTE_T;
PTE_T user_page_table[1024]__attribute__ ((aligned(4096))); 
PTE_T first_page_table[1024] __attribute__ ((aligned(4096))); 
PDE_T page_directory[1024] __attribute__((aligned(4096)));

#endif /* _PAGE_H */


