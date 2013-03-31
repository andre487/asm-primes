;
;
; �������
; ��������� ������������ � EAX, ������ - � EDX.
; � ������ ������ EDX �������� �������� SUCCESS (0),
; ����� - ����� ��������� �� ������.
;
;

; ������ ������������ �����
; ���������: EAX - ������������ �����
input_max_number:	
	;������� ����-�����,
	;4 ����� ��� ��������� ����������
	enter 4, 1

	;���������� �������
	push str_max_number_label ;��. string_constants.asm
	call _printf
	add esp, 4

	;�������� scanf
	mov eax, ebp
	sub eax, 4
	
	push eax
	push str_max_number_input_format ;��. string_constants.asm
	call _scanf
	add esp, 8
	
	mov eax, [ebp-4]

	;��������
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
		push eax
		push str_max_number_output_format ;��. string_constants.asm
		call _printf
		add esp, 4
		pop eax
		mov edx, SUCCESS
	
	.return:
		leave
		ret


; �������� ������ ��� ������� ������
; ��������: EAX - ������������ �����
; ���������: EAX - ��������� �� ������
allocate_flags_memory:
	enter 8, 1

	;�������� EAX+1 ����
	inc eax
	mov [ebp-4], eax
	
	push eax
	call _malloc
	add esp, 4
	
	;��������
	cmp eax, 0
	je .fail
	mov [ebp-8], eax
	
	;�������������
	mov byte [eax], 0
	
	cld
	mov edi, eax
	inc edi
	mov edx, [ebp-4]
	add edx, eax
	
	mov al, 1
	.write_true:
		stosb
		cmp edi, edx
		jb .write_true
	
	;�����
	mov eax, [ebp-8]
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
; ��������: EAX - ��������� �� ������
free_flags_memory:
	enter 0, 1
	
	push eax
	call _free
	add esp, 4
	
	leave
	ret
	
	
;����� ������� ����� � ������� ������ ����������
;���������: EAX - ��������� �� ������ ������, EBX - ������������ �����	
find_primes_with_eratosthenes_sieve:
	enter 8, 1
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
		push edx
		mul ecx
		pop edx
		
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
; ���������: EAX - ��������� �� ������ ������, EBX - ������������ �����
print_primes:
	enter 12, 1
	mov [ebp-4], eax
	mov [ebp-8], ebx
	
	push str_print_primes_label
	call _printf
	add esp, 4
	
	cld
	mov esi, [ebp-4]
	mov edx, esi
	add edx, [ebp-8]
	inc edx
	
	mov [ebp-12], edx
	mov ecx, 0
	.print_cycle:
		lodsb
		cmp al, 0
		jne .print
		jmp .check_finish
		.print:
			push esi
			push ecx
			push str_prime ;��. string_constants.asm
			call _printf
			add esp, 4
			pop ecx
			pop esi
			mov edx, [ebp-12]
		.check_finish:
			inc ecx
			cmp esi, edx
			jb .print_cycle
			
	push str_cr_lf
	call _printf
	add esp, 4
			
	leave
	ret
