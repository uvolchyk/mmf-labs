# -*- coding: utf-8 -*-
from xml.sax.saxutils import escape
import re
import sys

def main():
    (maxwidth, frmt) = process_options()
    if (any((maxwidth, frmt))):
        print_start()
        count = 0
        while True:
            try:
                line = input()
                if count == 0:
                    color = "lightgreen"
                elif count % 2:
                    color = "white"
                else:
                    color = "lightyellow"
                print_line(line, color, maxwidth, frmt)
                count += 1
            except EOFError:
                break
        print_end()
    else:
        print("Error: can't generate HTML presentation, internal problem")

def print_start():
    print("<table border='1'>")

def print_end():
    print("</table>")

def print_line(line, color, maxwidth, frmt):
    print("<tr bgcolor='{0}'>".format(color))
    fields = extract_fields(line)
    for field in fields:
        if not field:
            print("<td></td>")
        else:
            number = field.replace(",", "")
            try:
                x = float(number)
                print("<td align='right'>{0:{1}}</td>".format(round(x), frmt))
            except ValueError:
                field = field.title()
                field = field.replace(" And ", " and ")
                field = escape(field)
                if len(field) <= maxwidth:
                    print("<td>{0}</td>".format(field))
                else:
                    print("<td>{0:.{1}} ...</td>".format(field, maxwidth))
    print("</tr>")

def extract_fields(line):
    fields = []
    field = ""
    quote = None
    for c in line:
        if c in "\"'":
            if quote is None:  # начало строки в кавычках
                quote = c
            elif quote == c:  # конец строки в кавычках
                quote = None
            else:
                field += c
                # другая кавычка внутри строки в кавычках
                continue
        if quote is None and c == ",":  # end of a field
            fields.append(field)
            field = ""
        else:
            field += c
            # добавить символ в поле
    if field:
        fields.append(field)  # добавить последнее поле в список
    return fields

def process_options() -> tuple:
    if len(sys.argv) > 1:
        if sys.argv[1] in ["-h", "--help"]:
            
            info = ( '\n'
            'usage: \n'
            '{0} [maxwidth=int] [format=str] < infile.csv > outfile.html"\n'
            'maxwidth ‐ необязательное целое число. Если задано, определяет\n'
            'максимальное число символов для строковых полей. В противном случае\n'
            'используется значение по умолчанию 100.\n\n'

            'format ‐ формат вывода чисел. Если не задан, по умолчанию используется\n'
            'формат ”.0f”.\n'
            ).format(sys.argv[0])
            print(info)
            exit(0)
        else:
            maxwidth, frmt = sys.argv[1], ".0f"
            if len(sys.argv) > 2:
                frmt = sys.argv[2]
            try:
                maxwidth = int(re.findall(r'\d+', maxwidth)[0])
            except ValueError:
                print("Error: invalid argument passed to a [maxwidth]. Supposed type is integer")
                exit(0)
            return (maxwidth, frmt)
    return (100, ".0f")

main()
