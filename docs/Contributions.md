# Contributing to Flappy Bird (x86 Assembly)

Thank you for your interest in contributing to this project. Contributions that improve code quality, documentation, performance, or learning value are welcome.

This project is primarily **educational**, so clarity, correctness, and maintainability are prioritized over feature complexity.

---

## How to Contribute

You can contribute in several ways:

* Fix bugs or edge cases in gameplay logic
* Improve code readability and comments
* Optimize assembly routines (graphics, collision, timing)
* Add optional features (sound, difficulty levels, UI polish)
* Improve documentation (README, comments, diagrams)

---

## Getting Started

1. **Fork** the repository
2. **Clone** your fork locally
3. Make sure you can assemble and run the game using DOSBox
4. Create a new branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

---

## Coding Guidelines

When modifying `Flappy_Bird.asm`, please follow these guidelines:

* Use **clear and consistent labels**
* Add **comments** for non-trivial logic (especially ISR and math operations)
* Preserve **real-mode compatibility** (16-bit instructions only)
* Avoid unnecessary macros or assembler-specific extensions
* Keep register usage explicit and balanced (push/pop symmetry)

If adding new routines:

* Document input/output registers
* Clearly state side effects
* Restore all registers unless intentionally modified

---

## Commit Guidelines

* Write clear, descriptive commit messages
* One logical change per commit when possible

**Good examples:**

* `Fix collision detection at screen boundaries`
* `Refactor pillar scrolling logic for readability`

---

## Testing

Before submitting a pull request:

* Assemble and link without warnings or errors
* Test gameplay in DOSBox for:

  * Movement correctness
  * Collision detection
  * Pause / resume behavior
  * Score accuracy

---

## Submitting a Pull Request

1. Push your branch to your fork
2. Open a Pull Request against the `main` branch
3. Clearly describe:

   * What you changed
   * Why the change is needed
   * Any limitations or known issues

Screenshots or short clips (from DOSBox) are appreciated for gameplay changes.

---

## Code of Conduct

Be respectful and constructive. This is a learning-focused project, and discussions should remain professional and inclusive.

---

## Questions

If you’re unsure about an approach or want to propose a major change, open an issue first to discuss it.

Happy hacking!
