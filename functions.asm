;
;
; �������
; C����� ���������� ������������ � EDX.
; � ������ ������ EDX �������� �������� SUCCESS (0),
; ����� - ����� ��������� �� ������.
;
;

; ������ ������������ �����
; ��������� ������������ � ���������� max_number
input_max_number:
	;������� ����-�����,
	;0 ���� ��� ��������� ����������
	enter 0, 1

	;�������� scanf
	push max_number
	push str_unsigned_int_format ;��. string_constants.asm
	call _scanf
	add esp, 8
	
	;��������
	mov eax, [max_number]
	cmp eax, MIN_MAX_NUMBER
	jb .number_too_little
	cmp eax, MAX_MAX_NUMBER
	ja .number_too_big
	jmp .success

	;�����
	.number_too_little:
		mov edx, str_error_max_num_too_little ;��. string_constants.asm
		jmp .return	
		
	.number_too_big:
		mov edx, str_error_max_num_too_big ;��. string_constants.asm
		jmp .return	

	.success:
		mov edx, SUCCESS
	
	.return:
		leave
		ret


; �������� ������ ��� ������� ������
; ���������, ��������� �� ������ ������, 
; ������������ � ���������� primes_pointer
allocate_flags_memory:
	enter 0, 1

	;�������� max_number+1 ����
	mov eax, [max_number]
	inc eax
	
	push eax
	call _malloc
	add esp, 4
	
	;��������
	cmp eax, 0
	je .fail
	mov [primes_pointer], eax
	
	;�������������
	mov byte [eax], 0
	mov byte [eax+1], 0
	
	cld
	mov edi, eax
	add edi, 2
	mov edx, [max_number]
	add edx, eax
	
	mov al, 1
	.write_true:
		stosb
		cmp edi, edx
		jb .write_true
	
	;�����
	jmp .success
	
	.fail:
		mov edx, str_error_malloc_failed ;��. string_constants.asm
		jmp .return
	
	.success:
		mov edx, SUCCESS
			
	.return:
		leave
		ret

; ���������� ������ �� ������� ������
free_flags_memory:
	enter 0, 1
	
	mov eax, [primes_pointer]
	push eax
	call _free
	add esp, 4
	
	leave
	ret
	
	
;����� ������� ����� � ������� ������ ����������
find_primes_with_eratosthenes_sieve:
	enter 8, 1
	
	mov eax, [primes_pointer]
	mov ebx, [max_number]
	
	mov [ebp-4], eax
	add eax, ebx
	inc eax
	mov [ebp-8], eax
	
	;����������� ��������� �����
	cld
	mov edx, 2 ;p = 2
	mov ecx, 2 ;��������� � = 2
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
			
			mov ecx, edx
			inc ecx
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
					mov edx, ecx
					dec edx
					mov ecx, 2
					jmp .strike_out_cycle			
	
	.return:
		leave
		ret
		

; ������� ������� �����
print_primes_sum:
	enter 0, 1

	cld
	mov eax, [primes_pointer]
	mov esi, eax
	add esi, 2 ;�������� �������� � ������, �� �������� ���� ����� 2

	mov edx, eax
	add edx, [max_number]
	inc edx

	mov ebx, 0
	mov edi, 0
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
	push str_unsigned_long_long_format ;��. string_constants.asm
	call _printf
	add esp, 12

	push str_cr_lf
	call _printf
	add esp, 4

	leave
	ret
