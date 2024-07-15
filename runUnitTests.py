from random import randrange
import subprocess 
import re

#REGEX TO FILTER NUMBERS FROM THE COMMAND LINE OUPUT
find_numbers = re.compile(r'[+-]?\d+')

#RANDOM VALUES FOR UNIT TEST

#ENSURES THAT THE A, B AND C ADRESSES ARE UNIQUE
ADR_A = randrange(31)
ADR_B = randrange(31)
ADR_C = randrange(31)

while ADR_B == ADR_A:
    ADR_B = randrange(31)

while ADR_C == ADR_A or ADR_C == ADR_B: 
    ADR_C = randrange(31)

#ENSURES THAT THE A VALUE IS BIGGER THAN THE B VALUE (IMPORTANT ASSUPTION)
A = randrange(2048)
B = randrange(2048)
while A < B:
    A = randrange(2048)
    B = randrange(2048)

#ENSURES THE SHIFT AMOUNT TO BE 0 OR 1
SHAMFT = randrange(2)


testList = []

def run(program):
    with open('build/prog.asm','w') as file:
        file.write(program)

    result = subprocess.run(
        ['./run.sh'],
        capture_output = True
    ).stdout
    result = result.decode("utf8")
    result = find_numbers.findall(result)
    return [int(x) for x in result]

def unitTest(test):
    def wrapper():
        ANSI_BOLD_YELLOW = "\033[1m\033[33m"
        ANSI_BOLD_GREEN = "\033[1m\033[32m"
        ANSI_BOLD_RED = "\033[1m\033[31m"
        ANSI_RESET = "\033[0m"
        GO_NOGO = [f'{ANSI_BOLD_RED}FAIL{ANSI_RESET}',f'{ANSI_BOLD_GREEN}OK{ANSI_RESET}']

        passed, answer, result = test()
        print(f'{ANSI_BOLD_YELLOW}{test.__name__}(){ANSI_RESET}\t\t{GO_NOGO[passed]}')
        if not passed:
            print(f'answer: {answer}')
            print(f'result: {result}')
    
    testList.append(wrapper)
    return wrapper

@unitTest
def testADDI():
    answer = [A, A+B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSUBI():
    answer = [A, A-B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    SUBI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testMULI():
    answer = [A, A*B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    MULI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testDIVI():
    answer = [A, A//B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    DIVI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testANDI():
    answer = [A, A&B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ANDI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testORI():
    answer = [A, A|B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ORI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testNORI():
    answer = [A, ~(A|B) + (1 << 32)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    NORI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testXORI():
    answer = [A, A^B]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    XORI({ADR_A},{ADR_A},{B});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSFLI():
    answer = [A, A<<SHAMFT]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    SFLI({ADR_A},{ADR_A},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSFRI():
    answer = [A, A>>SHAMFT]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    SFRI({ADR_A},{ADR_A},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSLTI():
    answer = [A, B, 0, 1]
    program = f'''
    ADDI({ADR_A},0,{A});
    ADDI({ADR_B},0,{B});
    SLTI({ADR_A},{ADR_A},{B});
    SLTI({ADR_B},{ADR_B},{A});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testBEQ():
    answer = [2, 4294967294]
    program = f'''
    BEQ({ADR_A},{ADR_B},2);
    ADDI({ADR_A},{ADR_A},10);
    BEQNEG({ADR_A},{ADR_B},2);
    '''
    result = run(program)
    return set(answer) == set(result), answer, result

@unitTest
def testBNQ():
    answer = [A, B, 2, 4294967294]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    BNQ({ADR_A},{ADR_B},2);
    ADDI({ADR_A},{ADR_A},10);
    BNQNEG({ADR_A},{ADR_B},2);
    '''
    result = run(program)
    return set(answer) == set(result), answer, result

@unitTest
def testSTORELOAD():
    answer = [A, B, B + B, B + B, A]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    STORE({ADR_A},{ADR_B},{B});
    LOAD({ADR_B},{ADR_B},{B});
    ADDI({ADR_B},{ADR_B},0);
    '''
    result = run(program)
    return set(answer) == set(result), answer, result

@unitTest
def testADD():
    answer = [A, B, ((A + B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    ADD({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSUB():
    answer = [A, B, ((A - B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    SUB({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testMUL():
    answer = [A, B, ((A * B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    MUL({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testDIV():
    answer = [A, B, ((A // B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    DIV({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testAND():
    answer = [A, B, ((A & B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    AND({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testOR():
    answer = [A, B, ((A | B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    OR({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testNOR():
    answer = [A, B, (~(A | B) << SHAMFT) + (1 << 32)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    NOR({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testXOR():
    answer = [A, B, ((A ^ B) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    XOR({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSFL():
    answer = [A, SHAMFT, ((A << SHAMFT) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{SHAMFT});
    SFL({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSFR():
    answer = [A, SHAMFT, ((A >> SHAMFT) << SHAMFT)]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{SHAMFT});
    SFR({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testSLT():
    answer = [A, B, 0, 1 << SHAMFT]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},{B});
    SLT({ADR_C},{ADR_A},{ADR_B},{SHAMFT});
    SLT({ADR_C},{ADR_B},{ADR_A},{SHAMFT});
    '''
    result = run(program)
    return answer == result, answer, result

@unitTest
def testJR():
    answer = set([1])
    program = f'''
    ADDI({ADR_A},{ADR_A},1);
    JR({ADR_A});
    '''
    result = run(program)
    return answer == set(result), answer, result

@unitTest
def testJALR():
    answer = [1, 0, B, 1, 3, B + 3]
    program = f'''
    ADDI({ADR_A},{ADR_A},1);
    ADDI({ADR_B},{ADR_B},0);
    ADDI({ADR_B},{ADR_B},{B});
    JALR({ADR_B},{ADR_A});
    '''
    result = run(program)
    return answer == result[0:len(answer)], answer, result

@unitTest
def testJMP():
    answer = [A,0,1,0,1]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({ADR_B},{ADR_B},0);
    JMP(1);
    '''
    result = run(program)
    return answer == result[0:len(answer)], answer, result

@unitTest
def testJAL():
    answer = [A,0,1,2,1]
    program = f'''
    ADDI({ADR_A},{ADR_A},{A});
    ADDI({31},{31},0);
    JAL(1);
    '''
    result = run(program)
    return answer == result[0:len(answer)], answer, result



if __name__ == '__main__':
    print("PARAMETERS: ")
    print("ADR_A = ",ADR_A)
    print("ADR_B = ",ADR_B)
    print("ADR_C = ",ADR_C),
    print("A = ",A)
    print("B = ",B)
    print("SHAMFT = ",SHAMFT)
    for test in testList:
        test()

