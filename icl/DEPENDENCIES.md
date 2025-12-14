# ICL Dependencies Analysis

## From icl.asd (Direct Dependencies)

These are the libraries ICL directly depends on:

1. **clingon** - Command-line argument parsing
2. **version-string** - Version handling
3. **termp** - Terminal capability detection
4. **cffi** - C Foreign Function Interface
5. **slynk-client** - Slynk protocol client
6. **alexandria** - Utility functions
7. **split-sequence** - Sequence manipulation
8. **osicat** - POSIX operations (non-Windows only)

## From ocicl.csv (Full Transitive Dependencies - 48 total)

### Core Libraries
- alexandria
- babel, babel-streams, babel-tests
- bobbin
- bordeaux-threads

### CFFI & Foreign Function Interface
- cffi, cffi-examples, cffi-grovel, cffi-libffi, cffi-tests, cffi-toolchain, cffi-uffi-compat
- uffi

### CLI & Documentation
- clingon, clingon.demo, clingon.intro, clingon.test
- documentation-utils, multilang-documentation-utils

### Development & Deployment
- deploy, deploy-test
- cl-reexport, cl-reexport-test

### System Utilities
- global-vars, global-vars-test
- idna
- iolib, iolib.asdf, iolib.base, iolib.common-lisp, iolib.conf, iolib.examples

### Terminal & Text
- linedit
- terminfo
- termp
- trivial-indent

### File & Path Handling
- osicat
- pathname-utils, pathname-utils-test

### Utilities & Support
- sha3
- slynk
- split-sequence
- swap-bytes
- trivial-features, trivial-features-tests
- trivial-garbage
- version-string
- with-user-abort

### Networking
- usocket, usocket-server, usocket-test

## Build Process (from Makefile)

The Makefile shows:

```bash
sbcl --non-interactive \
  --eval '(require :asdf)' \
  --eval '(push (uiop:getcwd) asdf:*central-registry*)' \
  --eval '(push #p"ocicl/" asdf:*central-registry*)' \
  --eval '(push #p"3rd-party/" asdf:*central-registry*)' \
  --eval '(asdf:make :icl)' \
  --quit
```

Key points:
1. Uses SBCL to build
2. Relies on ASDF for dependency management
3. Expects dependencies in `ocicl/` and `3rd-party/` directories
4. Creates standalone executable via `asdf:make`

## Next Steps for Guix Packaging

1. Check which of these libraries already exist in Guix as `sbcl-*` packages
2. Package the missing ones (starting with direct dependencies)
3. Modify the build process to use Guix's CL_SOURCE_REGISTRY instead of ocicl
4. Ensure all dependencies are available as inputs
