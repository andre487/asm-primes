; форматы ввода-вывода
str_unsigned_int_format: db "%llu", 0

; сообщения для работы программы
str_msg_max_number: db "Max number: %llu", 0xD, 0xA, 0
str_msg_result: db "Result: %llu", 0xD, 0xA, 0
str_msg_input_number: db "Input max number [3,4294967294]: ", 0

; сообщения выхода
str_exit_success: db "Success!", 0xD, 0xA, 0
str_error_max_num_too_little: db "Max number is too little!", 0xD, 0xA, 0
str_error_max_num_too_big: db "Max number is too big!", 0xD, 0xA, 0
str_error_malloc_failed: db "Can't allocate memory!", 0xD, 0xA, 0
