(import (scheme base)
        (prefix (schasm common) common:)
        (prefix (srfi 166) fmt:))

(define command  (list-ref common:command 0))
(define release  common:release)
(define features common:features)

(fmt:show #t command #\space release #\space features #\newline)
