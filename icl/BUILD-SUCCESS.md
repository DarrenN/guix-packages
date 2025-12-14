# ICL Guix Package - Build Success! 🎉

## Summary

Successfully created Guix packages for ICL (Interactive Common Lisp) and its missing dependencies.

**Build Date:** December 14, 2025
**ICL Version:** 1.2.0
**Build Output:** `/gnu/store/yf0aj0nwa8knnihg07g77xljnybra3n7-icl-1.2.0`

## Packages Created

### 1. sbcl-version-string (NEW)
- **Version:** 1.0.1-0.668f2fa
- **Source:** https://github.com/atgreen/cl-version-string
- **License:** MIT
- **Status:** ✅ Built successfully
- **Store Path:** `/gnu/store/w6ahiv0wwlyi9lsavlb6mz280vkv972a-sbcl-version-string-1.0.1-0.668f2fa`

### 2. sbcl-slynk-client (NEW)
- **Version:** 1.6-0.f232d4d
- **Source:** https://github.com/Shookakko/slynk-client
- **License:** GPL-2.0
- **Dependencies:** alexandria, bordeaux-threads, slynk, usocket
- **Status:** ✅ Built successfully
- **Store Path:** `/gnu/store/hxx8k1vk59yc1qzg7mbbm8ky572ilq12-sbcl-slynk-client-1.6-0.f232d4d`

### 3. icl (NEW)
- **Version:** 1.2.0
- **Source:** https://github.com/atgreen/icl
- **License:** MIT
- **Dependencies:** 8 direct + 3 transitive
- **Status:** ✅ Built successfully with executable binary
- **Store Path:** `/gnu/store/yf0aj0nwa8knnihg07g77xljnybra3n7-icl-1.2.0`
- **Binary:** `/gnu/store/yf0aj0nwa8knnihg07g77xljnybra3n7-icl-1.2.0/bin/icl`
- **Binary Size:** 13 MB

## Package Definitions Location

All three packages are defined in:
```
/home/kanna/code/guix-packages/gnu/packages/lisp-icl.scm
```

## Build Commands

```bash
# Build individual packages
guix build -L /home/kanna/code/guix-packages sbcl-version-string
guix build -L /home/kanna/code/guix-packages sbcl-slynk-client
guix build -L /home/kanna/code/guix-packages icl

# Test the ICL binary
$(guix build -L /home/kanna/code/guix-packages icl)/bin/icl --version
# Output: icl version 1.2.0
```

## Key Technical Decisions

1. **Build System:** Used `asdf-build-system/sbcl` for all packages
   - This is the standard approach for Common Lisp libraries in Guix
   - Automatically handles ASDF configuration and dependencies

2. **Executable Generation:** Used `build-program` from `guix/build/lisp-utils.scm`
   - Creates standalone executable with all dependencies embedded
   - Entry point: `(icl:main) 0`
   - Results in 13 MB compressed binary

3. **Module Organization:** Created custom module `(gnu packages lisp-icl)`
   - Avoids conflicts with existing `(gnu packages lisp-xyz)` from Guix
   - Can be easily integrated into upstream Guix later

4. **Hash Computation:** Used `guix hash -rx` for git checkouts
   - Different from tarball hashes (`guix download`)
   - Ensures reproducible builds from git sources

## Dependencies Status

### Direct Dependencies (from icl.asd)
All 8 direct dependencies now available:
- ✅ sbcl-alexandria (from Guix)
- ✅ sbcl-cffi (from Guix)
- ✅ sbcl-clingon (from Guix)
- ✅ sbcl-osicat (from Guix)
- ✅ sbcl-slynk-client (NEW - packaged)
- ✅ sbcl-split-sequence (from Guix)
- ✅ sbcl-termp (from Guix)
- ✅ sbcl-version-string (NEW - packaged)

### Transitive Dependencies
All from existing Guix packages:
- sbcl-bordeaux-threads
- sbcl-slynk
- sbcl-usocket

## Next Steps

### For Local Use
```bash
# Install to your profile
guix install -L /home/kanna/code/guix-packages icl

# Or run directly
$(guix build -L /home/kanna/code/guix-packages icl)/bin/icl
```

### For Submission to Guix Upstream

1. **Move packages to proper location:**
   - `sbcl-version-string` and `sbcl-slynk-client` should go in `gnu/packages/lisp-xyz.scm`
   - `icl` could go in `gnu/packages/lisp.scm` or stay in `lisp-xyz.scm`

2. **Update copyright headers:**
   - Change placeholder "Your Name" to actual author
   - Update email address

3. **Create proper Guix channel** (if not submitting upstream):
   ```scheme
   ;; .guix-channel
   (channel
     (version 0)
     (name 'your-channel-name))
   ```

4. **Submit patches to guix-patches:**
   - Create separate patches for sbcl-version-string, sbcl-slynk-client, and icl
   - Follow Guix contribution guidelines
   - Send to guix-patches@gnu.org

## Files Created

```
guix-packages/
├── gnu/packages/lisp-icl.scm     # Main package definitions
├── icl/
│   ├── DEPENDENCIES.md            # Full dependency analysis
│   ├── DEPENDENCY-STATUS.md       # Guix availability mapping
│   ├── PACKAGING-GUIDE.md         # General Guix CL packaging guide
│   ├── TODO.md                    # Original TODO (now complete)
│   ├── STATUS.md                  # Progress tracking
│   ├── BUILD-SUCCESS.md           # This file
│   ├── icl-package.scm            # (original, for reference)
│   ├── sbcl-version-string.scm    # (original, for reference)
│   └── sbcl-slynk-client.scm      # (original, for reference)
```

## Lessons Learned

1. **Git vs Tarball Hashes:** Git checkout hashes must be computed with `guix hash -rx`, not `guix download`

2. **Module Naming:** Module names must match file paths when using `-L` flag
   - File: `gnu/packages/lisp-icl.scm`
   - Module: `(gnu packages lisp-icl)`

3. **ASDF Build System:** The `asdf-build-system/sbcl` handles most Common Lisp packaging automatically
   - Sets up `CL_SOURCE_REGISTRY`
   - Compiles FASL files
   - Creates ASDF configuration

4. **Executable Creation:** For standalone binaries, use `build-program` from `lisp-utils`
   - More reliable than manual `sb-ext:save-lisp-and-die`
   - Handles dependencies correctly
   - Works consistently across implementations

5. **G-expressions:** Need to import `(guix gexp)` when using `#~`, `#$` syntax

## Verification

```bash
# Verify all packages built
$ guix build -L . sbcl-version-string
/gnu/store/w6ahiv0wwlyi9lsavlb6mz280vkv972a-sbcl-version-string-1.0.1-0.668f2fa

$ guix build -L . sbcl-slynk-client
/gnu/store/hxx8k1vk59yc1qzg7mbbm8ky572ilq12-sbcl-slynk-client-1.6-0.f232d4d

$ guix build -L . icl
/gnu/store/yf0aj0nwa8knnihg07g77xljnybra3n7-icl-1.2.0

# Test ICL
$ /gnu/store/yf0aj0nwa8knnihg07g77xljnybra3n7-icl-1.2.0/bin/icl --version
icl version 1.2.0
```

## Success Metrics

- ✅ All 3 packages build successfully
- ✅ All dependencies resolved
- ✅ Standalone executable created (13 MB)
- ✅ Binary runs and reports correct version
- ✅ Reproducible builds via Guix
- ✅ No network access during build
- ✅ All sources from git with proper hashes

**Total time:** ~3 hours from initial research to working package

## Acknowledgments

- Anthony Green (@atgreen) - ICL author
- Shookakko - slynk-client author
- GNU Guix community - packaging infrastructure and tools
