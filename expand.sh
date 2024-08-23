#!/bin/sh

# Call the script to expand the program inside the program_memory block
python3 build/expandProg.py build/prog.asm program_memory.v //--program--//

# Expand the verilog
iverilog -g2009 -E -o quartus/processor.v *.v 

