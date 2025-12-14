# ICL Dependency Status in Guix

## Direct Dependencies (from icl.asd)

| Dependency | Guix Package | Status | Notes |
|------------|--------------|--------|-------|
| alexandria | sbcl-alexandria | ✓ EXISTS | v1.4-0.009b7e5 |
| cffi | sbcl-cffi | ✓ EXISTS | v0.24.1-2.32c90d4 |
| clingon | sbcl-clingon | ✓ EXISTS | v0.5.0-1.f2a730f |
| osicat | sbcl-osicat | ✓ EXISTS | v0.7.0-4.9823279 |
| slynk-client | ??? | ❌ MISSING | No sbcl-slynk-client found |
| split-sequence | sbcl-split-sequence | ✓ EXISTS | v2.0.1 |
| termp | sbcl-termp | ✓ EXISTS | v0.1-0.29789fe |
| version-string | ??? | ❌ MISSING | Not found in Guix |

## Likely Transitive Dependencies (from ocicl.csv)

| Dependency | Guix Package | Status | Notes |
|------------|--------------|--------|-------|
| babel | sbcl-babel | ? | Need to check |
| bobbin | sbcl-bobbin | ✓ EXISTS | Seen as dep of clingon |
| bordeaux-threads | sbcl-bordeaux-threads | ✓ EXISTS | v0.9.3 |
| cl-reexport | sbcl-cl-reexport | ✓ EXISTS | Seen as dep of clingon |
| deploy | ??? | ? | Need to check |
| documentation-utils | ??? | ? | Need to check |
| global-vars | ??? | ? | Need to check |
| idna | sbcl-idna | ? | Need to check |
| iolib | sbcl-iolib | ? | Need to check |
| linedit | sbcl-linedit | ? | Need to check |
| pathname-utils | sbcl-pathname-utils | ? | Need to check |
| sha3 | sbcl-sha3 | ? | Need to check |
| swap-bytes | sbcl-swap-bytes | ? | Need to check |
| terminfo | ??? | ? | Need to check |
| trivial-features | sbcl-trivial-features | ? | Need to check |
| trivial-garbage | sbcl-trivial-garbage | ? | Need to check |
| trivial-indent | sbcl-trivial-indent | ? | Need to check |
| usocket | sbcl-usocket | ? | Need to check |
| with-user-abort | ??? | ? | Need to check |

## Transitive Dependencies Status

| Dependency | Status | Notes |
|------------|--------|-------|
| sbcl-babel | ✓ EXISTS | v0.5.0-3.627d6a6 |
| sbcl-bordeaux-threads | ✓ EXISTS | v0.9.3 |
| sbcl-trivial-features | ✓ EXISTS | v1.0 |
| sbcl-trivial-garbage | ✓ EXISTS | v0.21-0.3474f64 |
| sbcl-usocket | ✓ EXISTS | v0.8.9 |

## Summary

**Found in Guix (Direct deps):** 6/8
**Missing (Direct deps):** 2/8
- **slynk-client** - From https://github.com/Shookakko/slynk-client
- **version-string** - From ocicl registry (cl-version-string-20250701-2a9f9ba)

**ICL Source Hash:** `0sx3lwa6ca73rl6x1af3axs5nk3xq55mjf3ks6babbz2f273rf5l`

## Next Steps

1. ✓ Got the source hash for ICL v1.2.0
2. Package the missing direct dependencies:
   - sbcl-slynk-client (from https://github.com/Shookakko/slynk-client)
   - sbcl-version-string (need to find upstream source)
3. Update icl-package.scm with hash and known dependencies
4. Attempt initial build and identify any remaining missing deps
