# Schasm
Schasm aims to be a R7RS small compliant Scheme to Scheme compiler. The output
will be a subset of valid Scheme that is as easy as possible to translate to a
register machine.

## Example Input/Output

### Input
``` scheme
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
