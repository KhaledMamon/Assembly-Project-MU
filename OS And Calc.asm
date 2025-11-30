
.model small        

.stack 100h         ; Reserve 256 bytes for the stack

.data
    ; --- Data Segment: Messages and Variables ---
    
    ; 0Dh, 0Ah = New Line 
    ; '$' = String terminator for DOS
    os_header       db '=================================', 0Dh, 0Ah
                    db '        DOOR OS v1.0 (x86)       ', 0Dh, 0Ah
                    db '=================================', 0Dh, 0Ah,
                    db 'Comment "help" for show all Comments', 0Dh, 0Ah, '$'
                    
    prompt          db 0Dh, 0Ah, 'Root@System:/> $' ; Command prompt string
    
    ; Help message displaying available commands
    msg_help        db 0Dh, 0Ah, '---------------- COMMANDS ----------------', 0Dh, 0Ah
                    db ' [1] clean  : Clear the screen', 0Dh, 0Ah
                    db ' [2] time : Show system time', 0Dh, 0Ah
                    db ' [3] date : Show system date', 0Dh, 0Ah
                    db ' [4] calc : Calculator (+,-,*,/)', 0Dh, 0Ah 
                    db ' [5] exit : Shut down system', 0Dh, 0Ah
                    db '------------------------------------------', 0Dh, 0Ah, '$'
                    
    msg_unknown     db 0Dh, 0Ah, 'Error: Unknown command. Type "help".', 0Dh, 0Ah, '$' ; Error message
    msg_bye         db 0Dh, 0Ah, 'Shutting down... Goodbye!', 0Dh, 0Ah, '$' ; Exit message
    
    msg_time        db 0Dh, 0Ah, 'Current Time: $'
    msg_date        db 0Dh, 0Ah, 'Current Date: $'
    separator       db ':$'  ; Separator for Time (HH:MM:SS)
    slash           db '/$'  ; Separator for Date (DD/MM/YY)

    ; --- Calculator Messages & Variables ---
    msg_calc_head   db 0Dh, 0Ah, '--- Simple Calculator ---', 0Dh, 0Ah, '$'
    msg_enter_n1    db 0Dh, 0Ah, 'Enter 1st Num (0-9): $'
    msg_enter_op    db 0Dh, 0Ah, 'Enter Op (+,-,*,/):  $'
    msg_enter_n2    db 0Dh, 0Ah, 'Enter 2nd Num (0-9): $'
    msg_res_txt     db 0Dh, 0Ah, 'Result = $'
    msg_err_div     db 0Dh, 0Ah, 'Error: Division by Zero!', 0Dh, 0Ah, '$'
    
    val1            db ?     ; Variable to store first number
    val2            db ?     ; Variable to store second number
    opr             db ?     ; Variable to store operator

    ; --- Input Buffer ---
    ; Structure for INT 21h, AH=0Ah
    input_buffer    db 10        ; Max characters allowed
                    db ?         ; Actual characters read
                    db 10 dup(0) ; Buffer to store input string
                    
    ; --- Command Strings for Comparison --- 

    cmd_help_str    db 'help'  , 0 
    cmd_clean_str   db 'clean' , 0
    cmd_exit_str    db 'exit'  , 0
    cmd_time_str    db 'time'  , 0
    cmd_date_str    db 'date'  , 0
    cmd_calc_str    db 'calc'  , 0 

.code
main proc           ; defult is NEAR --> because we use .model small
    ; Initialize Data Segment
    mov ax, @data   ; Load data segment address
    mov ds, ax      ; Move address to DS register

    ; 1. Clear Screen and Print Header at startup
    call clean_screen_proc ; Call clear screen procedure
    
    lea dx, os_header      ; Load header string address
    mov ah, 09h            
    int 21h                

; --- Main OS Loop ---
shell_loop: 

    ; 2. Print Prompt 
    lea dx, prompt    ;= Root@System:/>
    mov ah, 09h
    int 21h

    ; 3. Get User Input
    lea dx, input_buffer ; Load buffer address (command)
    mov ah, 0Ah          
    int 21h              

    ; 4. Prepare String for Comparison 
    ; INT 21h/0Ah doesn't add a null terminator, so we do it manually.
    lea bx, input_buffer + 1  ; Address containing actual length
    mov ch, 0
    mov cl, [bx]              ; Move length to CX
    cmp cl, 0                 ; Did user just press Enter?
    je shell_loop             ; If yes, restart loop
    
    lea bx, input_buffer + 2  ; Start of actual string
    add bx, cx                ; Move to end of string
    mov byte ptr [bx], 0      ; Add Null (0) terminator for stop read string

    ; 5. Compare input string with stored commands
    
    ; Check "help"
    lea si, input_buffer + 2  ; Source: User input
    lea di, cmd_help_str      ; Destination: "help" string
    call strcmp               ; Call string compare function
    je do_help                ; If equal, jump to help logic
    
    ; Check "clean"
    lea si, input_buffer + 2
    lea di, cmd_clean_str
    call strcmp
    je do_clean
    
    ; Check "exit"
    lea si, input_buffer + 2
    lea di, cmd_exit_str
    call strcmp
    je do_exit
    
    ; Check "time"
    lea si, input_buffer + 2
    lea di, cmd_time_str
    call strcmp
    je do_time
    
    ; Check "date"
    lea si, input_buffer + 2
    lea di, cmd_date_str
    call strcmp
    je do_date

    ; Check "calc"
    lea si, input_buffer + 2
    lea di, cmd_calc_str
    call strcmp
    je do_calc

    ; Unknown Command
    lea dx, msg_unknown   ;= Error: Unknown command. Type "help".
    mov ah, 09h
    int 21h
    jmp shell_loop ; Return to loop

; --- Command Execution ---
do_help:
    lea dx, msg_help
    mov ah, 09h
    int 21h
    jmp shell_loop

do_clean:
    call clean_screen_proc
    jmp shell_loop

do_exit:                   
    lea dx, msg_bye ;= Shutting down... Goodbye! 
    mov ah, 09h
    int 21h
    
    mov ah, 4ch    
    int 21h

do_time:
    lea dx, msg_time ;= Current Time:
    mov ah, 09h
    int 21h
    
    ; Get System Time
    mov ah, 2Ch     
    int 21h         ; Returns: CH=Hour, CL=Min, DH=Sec
    
    ; Print Hour
    mov al, ch
    call print_2digits
    
    lea dx, separator  ;= :
    mov ah, 09h
    int 21h
    
    ; Print Minute
    mov al, cl
    call print_2digits
    
    lea dx, separator
    mov ah, 09h
    int 21h
    
    ; Print Second
    mov al, dh
    call print_2digits
    
    jmp shell_loop

do_date:
    lea dx, msg_date   ;= Current Date:
    mov ah, 09h
    int 21h
    
    ; Get System Date
    mov ah, 2Ah
    int 21h  ; Returns: CX=Year, DH=Month, DL=Day
    
    push cx         ; Save Year to stack
    push dx
    
    ; Print Day
    mov al, dl
    call print_2digits  
    
    lea dx, slash     ;= /
    mov ah, 09h
    int 21h
    
    pop dx
    
    ; Print Month
    mov al, dh
    call print_2digits     
    
    lea dx, slash
    mov ah, 09h
    int 21h
    
    pop ax          ; Retrieve Year from stack
    
    ; Print Year (Simplified: Print last 2 digits)
    push ax         
    mov ah, 02h
    mov dl, '2'     
    int 21h
    mov dl, '0'     
    int 21h
    pop ax          ; Retrieve Year (2025)
    sub ax, 2000    ; Get last 2 digits (25)
    call print_2digits 

    jmp shell_loop

; -----------------------------------------------
;               Calculator Logic
; -----------------------------------------------
do_calc:
    ; Print Calculator Header
    lea dx, msg_calc_head
    mov ah, 09h
    int 21h

    ; 1. Request First Number
    lea dx, msg_enter_n1
    mov ah, 09h
    int 21h
    
    mov ah, 01h      ; Read character
    int 21h      
    
    sub al, 30h      ; Convert ASCII to Integer
    mov val1, al     ; Store first number

    ; 2. Request Operator
    lea dx, msg_enter_op
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    
    mov opr, al      ; Store operator

    ; 3. Request Second Number
    lea dx, msg_enter_n2
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    
    sub al, 30h      ; Convert ASCII to Integer
    mov val2, al

    ; 4. Print "Result ="
    lea dx, msg_res_txt
    mov ah, 09h
    int 21h

    ; 5. Execute Operation
    mov al, opr
    
    cmp al, '+'      
    je cal_add
    
    cmp al, '-'      
    je cal_sub
    
    cmp al, '*'      
    je cal_mul
    
    cmp al, '/'      
    je cal_div
    
    jmp shell_loop   ; Invalid operator, return to shell

cal_add:
    mov al, val1
    add al, val2
    call print_2digits
    jmp shell_loop

cal_sub:
    mov al, val1
    cmp al, val2
    jl sub_neg       ; If Result is negative, handle it
    
    sub al, val2
    call print_2digits
    jmp shell_loop

; Handle negative subtraction
sub_neg: 
    ; Print minus sign manually
    mov ah, 02h
    mov dl, '-'
    int 21h
    
    ; Reverse subtraction (val2 - val1)
    mov al, val2
    sub al, val1
    call print_2digits
    jmp shell_loop

cal_mul:
    mov al, val1
    mov bl, val2
    mul bl           ; Result in AX
    call print_2digits
    jmp shell_loop

cal_div:
    mov al, val2
    cmp al, 0        ; Check division by zero
    je div_zero_err  
    
    mov ah, 0        ; Clear AH
    mov al, val1
    mov bl, val2
    div bl           ; AL = Quotient, AH = Remainder
    call print_2digits 
    jmp shell_loop

div_zero_err:
    lea dx, msg_err_div
    mov ah, 09h
    int 21h
    jmp shell_loop

main endp ; End of Main Procedure

; -----------------------------------------------
;               HELPER PROCEDURES
; -----------------------------------------------

; Procedure to clear the screen
clean_screen_proc proc
    mov ax, 0003h ; clean screen
    int 10h
    ret
clean_screen_proc endp

; Procedure to compare two strings
; Inputs: SI (String 1), DI (String 2)
strcmp proc
    push ax       ; Save registers
    push cx
    push si
    push di
cmp_loop:
    mov al, [si]  ; Load char from string 1
    mov bl, [di]  ; Load char from string 2
    cmp al, bl    ; Compare chars
    jne done_cmp  ; Not equal? Jump

    cmp al, 0     ; End of string?
    je done_cmp   ; Equal? Jump
    inc si        ; Next char
    inc di
    jmp cmp_loop                                      
done_cmp:
    pop di        ; Restore registers
    pop si
    pop cx
    pop ax
    ret
strcmp endp

; Procedure to print a 2-digit number
; Input: AL = Number to print
print_2digits proc
    push ax
    push bx
    push dx
    
    mov ah, 0     ; Clean AH for division
    mov bl, 10
    div bl        ; AL = Tens, AH = Units
    
    mov bx, ax    ; Save result in BX
    
    ; Print Tens digit
    mov ah, 02h
    mov dl, bl
    add dl, 30h   ; Convert to ASCII
    int 21h
    
    ; Print Units digit
    mov ah, 02h
    mov dl, bh
    add dl, 30h   ; Convert to ASCII
    int 21h
    
    pop dx
    pop bx
    pop ax
    ret
print_2digits endp

end main
