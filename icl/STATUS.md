# ICL Guix Packaging - Current Status

## Completed Steps

### 1. ✓ Dependency Analysis
- Retrieved `icl.asd`, `ocicl.csv`, and `Makefile` from upstream repository
- Identified 8 direct dependencies
- Documented full transitive dependency tree (48 packages)

### 2. ✓ Guix Package Availability Check
Found in Guix (6/8 direct deps):
- sbcl-alexandria ✓
- sbcl-cffi ✓
- sbcl-clingon ✓
- sbcl-osicat ✓
- sbcl-split-sequence ✓
- sbcl-termp ✓

Missing from Guix (2/8):
- sbcl-slynk-client (packaged locally)
- sbcl-version-string (packaged locally)

### 3. ✓ Package Definitions Created

**icl-package.scm** - Main ICL package
- Correct source hash: `0sx3lwa6ca73rl6x1af3axs5nk3xq55mjf3ks6babbz2f273rf5l`
- All dependencies declared as inputs
- Uses gnu-build-system
- Build and install phases defined

**sbcl-version-string.scm** - New dependency package
- Source: https://github.com/atgreen/cl-version-string
- Commit: 668f2fa091fccb257ba207e562f2f826dce61991
- Version: 1.0.1-0
- License: MIT
- No dependencies
- Includes ECL and CL variants

**sbcl-slynk-client.scm** - New dependency package
- Source: https://github.com/Shookakko/slynk-client
- Commit: f232d4dbbed03ff62ef8419eea580d2dfb9999de
- Version: 1.6-0
- License: GPL-2.0
- Dependencies: sbcl-alexandria, sbcl-bordeaux-threads, sbcl-slynk, sbcl-usocket
- Includes ECL and CL variants

## Files Created

```
icl/
├── DEPENDENCIES.md          # Full dependency list from upstream
├── DEPENDENCY-STATUS.md     # Mapping to Guix packages
├── PACKAGING-GUIDE.md       # General Guix packaging guide
├── TODO.md                  # Original TODO list
├── STATUS.md                # This file
├── icl-package.scm          # Main ICL package definition
├── sbcl-version-string.scm  # version-string package
└── sbcl-slynk-client.scm    # slynk-client package
```

## Next Steps

### 1. Test Build the Dependency Packages

First, build the new dependencies to ensure they work:

```bash
# Build version-string
guix build -f sbcl-version-string.scm

# Build slynk-client
guix build -f sbcl-slynk-client.scm
```

### 2. Address ICL Build System

The current `icl-package.scm` has a simplified build phase. We need to:

1. Examine how the Makefile uses ASDF
2. Set up `CL_SOURCE_REGISTRY` or `ASDF_OUTPUT_TRANSLATIONS` to find deps
3. Possibly patch the Makefile to remove `ocicl` references
4. Ensure the standalone binary includes all necessary runtime dependencies

Key challenge from Makefile:
```bash
sbcl --eval '(push #p"ocicl/" asdf:*central-registry*)'
```

This expects dependencies in `ocicl/` directory. We need to:
- Map Guix store paths to ASDF's source registry
- Ensure the build can find all CL systems

### 3. Test Build ICL

```bash
guix build -f icl-package.scm
```

Expected issues:
- ASDF may not find dependencies
- Makefile may try to run `ocicl install`
- Standalone binary creation may need special handling

### 4. Iterate and Fix

Based on build errors:
- Add missing runtime dependencies
- Patch build system if needed
- Adjust phases for proper ASDF configuration

### 5. Integration

Once working:
- Submit sbcl-version-string to Guix upstream (gnu/packages/lisp-xyz.scm)
- Submit sbcl-slynk-client to Guix upstream (gnu/packages/lisp-xyz.scm)
- Submit ICL package to Guix upstream (appropriate location)
- Or maintain in personal Guix channel

## Build System Notes

ICL uses `asdf:make` which creates a standalone executable. This is different
from typical CL libraries. The build system needs to:

1. Make all dependencies available to ASDF
2. Allow SBCL to compile and load the system
3. Create the standalone binary via `asdf:make :icl`
4. Install the resulting `icl` binary

The current approach uses `gnu-build-system`, but we may need to:
- Use a hybrid approach with custom phases
- Or potentially use `asdf-build-system/sbcl` with customizations
- Set environment variables for ASDF source location

## Testing Checklist

Once built:
- [ ] Binary exists and is executable
- [ ] Binary runs without errors
- [ ] Can connect to a Slynk server
- [ ] REPL features work (completion, history, etc.)
- [ ] No runtime dependency errors
- [ ] Works in pure Guix environment
