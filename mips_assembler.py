#!/usr/bin/python

import os
import sys

# Check if the correct number of command line arguments was provided
if len(sys.argv) != 2:
  print("Usage: mips_assembler.py <mips_assembly_code_file>")
  sys.exit(1)

# Get the name of the MIPS assembly code file from the command line arguments
file_name = sys.argv[1]

# Assemble the MIPS assembly code file using the 'mips-linux-gnu-as' assembler
os.system("mips-linux-gnu-as -o output.o " + file_name)

# Link the assembled object file using the 'mips-linux-gnu-ld' linker
os.system("mips-linux-gnu-ld -o output output.o")

# Execute the linked output file
os.system("./output")