;
;
; ФУНКЦИИ
; Cтатус выполнения записывается в EDX.
; В случае успеха EDX содержит значение SUCCESS (0),
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
	add esp, 8
	
	;проверка
	mov eax, [max_number]
	cmp eax, MIN_MAX_NUMBER
	jb .number_too_little

	cmp eax, MAX_MAX_NUMBER
	ja .number_too_big
	jmp .success

	;выход
	.number_too_little:
		mov edx, str_error_max_num_too_little ;см. string_constants.asm
		jmp .return	
		
	.number_too_big:
		mov edx, str_error_max_num_too_big ;см. string_constants.asm
		jmp .return	

	.success:
		mov edx, SUCCESS
	
	.return:
		leave
		ret


; Выделить память для массива флагов
; Результат, указатель на массив флагов, 
; записывается в переменную primes_pointer
allocate_flags_memory:
	enter 0, 1

	;выделить max_number+1 байт
	mov eax, [max_number]
	inc eax
	
	push eax
	call _malloc
	add esp, 4
	
	;проверка
	cmp eax, 0
	je .fail
	mov [primes_pointer], eax
	
	;инициализация
	mov byte [eax], 0
	mov byte [eax+1], 0
	
	cld
	lea edi, [eax+2]
	mov edx, [max_number]
	add edx, eax
	
	mov al, 1
	.write_true:
		stosb
		cmp edi, edx
		jb .write_true
	
	;выход
	jmp .success
	
	.fail:
		mov edx, str_error_malloc_failed ;см. string_constants.asm
		jmp .return
	
	.success:
		mov edx, SUCCESS
			
	.return:
		leave
		ret

; Освободить память от массива флагов
free_flags_memory:
	enter 0, 1
	
	mov eax, [primes_pointer]
	push eax
	call _free
	add esp, 4
	
	leave
	ret
	
	
;Найти простые числа с помощью решета Эратосфена
find_primes_with_eratosthenes_sieve:
	enter 4, 1
	
	mov eax, [primes_pointer]
	mov ebx, [max_number]
	
	mov [ebp-4], eax
	lea eax, [ebx+1]
	
	;вычеркиваем составные числа
	cld
	mov edx, 2 ;p = 2
	mov ecx, 2 ;множитель с = 2
	.strike_out_cycle:
		;x = c*p
		mov eax, edx
		mov esi, edx
		mul ecx
		mov edx, esi
		
		cmp eax, ebx
		jbe .strike_out_number
		jmp .increase_p
		
		.strike_out_number:
			mov edi, [ebp-4]
			add edi, eax
			mov byte [edi], 0
			inc ecx ;c = c + 1
			jmp .strike_out_cycle
			
		.increase_p:
			mov esi, [ebp-4]
			add esi, edx
			inc esi
			
			lea ecx, [edx+1]
			.check_current_number:
				mov eax, ecx
				mul eax
				cmp eax, ebx
				ja .return
			
				lodsb
				inc ecx
				cmp al, 0
				jne .new_p_found
				jmp .check_current_number
			
				.new_p_found:
					lea edx, [ecx-1]
					mov ecx, 2
					jmp .strike_out_cycle			
	
	.return:
		leave
		ret
		

; Вывести простые числа
print_primes_sum:
	enter 0, 1

	cld
	mov eax, [primes_pointer]
	lea esi, [eax+2] ;начинаем проверку с адреса, по которому флаг числа 2

	lea edx, [eax+1]
	add edx, [max_number]

	xor ebx, ebx
	xor edi, edi
	mov ecx, 2
	.sum_cycle:
		lodsb
		cmp al, 0
		jne .sum
		jmp .check_finish
		.sum:
			add ebx, ecx
			adc edi, 0
		.check_finish:
			inc ecx
			cmp esi, edx
			jb .sum_cycle
			
	push edi
	push ebx
	push str_unsigned_long_long_format ;см. string_constants.asm
	call _printf
	add esp, 12

	push str_cr_lf
	call _printf
	add esp, 4

	leave
	ret
