import sys
import re
from pathlib import Path

# ------------------------------
SOURCE_FILENAMES = [
    "ASMB.Z80",
    "DATA.Z80",
    "EVAL.Z80",
    "EXEC.Z80",
    "HOOK.Z80",
    "MAIN.Z80",
    "MATH.Z80",
]

OUTPUT_DIR_NAME = "src"

# ------------------------------
# Literal replacements
LITERAL_REPLACEMENTS = [
    ("TDEF AND", "TDEF &"),
    ("' AND", "' &"),
]

# ------------------------------
# Keyword replacements
KEYWORD_REPLACEMENTS = {
    "GLOBAL": ".global",
    "EXTRN": ".extern",
    "EQU": ".equ",
    "DEFW": ".d24",
    "DEFM": ".byte",
    "DEFB": ".byte",
    "DEFS": ".space",
}


def make_keyword_pattern(keyword: str) -> re.Pattern:
    escaped = re.escape(keyword)
    return re.compile(rf"(?<![A-Za-z0-9_]){escaped}(?![A-Za-z0-9_])")


COMPILED_KEYWORDS = [(make_keyword_pattern(k), v) for k, v in KEYWORD_REPLACEMENTS.items()]

# ------------------------------
# Pattern replacements
PATTERN_REPLACEMENTS = {
    r"(?<![A-Za-z0-9_])ALIGN\s+4(?![A-Za-z0-9_])": ".align 2",
    r"(?<![A-Za-z0-9_])ALIGN\s+8(?![A-Za-z0-9_])": ".align 3",
    r"(?<![A-Za-z0-9_])ALIGN\s+16(?![A-Za-z0-9_])": ".align 4",
    r"(?<![A-Za-z0-9_])ALIGN\s+32(?![A-Za-z0-9_])": ".align 5",
    r"(?<![A-Za-z0-9_])ALIGN\s+64(?![A-Za-z0-9_])": ".align 6",
    r"(?<![A-Za-z0-9_])ALIGN\s+256(?![A-Za-z0-9_])": ".align 8",
}
COMPILED_PATTERNS = [(re.compile(p), r) for p, r in PATTERN_REPLACEMENTS.items()]

# Patterns for replacing anonymous labels
LABEL_DOLLAR_PATTERN = re.compile(r"(?<![A-Za-z0-9_])\$\$(?=:)")
DOLLAR_B_PATTERN = re.compile(r"(?<![A-Za-z0-9_])\$B(?![A-Za-z0-9_])")
DOLLAR_F_PATTERN = re.compile(r"(?<![A-Za-z0-9_])\$F(?![A-Za-z0-9_])")

# ------------------------------
# LD HL patterns
LD_HL_DE_PATTERN = re.compile(r"^(\s*)LD\s+HL\s*,\s*DE(?:\s*;\s*(.*))?", re.MULTILINE)
LD_HL_BC_PATTERN = re.compile(r"^(\s*)LD\s+HL\s*,\s*BC(?:\s*;\s*(.*))?", re.MULTILINE)

# ------------------------------
# Hexadecimal constant pattern
HEX_CONSTANT_PATTERN = re.compile(
    r"(?<![A-Za-z0-9_])([0-9A-Fa-f]+)[Hh](?![A-Za-z0-9_])"
)

# ------------------------------
# Binary constant pattern
BINARY_CONSTANT_PATTERN = re.compile(
    r"(?<![A-Za-z0-9_])([01]+)[bB](?![A-Za-z0-9_])"
)

# ------------------------------
# SBC single-parameter
SBC_SINGLE_PATTERN = re.compile(
    r"^(\s*)SBC\s+([A-Z])(?:\s*;(.*))?\s*$",
    re.MULTILINE,
)

# ------------------------------
# ADD single-parameter
ADD_SINGLE_PATTERN = re.compile(
    r"^(\s*)ADD\s+([A-Z])(?:\s*;(.*))?\s*$",
    re.MULTILINE,
)

# ------------------------------
# .byte string expansion
BYTE_STRING_PATTERN = re.compile(r"'(?:''|[^'])*'")


def _decode_z80_string(token: str) -> list[str]:
    """Decode a Z80 single-quoted string token, where '' means a literal apostrophe."""
    inner = token[1:-1]
    chars: list[str] = []
    i = 0
    while i < len(inner):
        if inner[i:i + 2] == "''":
            chars.append("'")
            i += 2
        else:
            chars.append(inner[i])
            i += 1
    return chars



def _gas_char_literal(ch: str) -> str:
    """Render one character safely for GAS."""
    if ch == "'":
        return "0x27"
    if ch == "\\":
        return "0x5C"
    return f"'{ch}'"



def expand_byte_strings(code: str) -> str:
    """Convert 'ABC' -> 'A','B','C' and handle doubled apostrophes inside strings."""

    def repl(m: re.Match) -> str:
        token = m.group(0)
        chars = _decode_z80_string(token)
        if len(chars) <= 1:
            if len(chars) == 1:
                return _gas_char_literal(chars[0])
            return token
        return ",".join(_gas_char_literal(ch) for ch in chars)

    return BYTE_STRING_PATTERN.sub(repl, code)


# ------------------------------
# Helper to split line into code/comment
def split_code_comment(line: str):
    """
    Split at the first ; that is outside a quoted Z80 string.
    Inside strings, doubled apostrophes ('') are treated as one literal apostrophe.
    """
    in_string = False
    i = 0

    while i < len(line):
        ch = line[i]

        if ch == "'":
            if in_string:
                if i + 1 < len(line) and line[i + 1] == "'":
                    i += 2
                    continue
                in_string = False
            else:
                in_string = True
            i += 1
            continue

        if ch == ";" and not in_string:
            return line[:i], line[i + 1:]

        i += 1

    return line, None


# ------------------------------
# Replacement function
def replace_all(text: str) -> str:
    out_lines = []
    out_lines.append("  .assume ADL = 1")

    for line in text.splitlines():
        for src, target in LITERAL_REPLACEMENTS:
            line = line.replace(src, target)

        code, comment = split_code_comment(line)
        indent_match = re.match(r"^(\s*)", code)
        indent = indent_match.group(1) if indent_match else ""

        code = HEX_CONSTANT_PATTERN.sub(r"0x\1", code)
        code = BINARY_CONSTANT_PATTERN.sub(r"0b\1", code)
        code = expand_byte_strings(code)

        for pattern, target in COMPILED_KEYWORDS:
            code = pattern.sub(target, code)

        for pattern, target in COMPILED_PATTERNS:
            code = pattern.sub(target, code)

        m = LD_HL_DE_PATTERN.match(code)
        if m:
            c_indent = m.group(1)
            code = f"{c_indent}PUSH DE\n{c_indent}POP HL"

        m = LD_HL_BC_PATTERN.match(code)
        if m:
            c_indent = m.group(1)
            code = f"{c_indent}PUSH BC\n{c_indent}POP HL"

        m = SBC_SINGLE_PATTERN.match(code)
        if m:
            c_indent = m.group(1)
            reg = m.group(2)
            code = f"{c_indent}SBC A,{reg}"

        m = ADD_SINGLE_PATTERN.match(code)
        if m:
            c_indent = m.group(1)
            reg = m.group(2)
            code = f"{c_indent}ADD A,{reg}"

        if comment is not None:
            code = f"{code} ;{comment}" if code.strip() else f"{indent};{comment}"

        code = LABEL_DOLLAR_PATTERN.sub("1", code)
        code = DOLLAR_B_PATTERN.sub("1b", code)
        code = DOLLAR_F_PATTERN.sub("1f", code)

        out_lines.append(code)

    return "\n".join(out_lines)


# ------------------------------
# File helpers
def convert_file(input_path: Path, output_path: Path) -> None:
    try:
        content = input_path.read_text()
    except Exception as e:
        raise RuntimeError(f"Error reading file {input_path}: {e}") from e

    new_content = replace_all(content)

    if not new_content.endswith("\n"):
        new_content += "\n"

    try:
        output_path.write_text(new_content)
    except Exception as e:
        raise RuntimeError(f"Error writing file {output_path}: {e}") from e



def make_output_filename(input_name: str) -> str:
    return f"{Path(input_name).stem.lower()}.s"


# ------------------------------
# Main CLI
def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <source_directory>")
        sys.exit(1)

    source_dir = Path(sys.argv[1])
    output_dir = Path.cwd() / OUTPUT_DIR_NAME

    if not source_dir.is_dir():
        print(f"Error: Source directory not found: {source_dir}")
        sys.exit(1)

    output_dir.mkdir(parents=True, exist_ok=True)

    had_error = False

    for filename in SOURCE_FILENAMES:
        input_path = source_dir / filename
        output_path = output_dir / make_output_filename(filename)

        if not input_path.is_file():
            print(f"Skipping missing file: {input_path}")
            had_error = True
            continue

        try:
            convert_file(input_path, output_path)
            print(f"Converted: {input_path} -> {output_path}")
        except RuntimeError as e:
            print(e)
            had_error = True

    if had_error:
        sys.exit(1)


if __name__ == "__main__":
    main()
