;
; ФУНКЦИИ
; Cтатус выполнения записывается в rdx.
; В случае успеха rdx содержит значение SUCCESS (0),
; инчае - адрес сообщения об ошибке.
;

; Ввести максимальное число
; Результат записывается в переменную max_number
input_max_number:
	; создать стек-фрейм,
	; 0 байт для локальных переменных
	enter 0, 1

	; приглашение ко вводу максимального числа
	lea rdi, [rel str_msg_input_number]
	push rbx
	call _printf
	pop rbx

	; вызываем scanf
	lea rdi, [rel str_unsigned_int_format] ; см. string_constants.asm
	lea rsi, [rel max_number]
	push rbx ; выравнивание стека
	call _scanf
	pop rbx

	jo .number_too_big

	; проверка
	mov rax, [rel max_number]
	cmp rax, MIN_MAX_NUMBER
	jb .number_too_little

	cmp rax, MAX_MAX_NUMBER
	ja .number_too_big

	jmp .success

	; выход
	.number_too_little:
		lea rdx, [rel str_error_max_num_too_little] ; см. string_constants.asm
		jmp .return

	.number_too_big:
		lea rdx, [rel str_error_max_num_too_big] ; см. string_constants.asm
		jmp .return

	.success:
		lea rdi, [rel str_msg_max_number]
		mov rsi, [rel max_number]
		push rbx
		call _printf
		pop rbx

		mov rdx, SUCCESS

	.return:
		leave
		ret


; Выделить память для массива флагов
; Результат, указатель на массив флагов,
; записывается в переменную primes_pointer
allocate_flags_memory:
	enter 0, 1

	; выделить max_number+1 байт
	mov rdi, [rel max_number]
	inc rdi

	push rbx
	call _malloc
	pop rbx

	; проверка
	cmp rax, 0
	je .fail
	mov [rel primes_pointer], rax

	; инициализация
	mov byte [rax], 0
	mov byte [rax+1], 0

	cld
	lea rdi, [rel rax+2]
	mov rdx, [rel max_number]
	add rdx, rax

	mov al, 1
	.write_true:
		stosb
		cmp rdi, rdx
		jb .write_true

	; выход
	jmp .success

	.fail:
		lea rdx, [rel str_error_malloc_failed] ; см. string_constants.asm
		jmp .return

	.success:
		mov rdx, SUCCESS

	.return:
		leave
		ret


; Освободить память от массива флагов
free_flags_memory:
	enter 0, 1

	mov rdi, [rel primes_pointer]
	push rbx
	call _free
	pop rbx

	leave
	ret


; Найти простые числа с помощью решета Эратосфена
find_primes_with_eratosthenes_sieve:
	enter 8, 1

	mov rax, [rel primes_pointer]
	mov rbx, [rel max_number]

	mov [rel rbp-8], rax
	lea rax, [rel rbx+1] ; адрес останова

	; вычеркиваем составные числа
	cld
	mov rdx, 2 ; p = 2
	mov rcx, 2 ; множитель с = 2
	.strike_out_cycle:
		; x = c * p
		mov rax, rdx
		mov rsi, rdx
		mul rcx
		mov rdx, rsi

		cmp rax, rbx
		jbe .strike_out_number
		jmp .increase_p

		.strike_out_number:
			mov rdi, [rel rbp-8]
			add rdi, rax
			mov byte [rel rdi], 0
			inc rcx ; c = c + 1
			jmp .strike_out_cycle

		.increase_p:
			mov rsi, [rel rbp-8]
			add rsi, rdx
			inc rsi

			lea rcx, [rel rdx+1]
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
	mov rax, [rel primes_pointer]
	lea rsi, [rel rax+2] ; начинаем проверку с адреса, по которому флаг числа 2

	lea rdx, [rel rax+1]
	add rdx, [rel max_number]

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

	lea rdi, [rel str_msg_result] ; см. string_constants.asm
	mov rsi, rbx
	push rbx
	call _printf
	pop rbx

	leave
	ret
