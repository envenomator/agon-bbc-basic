# BBC BASIC V Conformance Suite

## Philosophy & Design Goals

This conformance suite is designed to provide a **comprehensive, systematic validation** of BBC BASIC V implementations.

It focuses on:

- **Correctness** – ensuring language features behave as expected
- **Consistency** – verifying stable and repeatable behaviour across runs
- **Robustness** – confirming resilience under stress and error conditions
- **Edge-case handling** – exploring boundaries and unusual inputs
- **State integrity** – ensuring the interpreter maintains a valid internal state

The suite progresses from basic language features to increasingly complex and obscure runtime interactions. Higher levels intentionally probe areas that normal programs rarely exercise, but which are important for long-term interpreter stability.

A conforming run should report:

```text
FAILED : 0
```

unless a test is explicitly documented as skipped because of platform-level behaviour outside the BBC BASIC interpreter itself.

---

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

## Level 4C – Regression Coverage

Level 4C includes regression tests for previously identified issues.

**Covers:**
- `LOCAL` array + `DIM` interaction inside `PROC` / `FN`
- Multiple `LOCAL` arrays in the same scope
- Nested `PROC` local array isolation
- Repeated allocation/deallocation stability

**Goal:**  
*Do fixes for memory scoping and local array allocation remain stable across future changes?*

---

# Level 5 – Robustness, Limits & State Integrity

---

## Level 5A – Limits

Documented limits and safe boundary behaviour.

**Covers:**
- Maximum string length up to 255 characters
- String boundary behaviour at 254, 255, and overflow
- Array index boundaries for integer, real, and string arrays
- `LOCAL` array boundary handling
- Recursion depth sanity
- Runtime behaviour after limit tests

**Goal:**  
*Does the interpreter correctly enforce documented limits without corruption or instability?*

---

## Level 5B – Error Recovery

Repeated and nested error handling behaviour.

**Covers:**
- Repeated divide-by-zero traps
- Repeated bad `EVAL` traps
- Errors inside `FOR`, `REPEAT`, and `WHILE` loops
- Error handling with `LOCAL` variables
- Error handling with `LOCAL` arrays
- File operations across trapped errors
- Post-error runtime sanity

**Goal:**  
*Does the interpreter reliably recover from errors without degrading runtime state?*

---

## Level 5C – File Boundaries

Filesystem edge conditions.

**Covers:**
- Small file sizes
- Page/sector-like boundaries such as 127/128/129, 255/256/257, 511/512/513
- `PTR#` seek boundary behaviour
- `EOF#` behaviour at file boundaries
- `EXT#` correctness after close/reopen
- Readback integrity for generated byte patterns

**Goal:**  
*Does file handling remain correct at awkward size and pointer boundaries?*

---

## Level 5D – Parser Limits

Parser and expression-boundary stress.

**Covers:**
- Deeply nested parentheses
- Long flat expressions
- Chained arithmetic expressions
- String parser expressions
- Nested user-defined `FN` calls
- Many statements on one line
- Parser recovery after invalid `EVAL`

**Goal:**  
*Can the parser handle complex and malformed input without breaking subsequent execution?*

---

## Level 5E – Memory Churn

Repeated allocation and deallocation stress.

**Covers:**
- Intensive string creation and mutation cycles
- Repeated `LOCAL` integer array allocation
- Repeated `LOCAL` string array allocation
- Mixed-type array churn
- Nested local allocation churn
- Temporary expression churn
- Post-churn runtime sanity

**Goal:**  
*Does memory management remain stable under repeated allocation, deallocation, and temporary object creation?*

---

## Level 5F – TIME / RND

Timing and randomness behaviour.

**Covers:**
- `RND` repeatability after seeding
- `RND(n)` range correctness
- Basic randomness distribution sanity
- `TIME` monotonic behaviour
- `TIME` progression detection
- Runtime sanity after repeated `TIME` / `RND` use

**Goal:**  
*Do timing and randomness behave consistently and predictably without corrupting interpreter state?*

---

## Level 5G – Interpreter State Integrity

Complex interpreter state interactions.

**Covers:**
- `DATA` pointer consistency across `PROC` calls
- `RESTORE` interaction with nested reads
- Error recovery inside nested `FN` / `PROC` paths
- `GOSUB` / `RETURN` stack integrity
- `ON GOSUB` sequencing correctness
- Repeated `DIM` and `LOCAL` allocation behaviour
- Control-flow misuse trapping
- Post-edge runtime sanity

**Goal:**  
*Does the interpreter preserve a consistent internal state under complex and abnormal interactions?*

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
- Timing and randomness
- Interpreter state integrity

**Summary:**  
This suite provides a comprehensive validation of a BBC BASIC V interpreter implementation.

---

## Notes

- `INSTR("ABC","")` is expected to return `0` in this suite.
- `EXT#` in Level 3B is tested after `CLOSE#` / `OPENIN` for portability between Agon emulator and real hardware.
- Two Level 5C zero-length file tests are currently skipped on Agon because they expose platform-level zero-length file handling rather than BBC BASIC interpreter behaviour:
  - `EXT# L5C000.DAT`
  - `EOF empty file true`
