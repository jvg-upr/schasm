(define-library (srfi 37)
  (export option? option
          option-names option-required-arg? option-optional-arg? option-processor
          args-fold)
  (import (scheme base))
  (include "37/args-fold.scm"))
