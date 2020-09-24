; Copyright (c) 2015-2019, Satoshi Tanda. All rights reserved.
; Use of this source code is governed by a MIT-style license that can be
; found in the LICENSE file.

;
; This module implements all assembler code
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; constants
;
.CONST

VMX_OK                      EQU     0
VMX_ERROR_WITH_STATUS       EQU     1
VMX_ERROR_WITHOUT_STATUS    EQU     2
KTRAP_FRAME_SIZE            EQU     190h
MACHINE_FRAME_SIZE          EQU     28h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; macros
;

; Saves all general purpose registers to the stack
PUSHAQ MACRO
    push    rax
    push    rcx
    push    rdx
    push    rbx
    push    -1      ; dummy for rsp
    push    rbp
    push    rsi
    push    rdi
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
ENDM

; Loads all general purpose registers from the stack
POPAQ MACRO
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rdi
    pop     rsi
    pop     rbp
    add     rsp, 8    ; dummy for rsp
    pop     rbx
    pop     rdx
    pop     rcx
    pop     rax
ENDM

; Dumps all general purpose registers and a flag register.
ASM_DUMP_REGISTERS MACRO
    pushfq
    PUSHAQ                      ; -8 * 16
    mov rcx, rsp                ; all_regs
    mov rdx, rsp
    add rdx, 8*17               ; stack_pointer

    sub rsp, 28h                ; 28h for alignment
    call UtilDumpGpRegisters    ; UtilDumpGpRegisters(all_regs, stack_pointer);
    add rsp, 28h

    POPAQ
    popfq
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; implementations
;
.CODE 

; unsigned char __stdcall AsmVmxCall(_In_ ULONG_PTR hypercall_number,
;                                    _In_opt_ void *context);
AsmVmxCall PROC
    vmcall                  ; vmcall(hypercall_number, context)
    jz errorWithCode        ; if (ZF) jmp
    jc errorWithoutCode     ; if (CF) jmp
    xor rax, rax            ; return VMX_OK
    ret

errorWithoutCode:
    mov rax, VMX_ERROR_WITHOUT_STATUS
    ret

errorWithCode:
    mov rax, VMX_ERROR_WITH_STATUS
    ret
AsmVmxCall ENDP



PURGE PUSHAQ
PURGE POPAQ
PURGE ASM_DUMP_REGISTERS
END
