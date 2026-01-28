# Flappy Bird (x86 Assembly)

A **DOS-based Flappy Bird clone written entirely in 16-bit x86 Assembly**. This project demonstrates low-level game development concepts such as direct video memory manipulation, keyboard interrupt handling, timer-based animation, and collision detection using BIOS and hardware interrupts.

The game runs in real mode and renders directly to VGA text-mode memory, making it an educational example for students learning **Computer Organization, Assembly Language, and low-level systems programming**.

---

## What This Project Does

* Implements a playable **Flappy Bird-style game** in x86 Assembly
* Uses **VGA text mode (0xB800)** for graphics
* Handles **keyboard input via custom ISR** (Up key, Escape, Y/N)
* Uses **timer interrupt** for gravity and animation timing
* Implements **collision detection**, scoring, pause menu, and end-game screen

---

## Why This Project Is Useful

This project is useful for developers and students who want to:

* Learn **low-level game loops** without high-level libraries
* Understand **interrupt handling (INT 8, INT 9)**
* Practice **direct memory access** for graphics
* Study **real-mode DOS programming**
* Explore how classic games can be implemented with minimal resources

It is especially valuable as a **semester project or reference implementation** for Assembly Language courses.

---

## Getting Started

### Prerequisites

To build and run this project, you need:

* **DOSBox** (recommended)
* **MASM** or **TASM** assembler
* A system capable of running 16-bit DOS programs

---

### Build Instructions

1. Place the source file in your DOSBox working directory:

   ```
   Flappy_Bird.asm
   ```

2. Assemble the program:

   ```bash
   masm Flappy_Bird.asm;
   ```

3. Link the object file:

   ```bash
   link Flappy_Bird.obj;
   ```

4. Run the executable:

   ```bash
   Flappy_Bird.exe
   ```

---

### Controls

| Key          | Action                  |
| ------------ | ----------------------- |
| ↑ (Up Arrow) | Bird moves upward       |
| Release Up   | Bird falls downward     |
| Esc          | Pause game (Y/N prompt) |
| Y            | Quit game               |
| N            | Resume game             |

---

## Gameplay Overview

* The bird is affected by gravity via the **timer interrupt**
* Pillars scroll horizontally from right to left
* Passing a pillar increases the score
* Collision with pillars or ground ends the game

---

## Project Structure

```
.
├── Flappy_Bird.asm   # Complete game source code
└── README.md         # Project documentation
```

---

## Technical Highlights

* **Graphics**: VGA text mode (80×25) via segment `0xB800`
* **Input**: Keyboard ISR (INT 9)
* **Timing**: Timer ISR (INT 8)
* **Rendering**: Manual screen redraw with vertical retrace sync
* **Scoring**: Numeric rendering using division-based digit extraction

---

## Getting Help

If you need help:

* Review inline comments inside `Flappy_Bird.asm`
* Consult x86 Assembly references (BIOS interrupts, VGA memory)
* Use DOSBox debugger for stepping through execution

For conceptual help, search topics like:

* `INT 10h video services`
* `INT 9 keyboard ISR`
* `Real mode memory segmentation`

---

## Maintainers

Maintained by:

* **Mahhee Ibn Ahmar Bukhari**

Originally developed as an academic project.

##
