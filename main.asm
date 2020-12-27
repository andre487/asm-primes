%define SUCCESS 0
%define MIN_MAX_NUMBER 3
%define MAX_MAX_NUMBER 4294967294

global _main
extern _printf
extern _scanf
extern _malloc
extern _free

SECTION .text
_main:
	enter 0, 0

	; ввод максимального числа
	call input_max_number
	cmp rdx, SUCCESS
	jne .custom_exit

	; выделяем память для массива флагов
	call allocate_flags_memory
	cmp rdx, SUCCESS
	jne .custom_exit

	; отсеять составные числа
	call find_primes_with_eratosthenes_sieve

	; вывести числа
	call print_primes_sum

	; освободить память от массива флагов
	call free_flags_memory

	; выход
	.success:
		lea rdi, [rel str_exit_success]
		call _printf

		jmp .return

	.custom_exit:
		lea rdi, [rel rdx]
		call _printf

	.return:
		mov rax, SUCCESS
		leave
		ret

	%include "functions.asm"

SECTION .data
	max_number: dd qword 0
	primes_pointer: dd qword 0

	%include "string_constatns.asm"
