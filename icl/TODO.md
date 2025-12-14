# ICL Guix Packaging - TODO

## Immediate Tasks

### [ ] 1. Get Dependency Information
Without network access to the repo, we need the contents of:
- `icl.asd` - ASDF system definition
- `ocicl.csv` - ocicl dependency manifest
- `Makefile` - Build instructions

Options:
a) You download these files and share them
b) Use web search to find them (if publicly viewable)
c) Work from release tarball instead of git

### [ ] 2. Map Dependencies to Guix Packages

Once we have the dep list, create a table:

| ICL Dependency    | Guix Package       | Status       | Notes                |
|-------------------|--------------------|--------------|----------------------|
| slynk             | sbcl-slynk         | ✓ exists     | Version 1.0.43       |
| osicat            | sbcl-osicat        | ✓ exists     | Needs libfixposix    |
| libfixposix       | libfixposix        | ✓ exists     | C library            |
| cl-readline (?)   | sbcl-cl-readline(?)| ? unknown    | Need to check        |
| cl-ansi-text (?)  | ?                  | ? unknown    | Terminal colors?     |
| ...               | ...                | ? unknown    | Fill in from .asd    |

### [ ] 3. Package Missing Dependencies

For each missing CL library:
- [ ] Create `sbcl-<lib>.scm` package definition
- [ ] Identify its dependencies recursively
- [ ] Test build independently
- [ ] (Optional) Create cl- and ecl- variants

### [ ] 4. Understand ICL's Build Process

Key questions:
- How does the Makefile invoke SBCL?
- Does it use `ocicl install` (needs patching)?
- Does it create a core image or executable?
- What compilation flags are used?

### [ ] 5. Write the ICL Package

- [ ] Choose appropriate build system (gnu-build-system likely)
- [ ] Set up build phases to:
  - Delete configure step
  - Replace build step (set ASDF registry, invoke make)
  - Replace install step (copy binary)
- [ ] Declare all inputs correctly
- [ ] Write synopsis and description

### [ ] 6. Test and Refine

- [ ] Build the package: `guix build -f icl.scm`
- [ ] Run the binary
- [ ] Test basic functionality
- [ ] Check for missing runtime dependencies
- [ ] Ensure it works in a pure environment

## Information Needed From You

To proceed, I need:

1. **Either:**
   - Contents of `icl.asd`, `ocicl.csv`, and `Makefile`, OR
   - Permission to fetch the v1.2.0 release tarball

2. **Your preference:**
   - Package just for SBCL? Or also ECL/CCL/others?
   - Any specific Guix channel to target? (upstream Guix, your own channel)

3. **Testing environment:**
   - Do you have Guix installed to test builds?
   - Or should I provide commands for a Guix container?

## Notes on Guix Philosophy

The Guix way differs from traditional packaging:
- No "run this script to fetch dependencies"
- Everything declarative and reproducible
- All dependencies must be Guix packages
- Builds happen in isolated environments

This means more upfront work (packaging dependencies), but the result is
a package that will build identically in 10 years, assuming source
availability.

The payoff: complete control, bit-for-bit reproducibility, and the ability
to compose ICL with other Guix packages in precise ways.
