# Packaging ICL for GNU Guix

## Overview
ICL (Interactive Common Lisp) is an enhanced REPL that uses:
- SBCL to build a standalone binary
- ocicl for dependency management (in development)
- Slynk protocol for backend communication

## The Guix Approach

Unlike the upstream build which uses `ocicl install` to fetch dependencies,
Guix requires:
1. Each CL library packaged as a separate Guix package
2. Dependencies declared explicitly in the package definition
3. Reproducible builds using only Guix store inputs

## Steps to Package ICL

### 1. Identify All Dependencies

First, we need the complete dependency tree. The `ocicl.csv` file lists them,
but we can also examine `icl.asd`:

```bash
# If you had network access:
git clone https://github.com/atgreen/icl.git
cat icl/ocicl.csv
cat icl/icl.asd  # Look for :depends-on
```

### 2. Check Which Dependencies Already Exist in Guix

```bash
guix search sbcl-slynk
guix search sbcl-osicat
guix search sbcl-cl-readline
guix search sbcl-cl-ansi-text
# etc. for each dependency
```

Already confirmed to exist:
- sbcl (the compiler)
- sbcl-slynk (SLY backend)
- sbcl-osicat (OS interface, needs libfixposix)
- libfixposix (C library for osicat)

### 3. Package Missing Dependencies

For any missing CL libraries, create Guix packages following the pattern:

```scheme
(define-public sbcl-<name>
  (package
    (name "sbcl-<name>")
    (version "...")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/...")
                    (commit ...)))
              (sha256 (base32 "..."))))
    (build-system asdf-build-system/sbcl)
    (inputs (list sbcl-dep1 sbcl-dep2))
    ...))

;; Variants for other CL implementations (optional):
(define-public ecl-<name>
  (sbcl-package->ecl-package sbcl-<name>))

(define-public cl-<name>
  (sbcl-package->cl-source-package sbcl-<name>))
```

### 4. Create the ICL Package Definition

The tricky part: ICL builds a standalone executable. Most CL packages in Guix
use `asdf-build-system/sbcl`, but ICL needs something custom:

```scheme
(define-public icl
  (package
    (name "icl")
    (version "1.2.0")
    (source ...)
    (build-system gnu-build-system)  ; or a custom build system
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'build
           (lambda* (#:key inputs outputs #:allow-other-keys)
             ;; The Makefile likely does something like:
             ;; sbcl --non-interactive --load build.lisp
             ;; But we need to ensure it finds dependencies in Guix store
             (setenv "CL_SOURCE_REGISTRY"
                     (string-append (assoc-ref inputs "sbcl-slynk")
                                    "/share/common-lisp/sbcl//:"
                                    ;; Add other deps...
                                    ))
             (invoke "make" "icl")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (install-file "icl"
                           (string-append (assoc-ref outputs "out")
                                          "/bin")))))))
    (native-inputs (list sbcl))
    (inputs
     (list sbcl-slynk
           sbcl-osicat
           libfixposix
           ;; Add other CL dependencies
           ))
    ...))
```

### 5. Compute the Hash

```bash
guix download https://github.com/atgreen/icl/archive/refs/tags/v1.2.0.tar.gz
# Use the hash it outputs in your package definition
```

Or for git checkouts:
```bash
guix hash -rx /path/to/icl-checkout
```

## Common Pitfalls

1. **ASDF can't find dependencies**: Set `CL_SOURCE_REGISTRY` or use the
   `asdf-build-system/sbcl` helpers

2. **Build expects ocicl**: The Makefile might invoke `ocicl install`. You'll
   need to patch it out and ensure ASDF can find everything via inputs.

3. **Standalone binary creation**: ICL saves a core image. Ensure all
   dependencies are properly linked/included in the final binary.

4. **libfixposix**: osicat needs this C library at runtime. It must be in
   `inputs`, not just `native-inputs`.

## Testing Your Package

```bash
# Build from your local definition:
guix build -f icl-package.scm

# Or if in a channel:
guix build icl

# Test it:
$(guix build icl)/bin/icl
```

## Next Steps

The real work is in:
1. Getting the full dependency list from `ocicl.csv` or `icl.asd`
2. Checking which ones exist in Guix already
3. Packaging the missing ones first
4. Understanding how ICL's build process works (examine the Makefile)
5. Adapting the build to work with Guix's purely functional approach

Would you like me to help with any specific part of this?
