import unicodedata
import sys

def print_unicode_table(words):
    print("decimal hex chr {0:^40}".format("name")) 
    print("‐‐‐‐‐‐‐ ‐‐‐‐‐ ‐‐‐ {0:‐<40}".format(""))
    code = ord(" ")
    end = sys.maxunicode
    while code < end: 
        c = chr(code)
        name = unicodedata.name(c, "*** unknown ***").lower()
        if all(token in name for token in words):
            print("{0:7} {0:5X} {0:^3c} {1}".format(code, name.capitalize())) 
        code += 1

words = []
if len(sys.argv) > 1:
    if sys.argv[1] in ("‐h", "‐‐help"):
        print("usage: {0} [string]".format(sys.argv[0]))
    else:
        words = list(map(lambda x: x.lower(), sys.argv[1:]))
if len(words) > 0:
    print_unicode_table(words)



