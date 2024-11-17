# Schasm
Schasm aims to be a R7RS small compliant implementation of Scheme.

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

## Contributing
- [Scheme Formatting](http://community.schemewiki.org/?scheme-style)
- [Scheme Naming](http://community.schemewiki.org/?variable-naming-convention)
- [Scheme Commenting](http://community.schemewiki.org/?comment-style)
