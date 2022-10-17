#include "tests.h"
#include "x86_desc.h"
#include "lib.h"
#include "idt.h"
#include "page.h"
#define PASS 1
#define FAIL 0

/* format these macros as you see fit */
#define TEST_HEADER 	\
	printf("[TEST %s] Running %s at %s:%d\n", __FUNCTION__, __FUNCTION__, __FILE__, __LINE__)
#define TEST_OUTPUT(name, result)	\
	printf("[TEST %s] Result = %s\n", name, (result) ? "PASS" : "FAIL");

static inline void assertion_failure(){
	/* Use exception #15 for assertions, otherwise
	   reserved by Intel */
	asm volatile("int $15");
}


/* Checkpoint 1 tests */

/* IDT Test - Example
 * 
 * Asserts that first 10 IDT entries are not NULL
 * Inputs: None
 * Outputs: PASS/FAIL
 * Side Effects: None
 * Coverage: Load IDT, IDT definition
 * Files: x86_desc.h/S
 */
/*int idt_test(){
	TEST_HEADER;

	int i;
	int result = PASS;
	for (i = 0; i < 10; ++i){
		if ((idt[i].offset_15_00 == NULL) && 
			(idt[i].offset_31_16 == NULL)){
			assertion_failure(); 
			result = FAIL;
		}
	}

	return result;
}*/
void test_page_fault(){
	int *ptr=(int*)0x00;
	int val;
	val=ptr[0];
}
int page_test(){
	TEST_HEADER;
	int i;
	int result = PASS;

	/* test margin of page -- should pass without page fault */
	int val;
	int* ptr = (int*)0x400000;	/* the margin of PD */
	ptr[0] = 1;
	val = ptr[0];
	/* check the value of the entry of the tables */
	// first, check whether the first two exist 
	if (page_directory[0].P_K == 0 || page_directory[1].P_M == 0 ){
		printf ("PDE 1 OR 0 NOT PRESENT\n");
		result = FAIL;
	}

	// then, check whether the other not present and present at the video memory
	for(i = 0; i < 1024; i++){				// 1024 is the entry number
		if(page_directory[i].P_M == 1 && i > 1){
			printf ("PDE wrongly PRESENT\n");
			result = FAIL;
		}
		if(first_page_table[i].P == 1 && i != 0xB8000 >> 12 ){		//  0xB8000 >> 12 is ithe index where the page table should present
			printf ("PTE wrongly PRESENT\n");
			result = FAIL;
		}
		if (first_page_table[i].P == 0 && i == 0xB8000 >> 12){ 		// 0xB8000 >> 12 is ithe index where the page table should present
			printf ("PTE no PRESENT\n");
			result = FAIL;
		} 
	}
	return result;
}

int page_test1() {
	TEST_HEADER;
	uint8_t* page_ptr = (uint8_t*)(0xB8000);
	// uint32_t* page_ptr = &file_sys_addr;
	uint32_t a;
	a = *page_ptr;
	// printf(" addr=%x\n", file_sys_addr);
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD RETURN PASS
 */
int page_test2() {
	uint8_t* page_ptr = (uint8_t*)(0xB8FFF);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD RETURN PASS
 */
int page_test3() {
	uint8_t* page_ptr = (uint8_t*)(0x400000);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD RETURN PASS
 */
int page_test4() {
	uint8_t* page_ptr = (uint8_t*)(0x7FFFFF);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD INVOKE EXCEPTION
 */
int page_test5() {
	uint8_t* page_ptr = (uint8_t*)(0xB8000- 1);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD INVOKE EXCEPTION
 */
int page_test6() {
	uint8_t* page_ptr = (uint8_t*)(0xB8FFF + 1);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
/*
 * test boundary at VIDEO_MEM
 * 	-return PASS on valid dereference
 *	-throw PAGE FAULT exception on invalid
 * SHOULD INVOKE EXCEPTION
 */
int page_test7() {
	uint8_t* page_ptr = (uint8_t*)(0x7FFFFF + 1);
	uint8_t a;
	a = *page_ptr;
	return PASS;
}
// add more tests here

/* divide zero test
 * 
 * test if reporting when divided by 0
 * Inputs: None
 * Outputs: PASS/FAIL
 * Side Effects: None
 * Coverage: Load IDT, IDT definition
 * Files: x86_desc.h/S
 */
int idt_test(){
	TEST_HEADER;
	int i=1;
	int j=0;
	int result;
	
	result = i/j;

	return result;
	
}

/* Checkpoint 2 tests */
/* Checkpoint 3 tests */
/* Checkpoint 4 tests */
/* Checkpoint 5 tests */


/* Test suite entry point */
void launch_tests(){
	test_page_fault();
	//page_test();
	//TEST_OUTPUT("idt_test", idt_test());
	// launch your tests here
}
