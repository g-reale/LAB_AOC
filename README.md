<p align="center">
  <strong>Computer Architecture and Organization Laboratory - Custom Processor in Verilog</strong>
</p>

This repository contains the implementation of a **general-purpose processor** developed in Verilog for the Computer Architecture and Organization laboratory course at the Federal University of São Paulo. The processor is designed for simulation with Icarus Verilog and synthesis on FPGA via Quartus, supporting I, J, and R type instructions — inspired by the MIPS architecture. The repository also includes an audio processing extension developed for Arduino.

## Objective

- Design and implement a complete processor in HDL (Verilog).
- Understand the execution pipeline: instruction fetch, instruction decode, execute, memory access, and write back.
- Simulate the processor's operations using Verilog testbenches.
- Synthesize and test the processor on FPGA hardware (Altera/Intel via Quartus).

## Technologies Used

- **HDL Language:** Verilog (2009 standard)
- **Simulation:** Icarus Verilog (`iverilog`) with GTKWave support
- **Synthesis (FPGA):** Quartus (Altera/Intel)
- **Assembly Programming:** Python script (`expandProg.py`) for preprocessing
- **Audio Extension:** Arduino + Verilog (inside the `arduino/` folder)
- **Operating System:** Linux

## Project Structure

```bash
LAB_AOC/
├── processor.v           # Main module — integrates all components
├── control_unit.v        # Control unit — decodes instructions
├── arithimetic_logic_unit.v  # ALU — executes arithmetic and logical operations
├── register_bank.v       # Register bank
├── random_acess_memory.v # RAM — reads and writes data
├── program_memory.v      # Program memory (instructions)
├── program_counter.v     # Program counter (PC)
├── decoders.v            # Instruction decoders (type I, J, R)
├── clock_divider.v       # Clock divider (for FPGA)
├── precompiler.v         # Instruction precompiler
├── seven_segment_decoder.v # Decoder for 7-segment display
├── constants.v           # Opcode, type, and macro definitions
├── testbench.v           # Testbench for simulation
├── run.sh                # Compilation and simulation script
├── expand.sh             # Program expansion script
├── runUnitTests.py       # Automated unit tests in Python
├── pins.txt              # Pin mapping for FPGA
├── build/                # Files generated during compilation
├── quartus/              # Quartus project for FPGA synthesis
└── arduino/              # Audio processing extension in Arduino/Verilog
    ├── processor.v       # Adapted processor for audio
    ├── audio.v           # Audio output module
    ├── lcd.v             # LCD display controller
    ├── ram.v             # Adapted RAM memory
    ├── run.sh            # Audio processor simulation script
    └── ...
```

## Processor Architecture

The processor implements three instruction types:

| Type | Usage |
|------|-------|
| **I** (Immediate) | Operations with immediates, load/store, branches |
| **J** (Jump) | Unconditional jumps and function calls (`jal`) |
| **R** (Register) | Register-to-register operations (ALU) |

**Key Components:**

- **Control Unit:** Decodes instructions and generates control signals for each component (ALU, RAM, register bank, PC).
- **ALU:** Executes 15 operations: ADD, SUB, MUL, DIV, AND, OR, NOR, XOR, shift left/right, and comparisons (SLT, SEQ, SNQ, and their negated variants).
- **Register Bank:** Reads up to 3 registers and writes to 1 register per clock cycle.
- **RAM:** 4096 positions of 32 bits. Special ("magic") addresses connect to peripherals (7-segment displays and switches).
- **PC:** Supports 3 modes — normal (step +1), modified reference (jump), and modified step (branch).

## How to Run the Project

### Simulation with Icarus Verilog

```bash
git clone https://github.com/g-reale/LAB_AOC.git
cd LAB_AOC

# Run full simulation
./run.sh
```

The `run.sh` script:
1. Preprocesses the Assembly program using `expandProg.py`.
2. Compiles all Verilog files with `iverilog`.
3. Runs the simulation and displays the results in the terminal.

### Unit Tests

```bash
python3 runUnitTests.py
```

### FPGA Synthesis (Quartus)

1. Open Quartus and load the project from the `quartus/` folder.
2. Compile the project and map pins according to `pins.txt`.
3. Program the FPGA.

## Environment Setup

- **Icarus Verilog:** `sudo apt-get install iverilog`
- **Python 3** (for `runUnitTests.py` and `expandProg.py`)
- **GTKWave** (optional, for waveform visualization): `sudo apt-get install gtkwave`
- **Quartus** (for FPGA synthesis): available on the Intel/Altera website

```bash
# Verify iverilog installation
iverilog -V
```

## Workflow

1. An Assembly program is written and preprocessed by the Python script, writing the instructions into the program memory (`program_memory.v`).
2. The simulation starts via `run.sh`: the PC begins at 0 and fetches instructions sequentially.
3. The Control Unit decodes each instruction and asserts the corresponding control signals.
4. The ALU executes the operation, and the result is written to the register bank or RAM.
5. The PC is updated (normal increment, jump, or branch) for the next instruction.

## Notes

- Special (magic) RAM addresses connect directly to the FPGA peripherals (displays and switches) without requiring separate I/O modules.
- The `precompiler.v` module allows extensions to the instruction set without modifying the processor core.
- The `arduino/` subdirectory contains an extension of the processor adapted for audio reproduction with an LCD, developed collaboratively.

---

<p align="center">
  <strong>Laboratório de Arquitetura e Organização de Computadores - Processador Customizado em Verilog</strong>
</p>

Este repositório contém a implementação de um **processador de propósito geral** desenvolvido em Verilog como projeto do laboratório de Arquitetura e Organização de Computadores realizada na Universidade Federal de São Paulo. O processador é projetado para simulação com Icarus Verilog e síntese em FPGA via Quartus, com suporte a instruções dos tipos I, J e R — inspirado na arquitetura MIPS. O repositório inclui também uma extensão de processamento de áudio desenvolvida para Arduino.

## Objetivo

- Projetar e implementar um processador completo em HDL (Verilog).
- Entender o pipeline de execução: busca de instrução, decodificação, execução, acesso à memória e escrita de resultado.
- Simular o funcionamento do processador com testbenches em Verilog.
- Sintetizar e testar o processador em hardware FPGA (Altera/Intel via Quartus).

## Tecnologias Utilizadas

- **Linguagem HDL:** Verilog (padrão 2009)
- **Simulação:** Icarus Verilog (`iverilog`) com suporte a GTKWave
- **Síntese (FPGA):** Quartus (Altera/Intel)
- **Programação Assembly:** script Python (`expandProg.py`) para pré-processamento
- **Extensão de áudio:** Arduino + Verilog (pasta `arduino/`)
- **Sistema operacional:** Linux

## Estrutura do Projeto

```bash
LAB_AOC/
├── processor.v           # Módulo principal — integra todos os componentes
├── control_unit.v        # Unidade de controle — decodifica instruções
├── arithimetic_logic_unit.v  # ALU — executa operações aritméticas e lógicas
├── register_bank.v       # Banco de registradores
├── random_acess_memory.v # RAM — leitura e escrita de dados
├── program_memory.v      # Memória de programa (instruções)
├── program_counter.v     # Contador de programa (PC)
├── decoders.v            # Decodificadores de instruções (tipo I, J, R)
├── clock_divider.v       # Divisor de clock (para FPGA)
├── precompiler.v         # Pré-compilador de instruções
├── seven_segment_decoder.v # Decodificador para display de 7 segmentos
├── constants.v           # Definições de opcodes, tipos e macros
├── testbench.v           # Testbench para simulação
├── run.sh                # Script de compilação e simulação
├── expand.sh             # Script de expansão de programa
├── runUnitTests.py       # Testes unitários automatizados em Python
├── pins.txt              # Mapeamento de pinos para FPGA
├── build/                # Arquivos gerados pela compilação
├── quartus/              # Projeto Quartus para síntese em FPGA
└── arduino/              # Extensão de processamento de áudio em Arduino/Verilog
    ├── processor.v       # Processador adaptado para áudio
    ├── audio.v           # Módulo de saída de áudio
    ├── lcd.v             # Controlador de display LCD
    ├── ram.v             # Memória RAM adaptada
    ├── run.sh            # Script de simulação do processador de áudio
    └── ...
```

## Arquitetura do Processador

O processador implementa três tipos de instrução:

| Tipo | Uso |
|------|-----|
| **I** (Immediate) | Operações com imediatos, load/store, branches |
| **J** (Jump) | Saltos incondicionais e chamadas de função (`jal`) |
| **R** (Register) | Operações entre registradores (ALU) |

**Componentes principais:**

- **Unidade de Controle:** Decodifica a instrução e gera os sinais de controle para cada componente (ALU, RAM, banco de registradores, PC).
- **ALU:** Executa 15 operações: ADD, SUB, MUL, DIV, AND, OR, NOR, XOR, shift left/right, comparações (SLT, SEQ, SNQ e variantes negadas).
- **Banco de Registradores:** Leitura de 3 registradores e escrita em 1 por ciclo de clock.
- **RAM:** 4096 posições de 32 bits. Endereços especiais ("mágicos") conectam periféricos (displays de 7 segmentos e switches).
- **PC:** Suporta 3 modos — normal (step +1), referência modificada (jump) e step modificado (branch).

## Como Executar o Projeto

### Simulação com Icarus Verilog

```bash
git clone https://github.com/g-reale/LAB_AOC.git
cd LAB_AOC

# Executar simulação completa
./run.sh
```

O script `run.sh`:
1. Pré-processa o programa Assembly com `expandProg.py`.
2. Compila todos os arquivos Verilog com `iverilog`.
3. Executa a simulação e exibe o resultado no terminal.

### Testes Unitários

```bash
python3 runUnitTests.py
```

### Síntese em FPGA (Quartus)

1. Abra o Quartus e carregue o projeto da pasta `quartus/`.
2. Compile o projeto e realize o mapeamento de pinos conforme `pins.txt`.
3. Programe a FPGA.

## Configuração do Ambiente

- **Icarus Verilog:** `sudo apt-get install iverilog`
- **Python 3** (para `runUnitTests.py` e `expandProg.py`)
- **GTKWave** (opcional, para visualização de formas de onda): `sudo apt-get install gtkwave`
- **Quartus** (para síntese FPGA): disponível no site da Intel/Altera

```bash
# Verificar instalação do iverilog
iverilog -V
```

## Fluxo de Funcionamento

1. Um programa Assembly é escrito e pré-processado pelo script Python, inserindo as instruções na memória de programa (`program_memory.v`).
2. A simulação é iniciada via `run.sh`: o PC começa em 0 e busca instruções sequencialmente.
3. A Unidade de Controle decodifica cada instrução e ativa os sinais correspondentes.
4. A ALU executa a operação e o resultado é escrito no banco de registradores ou na RAM.
5. O PC é atualizado (incremento normal, jump ou branch) para a próxima instrução.

## Observações

- Endereços de RAM especiais (mágicos) conectam-se aos periféricos do FPGA (displays e switches) sem necessidade de módulos de I/O separados.
- O módulo `precompiler.v` permite extensões ao conjunto de instruções sem modificar o núcleo do processador.
- O subdirectório `arduino/` contém uma extensão do processador adaptada para reprodução de áudio com LCD, desenvolvida em conjunto.