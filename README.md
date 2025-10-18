# Memory Fragments - The Last Witness

A mystery thriller visual novel game with reverse chronological storytelling.

## Game Overview

**Genre**: Mystery Thriller Visual Novel  
**Platform**: PC (Godot Engine)  
**Play Time**: 7-8 hours

## Story

Detective Lee Jun-hyuk wakes up on an abandoned building's rooftop with no memory. A bloodied gun in his hand, a body at his feet. As sirens approach, he must piece together the truth by traveling backwards through his memories.

The game starts at Chapter 5 (the ending) and progresses in reverse chronological order through Chapter 1 (the beginning), revealing the truth piece by piece.

## Core Gameplay Systems

### 1. Clue Collection
Investigate scenes to collect evidence:
- Physical evidence (weapons, documents)
- Digital evidence (messages, call logs)
- Testimonies (important dialogue information)
- Observations (scene contradictions)

### 2. Memory Connection (Deduction Board)
At the end of each chapter, place collected clues on a timeline and connect related evidence. When contradictions are found, solve deduction puzzles to unlock new clues.

### 3. Trust System
Your deduction accuracy affects the trust meter:
- 80%+: True ending conditions met
- 50-79%: Normal ending
- Below 50%: Bad ending

### 4. Evidence Presentation
Ace Attorney-style moments where you must present the right evidence from your inventory during conversations.

## Development Status

🎮 **Prototype Phase** - Basic dialogue system implemented

### Completed Features
- ✅ GameManager core system
- ✅ Dialogue system with typing effect
- ✅ Choice system
- ✅ Chapter 5 prologue dialogue (3 branching paths)

### In Progress
- 🚧 Trust system
- 🚧 Clue collection system
- 🚧 Memory connection board

### Coming Soon
- 📋 Full Chapter 5 content
- 📋 Save/Load system
- 📋 UI polish and visual assets

## Technology Stack

- **Engine**: Godot 4.3
- **Language**: GDScript
- **Resolution**: 1920x1080 (16:9)

## Project Structure

```
memory-fragments/
├── scenes/           # Scene files (.tscn)
│   ├── Main.tscn            # Main game scene
│   └── DialogueSystem.tscn  # Dialogue UI
├── scripts/          # GDScript files
│   ├── core/                # Core systems
│   │   └── GameManager.gd
│   └── dialogue/            # Dialogue system
│       └── DialogueSystem.gd
├── data/             # Game data (dialogues, clues)
│   └── dialogues/
│       └── chapter_5/
│           └── rooftop_01.json
└── assets/           # Art, audio, UI elements
```

## Getting Started

### Prerequisites
- [Godot 4.3+](https://godotengine.org/download)

### Running the Prototype
1. Clone this repository
   ```bash
   git clone https://github.com/jaykop/memory-fragments.git
   ```
2. Open the project in Godot
3. Press F5 or click "Run Project"

### Controls
- **Enter/Space**: Advance dialogue
- **Mouse Click**: Select choices

## How to Play the Prototype

1. The game starts at the prologue (Chapter 5 - Rooftop scene)
2. Read through the dialogue by pressing Enter or Space
3. When choices appear, click on your preferred option
4. Each choice affects the "trust" system (currently logged in console)
5. The prologue has 3 different paths based on your first choice:
   - Investigate the gun
   - Check the body
   - Run away immediately

## License

TBD

## Credits

Developed by jaykop

---

## Design Documents

📄 [Game Design Document (Notion)](https://www.notion.so/Memory-Fragments-The-Last-Witness-290a22726e068105a5d0caeb5283e44c)
