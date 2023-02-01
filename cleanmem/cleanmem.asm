    processor 6502

    seg code            ; Starting a segment of code
    org $F000           ; Start of this program in ROM cartridge

Start:                  ; This label is literally $F000 in memory
    sei                 ; Disable interrupts
    cld                 ; Disable the BCD decimal math mode
    ldx #$FF            ; Loads into the X register with 0xFF
    txs                 ; Transfer the X register to the SP (stack pointer)

; Clear Page Zero Region ($00 to $FF; includes the RAM and TIA registers)
    lda #0              ; Put zero in the A register
    ldx #$FF            ; Put 0xFF in the X register
    sta $FF             ; Zeros memory 0xFF before the loop starts

MemClearLoop;
    dex                 ; Decrement X
    sta $0,X            ; Store the value of register A into $0 + value of register X - does not change processor flags
    bne MemClearLoop    ; Branch to MemClearLoop if X is not zero (Z flag != 0)

; Close out ROM cartridge (This is required)
    org $FFFC           ; Ensures ROM is 4KB
    .word Start         ; Set where the program starts
    .word Start         ; Set the interrupt vector at $FFFE ($FFFC + 2)

; dasm cleanmem.asm -f3 -v0 -ocart.bin