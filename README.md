# Schasm
Schasm aims to be a R7RS small compliant Scheme to Scheme compiler. The output
will be a subset of valid Scheme that is as easy as possible to translate to a
register machine.

## Using Schasm
Any R7RS compliant implementation should work but chibi scheme is recommended.
Additional SRFIs may be necessary to run the programs/executables.

### Interpreter
``` sh
chibi-scheme -I src/lib src/bin/schasmi.scm
```

### Compiler
``` sh
chibi-scheme -I src/lib src/bin/schasmc.scm
```

## Architecture
- src:
  - bin:
    - Programs and executables.
  - lib:
    - Modules and libraries.
    - schasm:
      - source-language:
        - Input to the interpreter and compiler.
      - intermediate-language:
        - Internal representation of code in the interpreter and compiler.
      - target-language:
        - Output of the compiler.
      - front-end:
        - Translation from source-language to intermediate-language.
      - middle-end:
        - Improvement of intermediate-language.
      - back-end:
        - Translation from intermediate-language to target-language.

## Example Input/Output

### Input
``` scheme
(import (scheme base))

(define (gcd x y)
  (if (= 0 y)
      x
      (gcd y (modulo x y))))

(gcd 12 8)
```

### Output
``` scheme
(import (scheme base)
        ;; definitions for the "machine instructions"
        (machine))

(define start.label 0)
(define (start)
  ;; push return address to "stack"
  (mem-set! SP exit.label)
  (reg-set! SP (+ SP 1))
  ;; push first argument to "stack"
  (mem-set! SP 12)
  (reg-set! SP (+ SP 1))
  ;; push second argument to "stack"
  (mem-set! SP 8)
  (reg-set! SP (+ SP 1))
  ;; jump to procedure
  (jmp gcd.label))

(define gcd.label 1)
(define (gcd)
  ;; pop second argument from "stack"
  (reg-set! SP (- SP 1))
  (reg-set! R1 (mem-ref SP))
  ;; pop first argument from "stack"
  (reg-set! SP (- SP 1))
  (reg-set! R0 (mem-ref SP))
  ;; jump to body of procedure
  (jmp gcd.L0.label))

(define gcd.L0.label 2)
(define (gcd.L0)
  (branch (= R1 0) (jmp gcd.L2.label) (jmp gcd.L1.label)))

(define gcd.L1.label 3)
(define (gcd.L1)
  ;; save first argument
  (reg-set! R2 R0)
  ;; set first argument to second argument
  (reg-set! R0 R1)
  ;; set second argument to second argument modulo saved first argument
  (reg-set! R1 (modulo R2 R1))
  ;;; loop
  (jmp gcd.L0.label))

(define gcd.L2.label 4)
(define (gcd.L2)
  ;; pop return address from "stack"
  (reg-set! SP (- SP 1))
  (reg-set! R2 (mem-ref SP))
  ;; push result to "stack"
  (mem-set! SP R0)
  (reg-set! SP (+ SP 1))
  ;; jump to return address
  (jmp R2))

(define exit.label 5)
(define (exit)
  #f)

(entry-point start 10 (vector start gcd gcd.L0 gcd.L1 gcd.L2 exit))
```

## Contributing
- [Scheme Formatting](http://community.schemewiki.org/?scheme-style)
- [Scheme Naming](http://community.schemewiki.org/?variable-naming-convention)
- [Scheme Commenting](http://community.schemewiki.org/?comment-style)
