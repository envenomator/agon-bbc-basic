# BBC BASIC V Conformance Suite

## Level Summary

---

## Level 1 – Core Language

Basic correctness of the language.

**Covers:**
- Integer and real arithmetic
- Operator precedence
- Boolean logic (`AND`, `OR`, `EOR`, `NOT`)
- Built-in numeric functions (`ABS`, `INT`, `SGN`, `SQR`, etc.)
- String basics (`LEN`, `LEFT$`, `MID$`, `RIGHT$`, concatenation)
- Simple control flow (`IF`, `FOR`, `REPEAT`)
- Basic procedures and functions
- `DATA` / `READ` / `RESTORE`

**Goal:**  
*Does the interpreter implement the core language correctly?*

---

## Level 2 – Edge Cases

Corner cases and tricky semantics.

**Covers:**
- Tokeniser edge cases (spacing, keyword adjacency)
- String mutation (`LEFT$=`, `MID$=`)
- Empty strings and boundary conditions
- Compound assignment (`+=`, `DIV=`, etc.)
- `ON...GOSUB...ELSE`
- Array initialisation rules
- `ON ERROR LOCAL`, `ERR`, `ERL`, `REPORT$`

**Goal:**  
*Does it behave correctly in non-obvious situations?*

---

## Level 3A – Runtime Stress

Execution stability under load.

**Covers:**
- Deep and nested loops
- Repeated `GOSUB` / `RETURN`
- Recursive functions
- Repeated procedure calls
- String growth and mutation loops
- Array reuse patterns
- Memory indirection (`?`, `!`, `|`, `$`)
- Repeated error trapping and recovery

**Goal:**  
*Does the runtime remain stable under sustained use?*

---

## Level 3B – File I/O

Filesystem and file handling correctness.

**Covers:**
- `OPENOUT`, `OPENIN`, `CLOSE#`
- Byte I/O (`BPUT#`, `BGET#`)
- Sequential I/O (`PRINT#`, `INPUT#`)
- File position (`PTR#`)
- End-of-file detection (`EOF#`)
- File size (`EXT#`) *(checked after close/reopen for portability)*

**Goal:**  
*Does file I/O behave correctly and consistently?*

---

## Level 4A – Parser / EVAL

Expression parser and evaluator correctness.

**Covers:**
- Complex operator precedence
- `EVAL` with numeric and string expressions
- Variables inside `EVAL`
- Built-in functions inside `EVAL`
- User-defined `FN` calls inside `EVAL`
- Dynamically generated expressions
- Deeply nested expressions

**Goal:**  
*Is the expression parser and evaluator fully correct and robust?*

---

## Level 4B – Floating-Point

Numeric precision and stability.

**Covers:**
- Real-number arithmetic accuracy
- Transcendental functions (`SIN`, `COS`, `TAN`, `EXP`, `LN`)
- Rounding behavior (`INT`, `SGN`)
- Precision limits (large and small numbers)
- Cancellation and rounding errors
- Accumulation errors (repeated addition/multiplication)

**Goal:**  
*Does floating-point behave correctly within expected precision limits?*

---

## Overall Scope

Together, these levels validate:

- Parser and tokeniser
- Expression evaluation
- Runtime execution model
- Memory handling
- String system
- Numeric system
- File I/O subsystem
- Error handling

**Summary:**  
This suite provides a comprehensive validation of a BBC BASIC V interpreter implementation.

## Notes
- INSTR("ABC","") is expected to return 0 in this suite.
- EXT# in L3B is tested after CLOSE#/OPENIN for portability between Agon emulator and real hardware.
