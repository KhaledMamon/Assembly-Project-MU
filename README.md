# DOOR OS (x86 Assembly Project)
DOOR OS is a simple, command-line operating system simulation developed in x86 Assembly Language using the emu8086 emulator. This project demonstrates low-level programming concepts, interrupt handling, and direct hardware interaction simulation.

# 🚀 Project Overview
The main goal of this project is to simulate the core functionality of a shell interface (CLI). It parses user inputs, executes specific system commands, and manages screen output using BIOS and DOS interrupts. It also features an integrated arithmetic calculator.

# ✨ Key Features
## 1. Interactive Command Shell
A responsive CLI (Command Line Interface) that prompts the user (Root@System:/>) and waits for input.

Command Parsing: Custom string comparison logic to validate and route user commands.

## 2. System Commands
#### 2.1) help: Displays a menu of all available commands.

#### 2.2) cls: Clears the terminal screen (Video Memory).

#### 2.3) time: Fetches and displays the current system time (HH:MM:SS).

#### 2.4) date: Fetches and displays the current system date (DD/MM/YY).

#### 2.5) exit: Safely terminates the operating system simulation.

## 3. Integrated Calculator (calc)
A fully functional single-digit calculator built from scratch:

Supports Addition (+), Subtraction (-), Multiplication (*), and Division (/).

Negative Number Handling: Correctly displays negative results (e.g., 3 - 5 = -2).

Error Handling: Detects and prevents Division by Zero errors.

ASCII Conversion: Manually converts ASCII input to Integers and back for display.

# 🛠️ Technical Implementation Details
Language: Assembly x86 (Real Mode).

Architecture: .model small, 16-bit.

Interrupts Used:

INT 10h: For Video Services (Clearing screen, setting cursor position).

INT 21h: For DOS Services (String output, Buffered input, System Time/Date).

Memory Management:

Uses the Stack (PUSH/POP) to preserve register states during procedure calls.

Manual buffer management for user input processing (adding Null Terminators).

Procedures: Modular code structure using procedures for repetitive tasks like clear_screen, strcmp, and print_2digits.

💻 How to Run
Download or clone this repository.

Open the source file (.asm) in emu8086.

Click Emulate and then Run.

Type help in the simulator window to see the commands.
