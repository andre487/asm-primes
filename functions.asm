;
;
; ФУНКЦИИ
; Cтатус выполнения записывается в rdx.
; В случае успеха rdx содержит значение SUCCESS (0),
; инчае - адрес сообщения об ошибке.
;
;

; Ввести максимальное число
; Результат записывается в переменную max_number
input_max_number:
	;создать стек-фрейм,
	;0 байт для локальных переменных
	enter 0, 1

	;вызываем scanf
	push max_number
	push str_unsigned_int_format ;см. string_constants.asm
	call _scanf
	add rsp, 8

	;проверка
	mov rax, [max_number]
	cmp rax, MIN_MAX_NUMBER
	jb .number_too_little

	cmp rax, MAX_MAX_NUMBER
	ja .number_too_big
	jmp .success

	;выход
	.number_too_little:
		mov rdx, str_error_max_num_too_little ;см. string_constants.asm
		jmp .return

	.number_too_big:
		mov rdx, str_error_max_num_too_big ;см. string_constants.asm
		jmp .return

	.success:
		mov rdx, SUCCESS

	.return:
		leave
		ret


; Выделить память для массива флагов
; Результат, указатель на массив флагов,
; записывается в переменную primes_pointer
allocate_flags_memory:
	enter 0, 1

	;выделить max_number+1 байт
	mov rax, [max_number]
	inc rax

	push rax
	call _malloc
	add rsp, 4

	;проверка
	cmp rax, 0
	je .fail
	mov [primes_pointer], rax

	;инициализация
	mov byte [rax], 0
	mov byte [rax+1], 0

	cld
	lea rdi, [rax+2]
	mov rdx, [max_number]
	add rdx, rax

	mov al, 1
	.write_true:
		stosb
		cmp rdi, rdx
		jb .write_true

	;выход
	jmp .success

	.fail:
		mov rdx, str_error_malloc_failed ;см. string_constants.asm
		jmp .return

	.success:
		mov rdx, SUCCESS

	.return:
		leave
		ret

; Освободить память от массива флагов
free_flags_memory:
	enter 0, 1

	mov rax, [primes_pointer]
	push rax
	call _free
	add rsp, 4

	leave
	ret


;Найти простые числа с помощью решета Эратосфена
find_primes_with_eratosthenes_sieve:
	enter 4, 1

	mov rax, [primes_pointer]
	mov rbx, [max_number]

	mov [rbp-4], rax
	lea rax, [rbx+1]

	;вычеркиваем составные числа
	cld
	mov rdx, 2 ;p = 2
	mov rcx, 2 ;множитель с = 2
	.strike_out_cycle:
		;x = c*p
		mov rax, rdx
		mov rsi, rdx
		mul rcx
		mov rdx, rsi

		cmp rax, rbx
		jbe .strike_out_number
		jmp .increase_p

		.strike_out_number:
			mov rdi, [rbp-4]
			add rdi, rax
			mov byte [rdi], 0
			inc rcx ;c = c + 1
			jmp .strike_out_cycle

		.increase_p:
			mov rsi, [rbp-4]
			add rsi, rdx
			inc rsi

			lea rcx, [rdx+1]
			.check_current_number:
				mov rax, rcx
				mul rax
				cmp rax, rbx
				ja .return

				lodsb
				inc rcx
				cmp al, 0
				jne .new_p_found
				jmp .check_current_number

				.new_p_found:
					lea rdx, [rcx-1]
					mov rcx, 2
					jmp .strike_out_cycle

	.return:
		leave
		ret


; Вывести простые числа
print_primes_sum:
	enter 0, 1

	cld
	mov rax, [primes_pointer]
	lea rsi, [rax+2] ;начинаем проверку с адреса, по которому флаг числа 2

	lea rdx, [rax+1]
	add rdx, [max_number]

	xor rbx, rbx
	xor rdi, rdi
	mov rcx, 2
	.sum_cycle:
		lodsb
		cmp al, 0
		jne .sum
		jmp .check_finish
		.sum:
			add rbx, rcx
			adc rdi, 0
		.check_finish:
			inc rcx
			cmp rsi, rdx
			jb .sum_cycle

	push rdi
	push rbx
	push str_unsigned_long_long_format ;см. string_constants.asm
	call _printf
	add rsp, 12

	push str_cr_lf
	call _printf
	add rsp, 4

	leave
	ret
