(import (scheme base)
        (scheme process-context)
        (prefix (schasm common) common:)
        (prefix (srfi 37)       arg:)
        (prefix (srfi 128)      cmp:)
        (srfi 146)
        (prefix (srfi 166)      fmt:))

(define (parse-arguments arguments)
  (arg:args-fold (list-tail arguments 1)
                 (list (arg:option
                        '(#\V "version")
                        #f #f
                        (lambda (option name argument config)
                          (mapping-set config 'version #t)))
                       (arg:option
                        '(#\h "help")
                        #f #f
                        (lambda (option name argument config)
                          (mapping-set config 'help #t)))
                       (arg:option
                        '(#\v "verbose")
                        #f #f
                        (lambda (option name argument config)
                          (mapping-set config 'verbose #t)))
                       (arg:option
                        '(#\D "add-feature") #t #t
                        (lambda (arg:option name argument config)
                          (mapping-set config 'features
                                       (cons argument
                                             (mapping-ref config 'features)))))
                       (arg:option
                        '(#\A "append") #t #t
                        (lambda (option name argument config . what)
                          (mapping-set config 'append
                                       (cons argument
                                             (mapping-ref config 'append)))))
                       (arg:option
                        '(#\I "prepend") #t #t
                        (lambda (option name argument config)
                          (mapping-set config 'prepend
                                       (cons argument
                                             (mapping-ref config 'prepend)))))
                       (arg:option
                        '(#\o "output") #t #t
                        (lambda (option name argument config)
                          (mapping-set config 'output
                                       (cons argument
                                             (mapping-ref config 'output))))))
                 (lambda _
                   (error "invalid arguments"))
                 (lambda (operand config)
                   (mapping-set config 'input
                                (cons operand
                                      (mapping-ref config 'input))))
                 (mapping (cmp:make-default-comparator)
                          'version  #f
                          'help     #f
                          'verbose  #f
                          'append   '()
                          'prepend  '()
                          'output   '()
                          'input    '()
                          'command  common:command
                          'features common:features
                          'release  common:release)))

(define (main arguments)
  (define config (parse-arguments arguments))

  (fmt:show #t
            (list-ref (mapping-ref config 'command) 0)
            #\space
            (mapping-ref config 'release)
            #\space
            (mapping-ref config 'features)
            fmt:nl)

  (exit 0))

(main (command-line))
