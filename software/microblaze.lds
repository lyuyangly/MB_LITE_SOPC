/* MicroBlaze Linker Script */

OUTPUT_FORMAT(elf32-microblaze)

/* Specify the default entry point to the program */

ENTRY(_start)


/* Define Memories in the system */

MEMORY
{
   MB_RAM : ORIGIN = 0x0, LENGTH = 8K
}

/* Define the sections, and where they are mapped in memory */

SECTIONS
{
	.vectors.reset 0x00000000 : {
		*(.vectors.reset)
	} 

	.vectors.sw_exception 0x00000008 : {
		*(.vectors.sw_exception)
	} 

	.vectors.interrupt 0x00000010 : {
		*(.vectors.interrupt)
	} 

	.vectors.hw_exception 0x00000020 : {
		*(.vectors.hw_exception)
	} 

	.text : {
	   *(.text)
	   *(.text.*)
	   *(.gnu.linkonce.t.*)
	} > MB_RAM

	.init : {
	   KEEP (*(.init))
	} > MB_RAM

	.fini : {
	   KEEP (*(.fini))
	} > MB_RAM

	.rodata : 
	{
	   __rodata_start = .;
	   *(.rodata)
	   *(.rodata.*)
	   *(.gnu.linkonce.r.*)
	   __rodata_end = .;
	} > MB_RAM

	.sdata2 : 
	{
	   . = ALIGN(8);
	   __sdata2_start = .;
	   *(.sdata2)
	   *(.sdata2.*)
	   *(.gnu.linkonce.s2.*)
	   . = ALIGN(8);
	   __sdata2_end = .;
	} > MB_RAM

	.sbss2 :
	{
	   __sbss2_start = .;
	   *(.sbss2)
	   *(.sbss2.*)
	   *(.gnu.linkonce.sb2.*)
	   __sbss2_end = .;
	} > MB_RAM

	.data : 
	{
	   . = ALIGN(4);
	   __data_start = .;
	   *(.data)
	   *(.data.*)
	   *(.gnu.linkonce.d.*)
	   __data_end = .;
	} > MB_RAM

	.got : 
	{
	   *(.got)
	} > MB_RAM

	.got1 : 
	{
	   *(.got1)
	} > MB_RAM

	.got2 : {
	   *(.got2)
	} > MB_RAM

	.ctors : 
	{
	   __CTOR_LIST__ = .;
	   ___CTORS_LIST___ = .;
	   KEEP (*crtbegin.o(.ctors))
	   KEEP (*(EXCLUDE_FILE(*crtend.o) .ctors))
	   KEEP (*(SORT(.ctors.*)))
	   KEEP (*(.ctors))
	   __CTOR_END__ = .;
	   ___CTORS_END___ = .;
	} > MB_RAM

	.dtors : 
	{
	   __DTOR_LIST__ = .;
	   ___DTORS_LIST___ = .;
	   KEEP (*crtbegin.o(.dtors))
	   KEEP (*(EXCLUDE_FILE(*crtend.o) .dtors))
	   KEEP (*(SORT(.dtors.*)))
	   KEEP (*(.dtors))
	   __DTOR_END__ = .;
	   ___DTORS_END___ = .;
	} > MB_RAM

	.eh_frame : 
	{
	   *(.eh_frame)
	} > MB_RAM

	.jcr : 
	{
	   *(.jcr)
	} > MB_RAM

	.gcc_except_table : 
	{
	   *(.gcc_except_table)
	} > MB_RAM

	.sdata : 
	{
	   . = ALIGN(8);
	   __sdata_start = .;
	   *(.sdata)
	   *(.sdata.*)
	   *(.gnu.linkonce.s.*)
	   __sdata_end = .;
	} > MB_RAM

	.sbss : 
	{
	   . = ALIGN(4);
	   __sbss_start = .;
	   *(.sbss)
	   *(.sbss.*)
	   *(.gnu.linkonce.sb.*)
	   . = ALIGN(8);
	   __sbss_end = .;
	} > MB_RAM

	.tdata : 
	{
	   __tdata_start = .;
	   *(.tdata)
	   *(.tdata.*)
	   *(.gnu.linkonce.td.*)
	   __tdata_end = .;
	} > MB_RAM

	.tbss : 
	{
	   __tbss_start = .;
	   *(.tbss)
	   *(.tbss.*)
	   *(.gnu.linkonce.tb.*)
	   __tbss_end = .;
	} > MB_RAM

	.bss : 
	{
		. = ALIGN(4);
		__bss_start = .;
		*(.bss)
		*(.bss.*)
		*(.gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end = .;
	} > MB_RAM

/* Generate Stack and Heap definitions */

	.heap : {
		. = ALIGN(8);
		_heap = .;
		_heap_start = .;
		. += _HEAP_SIZE;
		_heap_end = .;
	} > MB_RAM

	.stack : {
		_stack_end = .;
		. += _STACK_SIZE;
		. = ALIGN(8);
		_stack = .;
		__stack = _stack;
	} > MB_RAM

_end = .;
}

/* Stack Size defined here */
_TEXT_START_ADDR = 0x0;
_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0x100;
_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0x20;
_SDA_BASE_ = __sdata_start + ((__sbss_end - __sdata_start) / 2 );
_SDA2_BASE_ = __sdata2_start + ((__sbss2_end - __sdata2_start) / 2 );




