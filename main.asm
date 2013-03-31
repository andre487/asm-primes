%define SUCCESS 0
%define MIN_MAX_NUMBER 3
%define MAX_MAX_NUMBER 4294967294

global _main
extern _printf
extern _scanf
extern _malloc
extern _free

SECTION .text 
align 4
_main:
	enter 0, 0
	
	;���� ������������� �����
	call input_max_number
	cmp edx, SUCCESS
	jne .custom_exit
	
	;�������� ������ ��� ������� ������
	call allocate_flags_memory
	cmp edx, SUCCESS
	jne .custom_exit
	
	;������� ��������� �����
	call find_primes_with_eratosthenes_sieve
	
	;������� �����
	call print_primes_sum
	
	;���������� ������ �� ������� ������
	call free_flags_memory
	
	;�����
	.success:
		push str_exit_success
		call _printf
		jmp .return
			
	.custom_exit:
		push edx
		call _printf
		
	.return:
		mov eax, SUCCESS
		leave
		ret
	
	%include "functions.asm"

SECTION .data
	align 4
	max_number: dd 0
	primes_pointer: dd 0
	
	%include "string_constatns.asm"
