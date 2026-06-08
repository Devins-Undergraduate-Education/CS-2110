;; ============================================================================
;; CS 2110 - Fall 2023
;; Project 3 - wordProcessor
;; ============================================================================
;; Name: Devin Fromond
;; ============================================================================


;; =============================== Part 0: main ===============================
;; This is the starting point of the assembly program.
;; It sets up the stack pointer, and then calls the wordProcess() subroutine.
;; This subroutine has been provided for you. Change which subroutine is called
;; to debug your solutions!

.orig x3000
;; Set Stack Pointer = xF000
LD R6, STACK_PTR
;; Call wordProcess(). Change the subroutine being called for your own debugging!
LD R5, SUBROUTINE_ADDR
JSRR R5
HALT
;; Use a different label above to test your subroutines. 
;; DO NOT CHANGE OR RENAME THESE!
STACK_PTR        .fill xF000
;; Change the value below to be the address you want to test! 
;; IMPORTANT: change it back to x7000 for the autograder to work!
SUBROUTINE_ADDR  .fill x7000 
.end


;; ============================ Part 1: wordLength ============================
;; DESCRIPTION:
;; This function calculates the length of a word, given the starting address of
;; the word.
;; The starting address of the word should be passed in via register R0.
;; The length of the word should be returned in register R0.
;; A word is terminated by either a space bar, a null terminator, or a newline
;; character.

;; SUGGESTED PSEUDOCODE:
;; def wordLength(R0):
;;     addr = R0
;;     length = 0
;;     while (true):
;;         if (mem[addr] == '\0'):
;;             break
;;         if (mem[addr] == '\n'):
;;             break
;;         if (mem[addr] == ' '):
;;             break
;;         addr += 1
;;         length += 1
;;     R0 = length
;;     return
.orig x3800
    ; R0 = address
    ; R1 = length
    ; R2 = charChecks
    ; R3 = compareTo
    ; R4 = char[address]
    
    AND R1, R1, 0 ; R1 = 0 = length
    LD R2, ASCII_NEWLINE_1 ; R2 = /n
    NOT R2, R2
    ADD R2, R2, 1
    
    AND R3, R3, 0 ; R3 = 0
    LDR R4, R0, 0 ; R3 = CHAR[R0]
    
    WHILE0 BRz ENDWHILE0 ; if(R0 == null) --> ENDWHILE
        AND R3, R3, 0
        ADD R3, R4, R2
        BRz ENDWHILE0 ; if(char[R0] == charChecks) --> ENDWHILE
        ADD R2, R2, -10
        ADD R2, R2, -12 ; move onto ' ' char
        AND R3, R3, 0
        ADD R3, R4, R2
        BRz ENDWHILE0 ; if(char[R0] == charChecks) --> ENDWHILE
        
        ADD R0, R0, 1 ; address++
        ADD R1, R1, 1 ; length++
        AND R3, R3, 0 ; compareTo = 0
        LD R2, ASCII_NEWLINE_1
        NOT R2, R2
        ADD R2, R2, 1
        LDR R4, R0, 0
        BR WHILE0
    ENDWHILE0
    AND R0, R0, 0
    ADD R0, R0, R1
RET
ASCII_NEWLINE_1 .fill 10 
ASCII_SPACE_1   .fill 32 
.end 


;; ============================== Part 2: memcpy ==============================
;; DESCRIPTION: 
;; This function copies a block of memory from one location to another.
;; sourcePtr and destPtr are the starting addresses of the source and 
;; destination blocks of memory, respectively.
;; The length is the number of memory addresses to copy.
;; The sourcePtr, destPtr, and length should be passed in via registers R0, R1,
;; and R2 respectivley

;; SUGGESTED PSEUDOCODE:
;; def memcpy(R0, R1, R2):
;;     sourcePtr = R0
;;     destPtr = R1
;;     length = R2
;;     while (length > 0):
;;         mem[destPtr] = mem[sourcePtr]
;;         sourcePtr += 1
;;         destPtr += 1
;;         length -= 1
;;     return

.orig x4000
    ; R0 = startAddress
    ; R1 = destAddress
    ; R2 = length
    ; R3 = char
    
    AND R3, R3, 0
    AND R2, R2, R2 ; set BR condition for while
    WHILE1 BRz ENDWHILE1
        AND R3, R3, 0 ; clear R3
        LDR R3, R0, 0 ; R3 = char[startAddress]
        STR R3, R1, 0 ; char[destAddress] = R3
        ADD R0, R0, 1 ; startAddress++
        ADD R1, R1, 1 ; destAddress++
        ADD R2, R2, -1 ; length--
        BR WHILE1
    ENDWHILE1
RET
.end


;; ========================== Part 3: capitalizeLine ==========================
;; DESCRIPTION:
;; This subroutine capitalizes all the letters in a line of text. A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.
;; Keep in mind that ASCII characters that are not lowercase letters (i.e. 
;; symbols, number, etc) should not be modified!

;; SUGGESTED PSUEDOCODE:
;; def capitalizeLine(R0):
;;     addr = R0
;;     while (mem[addr] != '\0' and mem[addr] != '\n'):
;;         if (mem[addr] >= 'a' and mem[addr] <= 'z'): 
;;             mem[addr] = mem[addr] - 32 
;;         addr += 1
;;     return

.orig x4800
    ; R0 = startAddress
    ; R1 = checkChar
    ; R2 = compareTo
    ; R3 = char
    
    LD R1, ASCII_NEWLINE_2 ; R1 = /n
    NOT R1, R1
    ADD R1, R1, 1 ; R1 = -10
    
    AND R2, R2, 0 ; R2 = 0
    LDR R3, R0, 0 ; R3 = CHAR[R0]
    
    WHILE2 BRz ENDWHILE2 ; if(R0 == null) --> ENDWHILE
        LD R1, ASCII_NEWLINE_2 ; R1 = /n
        NOT R1, R1
        ADD R1, R1, 1 ; R1 = -10
        AND R2, R2, 0 ; compareTo = 0
        ADD R2, R3, R1 
        BRz ENDWHILE2 ; if(char[R0] == charChecks) --> ENDWHILE
        
        AND R2, R2, 0 ; compareTo = 0
        AND R1, R1, 0 
        LD R1, LOWER_A ; R1 = a
        NOT R1, R1
        ADD R1, R1, 1 ; R1 = -a = -97
        ADD R2, R3, R1
        BRn RETURN2 ; if(char[R1] < a) --> RETURN
        
        AND R2, R2, 0 ; compareTo = 0
        AND R1, R1, 0
        LD R1, LOWER_Z ; R1 = z
        NOT R1, R1
        ADD R1, R1, 1 ; R1 = -z = -122
        ADD R2, R3, R1
        BRp RETURN2 ; if(char[R1] > z) --> RETURN
        
        ADD R3, R3, -10 ; lower --> UPPER
        ADD R3, R3, -10 ; lower --> UPPER
        ADD R3, R3, -10 ; lower --> UPPER
        ADD R3, R3, -2 ; lower --> UPPER
        STR R3, R0, 0 ; store in address
        
        RETURN2
        AND R2, R2, 0
        AND R1, R1, 0
        ADD R0, R0, 1
        LDR R3, R0, 0
        BR WHILE2
    ENDWHILE2
    
RET
LOWER_A         .fill 97
LOWER_Z         .fill 122
MINUS_32        .fill -32
ASCII_NEWLINE_2 .fill 10 
.end




;; =========================== Part 4: reverseWords ===========================
;; DESCRIPTION:
;; This subroutine reverses each individual word in a line of text.
;; For example, the line "Hello World" would become "olleH dlroW".
;; A line is terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def reverseWords(R0):
;;     i = R0
;;     while (true):
;;          if (mem[i] == '\0' or mem[i] == '\n'):
;;              break
;;          if (mem[i] == ' '):
;;              i++
;;              continue
;;          start = i
;;          count = 0
;;          while (mem[i] != ' ' and mem[i] != '\0' and mem[i] != '\n'):
;;              stack.push(mem[i])
;;              i++
;;              count++
;;          i = start
;;          while (count > 0):
;;              mem[i] = stack.pop()
;;              i++
;;              count--
;;     return

.orig x5000
    ; R0 = i
    ; R1 = start
    ; R2 = count
    ; R3 = char
    ; R4 = charCheck
    ; R5 = comareTo
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0
    
    WHILE3 BRz ENDWHILE3 ; if(R0 == null) --> ENDWHILE
        LD R4, ASCII_NEWLINE_3 ; R4 = /n
        NOT R4, R4
        ADD R4, R4, 1 ; R4 = -10
        AND R5, R5, 0 ; compareTo = 0
        ADD R5, R4, R3
        BRz ENDWHILE3 ; if(char[R0] == charChecks) --> ENDWHILE
        
        AND R5, R5, 0 ; compareTo = 0
        ADD R4, R4, -10
        ADD R4, R4, -12 ; R4 = -32
        ADD R5, R4, R3
        BRnp NOTSPACE ; if(char[R0] == ' ') --> ENDWHILE
        
        ADD R0, R0, 1 ; i++
        
        NOTSPACE
        AND R1, R1, 0
        ADD R1, R0, 0 ; start = i
        AND R2, R2, 0 ; count = 0
        
        LDR R3, R0, 0 ; R3 = CHAR[R0]
        
        IWHILE3 BRz IENDWHILE3 ; if(R0 == null) --> IENDWHILE
            LD R4, ASCII_NEWLINE_3 ; R4 = /n
            NOT R4, R4
            ADD R4, R4, 1 ; R4 = -10
            AND R5, R5, 0 ; compareTo = 0
            ADD R5, R4, R3
            BRz IENDWHILE3 ; if(char[R0] == charChecks) --> IENDWHILE
            
            AND R5, R5, 0 ; compareTo = 0
            ADD R4, R4, -10 
            ADD R4, R4, -12 ; checkChar = ' '
            ADD R5, R4, R3
            BRz IENDWHILE3 ; if(char = ' ') --> IENDWHILE3
            
            ADD R6, R6, -1 ; move the stack pointer down
            STR R3, R6, 0 ; store char at stack pointer
            
            ADD R0, R0, 1 ; i++
            ADD R2, R2, 1 ; count++
            
            LDR R3, R0, 0 ; R3 = CHAR[R0]
            
            BR IWHILE3
        IENDWHILE3
        
        AND R0, R0, 0
        ADD R0, R1, 0 ; i = start
        
        ADD R2, R2, 0
        JWHILE3 BRnz JENDWHILE3
            LDR R3, R6, 0 ; pop from stack
            ADD R6, R6, 1 ; move stack pointer up
            
            STR R3, R0, 0 ; store value in R3 to address in R0
            
            ADD R0, R0, 1 ; i++
            ADD R2, R2, -1 ; count--
            
            BR JWHILE3
        JENDWHILE3
        
        LDR R3, R0, 0
        
        BR WHILE3
    ENDWHILE3
    
    LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R3, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R6, 1
RET
ASCII_NEWLINE_3 .fill 10 
ASCII_SPACE_2   .fill 32 
.end


;; =========================== Part 5: rightJustify ===========================
;; DESCRIPTION: 
;; This subroutine right justifies a line of text by padding with space bars.
;; For example, the line "CS2110   " would become "   CS2110". A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def rightJustify(R0):
;;    start = R0
;;    curr = start
;;    while (mem[curr] != '\n' and mem[curr] != '\0'):
;;        curr++
;;    curr--
;;    end = curr
;;    // This loop shifts over the entire string one spacebar at a time,
;;    // until it is no longer terminated by a spacebar!
;;    while (mem[end] == ' '):
;;        while (curr != start):
;;            mem[curr] = mem[curr - 1]
;;            curr--
;;        mem[curr] = ' '
;;        curr = end
;;    return

.orig x5800
    ; R0 = start
    ; R1 = checkChar
    ; R2 = compareTo
    ; R3 = char
    ; R4 = curr
    ; R5 = end
    
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0
    
    AND R4, R4, 0 ; curr = 0
    ADD R4, R4, R0 ; curr = start
    
    AND R2, R2, 0 ; R2 = 0
    LDR R3, R0, 0 ; R3 = CHAR[R0]

    WHILE4 BRz ENDWHILE4 ; if(R0 == null) --> ENDWHILE
        LD R1, ASCII_NEWLINE_4 ; R1 = /n
        NOT R1, R1
        ADD R1, R1, 1 ; R1 = -10
        AND R2, R2, 0 ; compareTo = 0
        ADD R2, R3, R1 
        BRz ENDWHILE4 ; if(char[R0] == charChecks) --> ENDWHILE
        ADD R4, R4, 1 ; curr++
        
        LDR R3, R4, 0 ; R3 = CHAR[R0]
        BR WHILE4
    ENDWHILE4
    
    ADD R4, R4, -1 ; curr--
    
    AND R5, R5, 0 ; end = 0
    ADD R5, R5, R4 ; end = curr
    
    AND R3, R3, 0 ; clear R3 (char)
    LDR R3, R5, 0 ; R3 = mem[end]
    ADD R1, R1, -10
    ADD R1, R1, -12 ; checkChar = ' '
    AND R2, R2, 0 ; compareTo = 0
    ADD R2, R1, R3 ; see if mem[end] is a space
    
    OWHILE4 BRnp OENDWHILE4
        AND R2, R2, 0 ; compareTo = 0
        AND R1, R1, 0 ; checkChar = 0
        NOT R1, R4
        ADD R1, R1, 1 ; checkChar = -curr
        ADD R2, R1, R0 ; curr = start check
        IWHILE4 BRz IENDWHILE4 ; if(curr == start) --> ENDWHILE4.10
            AND R2, R2, 0 ; compareTo = TEMP REG = 0
            LDR R2, R4, -1 ; load mem[curr - 1] and put it in R2
            STR R2, R4, 0 ; value in R2 is stored at mem[curr]
            ADD R4, R4, -1 ; curr--
            
            AND R2, R2, 0 ; compareTo = 0
            AND R1, R1, 0 ; checkChar = 0
            NOT R1, R4
            ADD R1, R1, 1 ; checkChar = -curr
            ADD R2, R1, R0 ; curr = start check
            BR IWHILE4
        IENDWHILE4
        
        AND R2, R2, 0 ; compareTo = TEMP REG = 0
        LD R2, ASCII_SPACE_3
        STR R2, R4, 0 ; mem[curr] = ' '
        
        AND R4, R4, 0 ; curr = 0
        ADD R4, R4, R5 ; curr = end
    
        AND R3, R3, 0 ; clear R3 (char)
        LDR R3, R5, 0 ; R3 = mem[end]
        AND R1, R1, 0 ; checkChar = 0
        ADD R1, R1, -10
        ADD R1, R1, -10
        ADD R1, R1, -12 ; checkChar = ' '
        AND R2, R2, 0 ; compareTo = 0
        ADD R2, R1, R3 ; see if mem[end] is a space
        BR OWHILE4
    OENDWHILE4
    
    LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R3, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R6, 1

RET
ASCII_SPACE_3   .fill 32
ASCII_NEWLINE_4 .fill 10
.end


;; ============================= Part 6: getInput =============================
;; DESCRIPTION: 
;; This function should read a string of characters from the keyboard and place
;; them in a buffer.
;; The address of the buffer should be passed in via register R0.
;; The string should be terminated by two consecutive '$' characters.
;; The '$' characters should not be placed in the buffer.
;; Remember to properly null-terminate your string, and to print out each 
;; character as it is typed!
;; You may assume that the user will always enter a valid input.

;; SUGGESTED PSEUDOCODE:
;; def getInput(R0):
;;      bufferPointer = R0
;;      while (true):
;;          input = GETC() 
;;          OUT(input)
;;          mem[bufferPointer] = input 
;;          if input == '$':
;;              if mem[bufferPointer - 1] == '$':
;;                  mem[bufferPointer - 1] = '\0'
;;                  break
;;          bufferPointer += 1

.orig x6000
    ; R0 = GETC = input
    ; R1 = checkChar
    ; R2 = compareTo
    ; R3 = bufferPointer
    ; R4 = tempChar
    
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0
    
    AND R3, R3, 0 ; R3 = 0
    ADD R3, R3, R0; R3 = bufferpointer
    
    AND R1, R1, 0 ; R1 = 0
    LD R1, ASCII_DOLLAR_SIGN ; checkChar = $
    NOT R1, R1
    ADD R1, R1, 1 ; checkChar = -$
    
    WHILE5 
        GETC ; char[keyboard] --> R0
        OUT ; R0 --> console
        
        STR R0, R3, 0 ; mem[bufferPointer] = R0
        
        AND R2, R2, 0 ; compareTo = 0
        ADD R2, R1, R0 
        BRnp NO$ ; if(input != $) --> NO$
            AND R2, R2, 0 ; compareTo = 0
            LDR R4, R3, -1 ; load mem[bufferPointer - 1] to R4
            ADD R2, R4, R1 ; if(R4 != $) --> NO$
            BRnp NO$
            AND R2, R2, 0 ; compareTo = 0 (also null char)
            STR R2, R3, -1 ; mem[bufferPointer - 1] = compareTo = null
            BR ENDWHILE5 ; break
        NO$
        
        ADD R3, R3, 1 ; bufferPointer++
        
        BR WHILE5
    ENDWHILE5
    
        LDR R5, R6, 0
        ADD R6, R6, 1
        LDR R4, R6, 0
        ADD R6, R6, 1
        LDR R3, R6, 0
        ADD R6, R6, 1
        LDR R2, R6, 0
        ADD R6, R6, 1
        LDR R1, R6, 0
        ADD R6, R6, 1
        LDR R0, R6, 0
        ADD R6, R6, 1
        
RET
ASCII_DOLLAR_SIGN .fill 36
.end


;; ============================ Part 7: parseLines ============================
;; IMPORTANT: This method has already been implemented for you. It will help 
;; you when implementing wordProcessor!

;; Description: This subroutine parses a string of characters from an 
;; initial buffer and places the parsed string in a new buffer. 
;; This subroutine divides each line into 8 characters or less. If a word
;; cannot fully fit on the current line, trailing spaces will be added and it
;; will be placed on the next line instead.

;; The address of the buffer containing the unparsed string, as well as the 
;; address of the destination buffer should be passed in via registers R0 and
;; R1 respectively.

;; An example of what memory looks like before and after parsing:
;;  x3000 │ 'A' │               x6000 │ 'A' │  ───┐
;;  x3001 │ ' ' │               x6001 │ ' ' │     │
;;  x3002 │ 'q' │               x6002 │ 'q' │     │
;;  x3003 │ 'u' │               x6003 │ 'u' │     │ 8 characters
;;  x3004 │ 'i' │               x6004 │ 'i' │     │ (not including \n!)
;;  x3005 │ 'c' │               x6005 │ 'c' │     │
;;  x3006 │ 'k' │               x6006 │ 'k' │     │
;;  x3007 │ ' ' │               x6007 │ ' ' │  ───┘
;;  x3008 │ 'r' │               x6008 │ \n  │
;;  x3009 │ 'e' │               x6009 │ 'r' │  ───┐
;;  x300A │ 'd' │               x600A │ 'e' │     │
;;  x300B │ ' ' │               x600B │ 'd' │     │
;;  x300C │ 'k' │     ───>      x600C │ ' ' │     │ 8 characters
;;  x300D │ 'i' │               x600D │ ' ' │     │ (not including \n!)
;;  x300E │ 't' │               x600E │ ' ' │     │
;;  x300F │ 't' │               x600F │ ' ' │     │
;;  x3010 │ 'y' │               x6010 │ ' ' │  ───┘
;;  x3011 │ \0  │               x6011 │ \n  │
;;  x3012 │ \0  │               x6012 │ 'k' │  ───┐
;;  x3013 │ \0  │               x6013 │ 'i' │     │
;;  x3014 │ \0  │               x6014 │ 't' │     │
;;  x3015 │ \0  │               x6015 │ 't' │     │ 8 characters
;;  x3016 │ \0  │               x6016 │ 'y' │     │ (not including \0!)
;;  x3017 │ \0  │               x6017 │ ' ' │     │
;;  x3018 │ \0  │               x6018 │ ' ' │     │
;;  x3019 │ \0  │               x6019 │ ' ' │  ───┘
;;  x301A │ \0  │               x601A │ \0  │

;; PSEUDOCODE:
;; def parseLines(R0, R1):
;;      source = R0
;;      destination = R1
;;      currLineLen = 0
;;      while (mem[source] != '\0'):
;;          wordLen = wordLength(source)
;;          if (currLineLen + wordLen - 8 <= 0):
;;              memcpy(source, destination + currLineLen, wordLen)
;;              lineLen += wordLen
;;              if (mem[source + wordLen] == '\0'):
;;                  break 
;;              source += wordLen + 1 
;;              if (lineLen < 8):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;          else:
;;              while (lineLen - 8 < 0):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;              mem[destination + lineLen] = '\n'
;;              destination += lineLen + 1
;;              lineLen = 0
;;      while (lineLen - 8 < 0):
;;          mem[destination + lineLen] = ' '   
;;      mem[destination + lineLen] = '\0'
.orig x6800
;; Save RA on the stack
ADD R6, R6, -1
STR R7, R6, 0
AND R2, R2, 0 ; currLineLen = 0
PARSE_LINES_WHILE
    LDR R3, R0, 0 
    BRz EXIT_PARSE_LINES_WHILE ; mem[source] == '\0'
    ; make a wordLength(source) call
    ; Save R0-R5 on the stack
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0

    LD R3, WORDLENGTH_ADDR
    JSRR R3            
    ADD R3, R0, 0 ; wordLen (R3) = wordLength(source)

    ; Restore R0-R5 from the stack!
    LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R6, 1

    ADD R4, R2, R3 ;; R4 = currLineLen + wordLen
    ADD R4, R4, -8
    BRp PARSE_LINES_ELSE
        ;; Save R0-R5 on the stack
        ADD R6, R6, -1
        STR R0, R6, 0
        ADD R6, R6, -1
        STR R1, R6, 0
        ADD R6, R6, -1
        STR R2, R6, 0
        ADD R6, R6, -1
        STR R3, R6, 0
        ADD R6, R6, -1
        STR R4, R6, 0
        ADD R6, R6, -1
        STR R5, R6, 0

        ADD R1, R1, R2 ;; destination + currLineLen
        ADD R2, R3, 0  ;; wordLen is in R3
        LD R5, MEMCPY_ADDR
        JSRR R5 ;; memcpy(source, destination + currLineLen, wordLen)

        ;; Restore R0-R5 from the stack
        LDR R5, R6, 0
        ADD R6, R6, 1
        LDR R4, R6, 0
        ADD R6, R6, 1
        LDR R3, R6, 0
        ADD R6, R6, 1
        LDR R2, R6, 0
        ADD R6, R6, 1
        LDR R1, R6, 0
        ADD R6, R6, 1
        LDR R0, R6, 0
        ADD R6, R6, 1

        ADD R2, R2, R3 ;; lineLen += wordLen

        ; if (mem[source + wordLen] == '\0'), 
        ADD R5, R0, R3 ;; R5 = source + wordLen
        LDR R5, R5, 0 ;; R5 = mem[source + wordLen]
        BRnp LINE_HASNT_ENDED
        BR FILL_WITH_SPACES
        LINE_HASNT_ENDED

        ADD R0, R0, R3 ;; source += wordLen
        ADD R0, R0, 1 ;; source += 1

        ADD R4, R2, -8 ; if (linelen < 8):
        BRzp DONT_ADD_SPACE
            ;; Add the spacebar
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            LD R4, ASCII_SPACE_4
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
        DONT_ADD_SPACE
        BRnzp PARSE_LINES_WHILE
    PARSE_LINES_ELSE
        ;; Else clause
        PARSE_LINES_WHILE2
            ADD R4, R2, -8
            BRzp EXIT_PARSE_LINES_WHILE2
            LD R4, ASCII_SPACE_4
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
            BRnzp PARSE_LINES_WHILE2
        EXIT_PARSE_LINES_WHILE2
        LD R4, ASCII_NEWLINE_5
        ADD R5, R1, R2 ;; R5 = destination + lineLen
        STR R4, R5, 0 ;; mem[destination + lineLen] = '\n'
        ADD R1, R1, R2 ;; destination += lineLen
        ADD R1, R1, 1 ;; destination += 1
        AND R2, R2, 0 ;; lineLen = 0
        BRnzp PARSE_LINES_WHILE
EXIT_PARSE_LINES_WHILE

;; while (lineLen - 5 < 0):
;;    mem[destination + lineLen] = ' ' 
FILL_WITH_SPACES
    ADD R4, R2, -8
    BRzp EXIT_FILL_WITH_SPACES
    LD R4, ASCII_SPACE_4
    ADD R5, R1, R2 ;; R5 = destination + lineLen
    STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
    ADD R2, R2, 1 ;; lineLen += 1
BRnzp FILL_WITH_SPACES
EXIT_FILL_WITH_SPACES

AND R4, R4, 0 ;; '\0'
ADD R5, R1, R2 ;; R5 = destination + lineLen
STR R4, R5, 0 ;; mem[destination + lineLen] = '\0'

; Pop RA from the stack
LDR R7, R6, 0
ADD R6, R6, 1

RET

WORDLENGTH_ADDR .fill x3800
MEMCPY_ADDR     .fill x4000
ASCII_SPACE_4   .fill 32
ASCII_NEWLINE_5 .fill 10
.end


;; ========================== Part 8: wordProcessor ===========================
;; Implement this subroutine LAST! It will use all the other subroutines.
;; This subroutine should read in a string of characters from the keyboard and
;; write it into the buffer provided at x8000. It should then parse the string
;; into lines of 8 characters or less, and write the parsed string to the 
;; buffer provided at x8500. Finally, for each line, the user should be able to
;; select between leaving the line as is, capitalizing the line, reversing the 
;; words in the line, or right justifying the line. The final parsed string 
;; should be written to the buffer at x8500 and printed out to the console.

;; You may assume that the input will always be valid - it will not exceed the 
;; length of the buffer, no word will be longer than 8 characters, and there 
;; will not be any leading / trailing spaces!

;; An example of what correct console output looks like if the sentence typed
;; is "The quick brown fox jumps over the lazy dog", and the options entered
;; are 0, 1, 2, 3, 0, 1, 2, 3
;; Note that any characters that are not 0, 1, 2, or 3 should be ignored!

;; Expected console output:

;; The quick brown fox jumps over the lazy dog$$
;; Enter modifier options:
;; The 
;; QUICK
;; nworb
;;     fox
;; jumps
;; OVER THE
;; yzal god

;; SUGGESTED PSEUDOCODE:
;; def WordProcess():
;;      GetInput(x8000)
;;      OUT(\n)
;;      ParseLines(x8000, x8500)
;;      startOfCurrLine = x8500
;;      PUTS("Enter modifier options.\n")
;;      while (true):
;;          option = GETC()
;;          if (option == '0'):
;;              pass
;;          elif (option == '1'):
;;              CapitalizeLine(startOfCurrLine)
;;          elif (option == '2'):
;;              ReverseWords(startOfCurrLine)
;;          elif (option == '3'):
;;              RightJustify(startOfCurrLine)
;;          else:
;;              // Input is not valid, just try again:
;;              continue
;;          // Print the line after it is modified
;;          i = 0
;;          while (i < 9):
;;              OUT(mem[startOfCurrLine])
;;              startOfCurrLine++
;;              i++
;;          if (mem[startOfCurrLine - 1] == '\0'):
;;              break
;;      return

.orig x7000
    ; R0 = input0/GETC
    ; R1 = input1
    ; R2 = compareTo/TEMP
    ; R3 = checkChar
    ; R4 = startOfCurrLine
    ; R5 = i
    LD R0, BUFFER_1 ; R0 <-- x8000
    LD R1, GETINPUT_ADDR
    JSRR R1 ; run GETINPUT
    
    LD R0, ASCII_NEWLINE_6 ; R0 <-- \n
    OUT ; print \n
    
    LD R0, BUFFER_1 ; R0 <-- x8000
    LD R1, BUFFER_2 ; R1 <-- x8500
    LD R2, PARSELINES_ADDR 
    
    JSRR R2 ; run PARSELINES
    
    AND R4, R4, 0 ; startOfCurrLine = 0
    LD R4, BUFFER_2 ; startOfCurrLine = x8500
    
    LEA R0, OPTIONS_MSG ; R0 <-- message
    PUTS ; print string to console
    
    WHILE7
        GETC ; R0 <-- input
        
        LD R3, ASCII_ZERO ; R3 = '0'
        NOT R3, R3,
        ADD R3, R3, 1 ; R3 = -0
        
        AND R2, R2, 0 ; compareTo = 0 
        ADD R2, R3, R0 
        BRnp maybe1 ; if(input != 0) --> maybe1
        BRz break ; if(input == 0) --> break
        
        maybe1
        AND R2, R2, 0 ; compareTo = 0 
        ADD R3, R3, -1 ; checkChar = '1'
        ADD R2, R3, R0
        BRnp maybe2 ; if(input != 1) --> maybe2
        AND R0, R0, 0 ; input = 0
        ADD R0, R0, R4 ; input = startOfCurrLine
        LD R2, CAPITALIZE_ADDR
        JSRR R2 ; run CAPITALIZE
        BR break
        
        maybe2
        AND R2, R2, 0 ; compareTo = 0
        ADD R3, R3, -1 ; checkChar = '2'
        ADD R2, R3, R0 
        BRnp maybe3 ; if(input != 2) --> maybe3
        AND R0, R0, 0 ; input = 0
        ADD R0, R0, R4 ; input = startOfCurrLine
        LD R2, REVERSE_ADDR 
        JSRR R2 ; run REVERSE
        BR break
        
        maybe3
        AND R2, R2, 0 ; compareTo = 0
        ADD R3, R3, -1 ; checkChar = '3'
        ADD R2, R3, R0 
        BRnp break ; if(input != 3) --> break
        AND R0, R0, 0 ; input = 0
        ADD R0, R0, R4 ; input = startOfCurrLine
        LD R2, RIGHT_JUSTIFY_ADDR
        JSRR R2 ; run RIGHT JUSTIFY
        BR break
        
        break
        
        AND R5, R5, 0 ; R5 = i = 0 ;
        AND R2, R2, 0 ; compareTo = 0
        AND R3, R3, 0 ; checkChar = 0
        
        ADD R3, R3, -9 ; checkChar = -9
        ADD R2, R5, R3 
        IWHILE7 BRzp IENDWHILE7 ; if(i >= 9) --> IENDWHILE7
            LDR R0, R4, 0 ; R0 <-- mem[startOfCurrLine]
            OUT ; print R0
            ADD R4, R4, 1 ; currStartOfLine++
            ADD R5, R5, 1 ; i++
            
            AND R2, R2, 0 ; compareTo = 0
            ADD R2, R5, R3 ; i >= 9 check
            BR IWHILE7
        IENDWHILE7
            
        AND R2, R2, 0 ; TEMP = 0
        LDR R2, R4, -1 ; R2 <-- mem[startOfCurrLine - 1]
        BRz ENDWHILE7 ; if R2 == \0 --> ENDWHILE7
            
        BR WHILE7
    ENDWHILE7
RET
BUFFER_1           .fill x8000
BUFFER_2           .fill x8500
GETINPUT_ADDR      .fill x6000
PARSELINES_ADDR    .fill x6800
CAPITALIZE_ADDR    .fill x4800
REVERSE_ADDR       .fill x5000
RIGHT_JUSTIFY_ADDR .fill x5800
ASCII_ZERO         .fill 48
ASCII_ONE          .fill 49
ASCII_TWO          .fill 50
ASCII_THREE        .fill 51
ASCII_NEWLINE_6    .fill 10
OPTIONS_MSG        .stringz "Enter modifier options:\n"
.end


;; x8000 Buffer
.orig x8000
.blkw 100
.end


;; x8500 Buffer
.orig x8500
.blkw 100
.end

