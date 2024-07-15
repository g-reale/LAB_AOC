import argparse
import re

#INPUT ARGUMENTS
parser = argparse.ArgumentParser(description='Expands a assembly program inside the verilog program memory')
parser.add_argument('program_path',type=str)
parser.add_argument('program_memory_path',type=str)
parser.add_argument('body_marker',type=str)
args = parser.parse_args()

#REGEXES FOR TEXT PROCESSING
find_instruction = re.compile(r'^ *([A-Z]*\((\d*,?)*\);)$',re.MULTILINE)
find_program_body = re.compile(fr'{args.body_marker}(\n|.)*{args.body_marker}',re.MULTILINE)

#OPENING THE INPUT PROGRAM FILE
program = ""
with open(args.program_path,"r") as file:
    program = file.read()

#EXTRACTIONG AND FORMATING THE INSTRUCTIONS
instructions = ''.join(f'memory[{index}] = `{instruction[0]} \n' 
                       for index,instruction in 
                       enumerate(find_instruction.findall(program)))
instructions = args.body_marker + '\n' + instructions[:-1] + '\n' + args.body_marker

#OPENING THE PROGRAM MEMORY MODULE
program_memory_module = ""
with open(args.program_memory_path, "r") as file:
    program_memory_module = file.read()

#UPDATING THE PROGRAM BODY
program_memory_module = find_program_body.sub(instructions,program_memory_module)


#SAVING THE NEW PROGRAM BODY
with open(args.program_memory_path, "w") as file:
    file.write(program_memory_module)

