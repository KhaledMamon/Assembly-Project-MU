# DOOR OS (x86 Assembly Project)
DOOR OS is a simple, command-line operating system simulation developed in x86 Assembly Language using the emu8086 emulator.

# Project Overview
The main goal of this project is to simulate the core functionality of a shell interface (CLI). It parses user inputs, executes specific system commands, and manages screen output using BIOS and DOS interrupts. It also features an integrated arithmetic calculator.

# Key Features
## 1. Interactive Command Shell
A responsive CLI (Command Line Interface) that prompts the user (Root@System:/>) and waits for input.

## 2. System Commands
#### 2.1) help: Displays a menu of all available commands.

#### 2.2) clean: Clears the terminal screen (Video Memory).

#### 2.3) time: Fetches and displays the current system time (HH:MM:SS).

#### 2.4) date: Fetches and displays the current system date (DD/MM/YY).

#### 2.5) calc: Supports Addition (+), Subtraction (-), Multiplication (*), and Division (/).

#### 2.6) exit: Safely terminates the operating system simulation.

## 3. Calculator (calc)
- A fully functional single-digit (only one number) calculator 

- Negative Number Handling: Correctly displays negative results (e.g., 3 - 5 = -2).

- Error Handling: Detects and prevents Division by Zero errors.

- ASCII Conversion: Manually converts ASCII input to Integers and back for display.

# Technical Implementation Details
Language: Assembly x86 (Real Mode).

Architecture: .model small, 16-bit.

Interrupts Used:

1. INT 10h: For Video Services (Clearing screen).

2. INT 21h: For DOS Services (String output, Buffered input, System Time/Date).

Memory Management: Uses the Stack (PUSH/POP) to preserve register states during procedure calls.

Procedures: Modular code structure using procedures for repetitive tasks like clear_screen, strcmp, and print_2digits.




