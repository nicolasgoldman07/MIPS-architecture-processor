#!/usr/bin/python3

################ Imports ##################

import sys
import re
import json
import argparse

################ Functions ################

def delete_comments(text):
    comment_replacer = r'\/\/.*(?=\n)?'
    return re.sub(comment_replacer, "", text)

def implicit_jalr(text):
    jalr = r'(?:[\t ]*)(\bJALR\b)(?:[\t ]+?)(\d+)(?:[\t ]*(?!.)(?=\n)?)'
    replacer = r'\1 31,\2'
    return re.sub(jalr, replacer, text)

def to_plain_binary(number, nbits):
    if(number < 0):
        mask = ((int) (pow(2, nbits)-1))
        n_bin = bin(number & mask).replace("0b", "")
        return n_bin
    else:
        n_bin = bin(number).replace("0b", "")
        return n_bin.zfill(nbits)

def to_plain_hex(number, nbits):
    n_hex = hex(number).replace("0x", "")
    return n_hex.zfill(int(nbits/4))

################ Main #####################

# Program Arguments
parser = argparse.ArgumentParser(description='assemble mips code.')
parser.add_argument('src_code', type=str, nargs=1)
parser.add_argument('-x','--hex', action='store_true', help='hexadecimal output')
parser.add_argument('-m','--memory', action='store_true', help='coe memory format')
parser.add_argument('-o', dest='output', default='a.coe', help='output destination')

args = parser.parse_args()

# Constants
REGEXES = 'Instructions.json'
IN_FILE = args.src_code[0]
OUT_FILE = args.output
HEX = args.hex
RADIX = 2
MEM = args.memory

if(HEX):
    RADIX = 16

# Tries to read code file
try:
    file = open(IN_FILE, "r") 
    src_code = file.read()
    file.close()
except FileNotFoundError:
    print('assembler: cannot access \'%s\': No such file or directory' % IN_FILE)
    sys.exit(2)

# Read regex file
file = open(REGEXES, "r") 
regson = file.read()
file.close()

regex = json.loads(regson)
regex = regex["instructions"]


# Erases comments 
src_code = delete_comments(src_code).upper()

# Replace implicit JALRs
src_code = implicit_jalr(src_code)

print(src_code)

# Searches the regex for each instruction in the .json files
for instr in regex:

    instr_name = instr["name"]
    instr_regex = instr["regex"]
    instr_repl = instr["replace"]
    instr_opcode = instr["opcode"]
    instr_fcode = instr["funcode"]

    find = re.search(instr_regex, src_code)
    while (find != None):

        machine_instr = instr_opcode

        for replacer in instr_repl:
            group = replacer["group"]
            nbits = replacer["nbits"]

            machine_instr += to_plain_binary(int(find.group(group)), nbits)
        
        if(instr_fcode != None):
            machine_instr += instr_fcode
                
        src_code = re.sub(instr_regex, machine_instr, src_code, 1)

        find = re.search(instr_regex, src_code)

src_code = re.sub(r'([\t ]*)', "", src_code)


# Checks if there's any character other than 1 or 0s
invalid_char = re.search(r'([^01\n])', src_code)
if(invalid_char != None):
    print('There seems to be an invalid instruction or some syntax error.')
    print('Fix it and try again!')
    print(': ', invalid_char.group())
    sys.exit(3)


# File output
file = open(OUT_FILE, 'w')
beg_line = ''
end_line = '\n'

if(MEM):
    file.write("memory_initialization_radix=%d;\n" % RADIX)
    file.write("memory_initialization_vector=")
    beg_line = '\n'
    end_line = ''

if(HEX):
    splited = src_code.split()
    for line in splited:
        hex_line = to_plain_hex(int(line, 2), 32)
        file.write('%s%s%s' % (beg_line, hex_line, end_line))
else:
    file.write('%s%s%s' % (beg_line, src_code, end_line))

if(MEM):
    file.write(';')

file.close()