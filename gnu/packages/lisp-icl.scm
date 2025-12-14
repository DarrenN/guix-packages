;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2025 DarrenN <info AT v25media.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.

(define-module (gnu packages lisp-icl)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system asdf)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build lisp-utils)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages lisp-xyz))

;;; Commentary:
;;;
;;; Additional Common Lisp packages for ICL and dependencies
;;;
;;; Code:

(define-public sbcl-version-string
  (let ((commit "668f2fa091fccb257ba207e562f2f826dce61991")
        (revision "0"))
    (package
      (name "sbcl-version-string")
      (version (git-version "1.0.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/atgreen/cl-version-string")
                      (commit commit)))
                (file-name (git-file-name "cl-version-string" version))
                (sha256
                 (base32
                  "0lshk444l8mfkqsrn4pngrpw1imlqinmmjyvfn2zjfivh4r1p5iz"))))
      (build-system asdf-build-system/sbcl)
      (synopsis "Generate descriptive version strings")
      (description
       "This library provides a way to generate version strings by combining
ASDF system versions with Git metadata.  It intelligently derives versions
from Git tags, commit hashes, or falls back to the base ASDF version.")
      (home-page "https://github.com/atgreen/cl-version-string")
      (license license:expat))))

(define-public ecl-version-string
  (sbcl-package->ecl-package sbcl-version-string))

(define-public cl-version-string
  (sbcl-package->cl-source-package sbcl-version-string))

(define-public sbcl-slynk-client
  (let ((commit "f232d4dbbed03ff62ef8419eea580d2dfb9999de")
        (revision "0"))
    (package
      (name "sbcl-slynk-client")
      (version (git-version "1.6" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/Shookakko/slynk-client")
                      (commit commit)))
                (file-name (git-file-name "slynk-client" version))
                (sha256
                 (base32
                  "1yil8l8xscb81kz0a0xaybncmmp3r97wl5hlpfanj572z35yyfl5"))))
      (build-system asdf-build-system/sbcl)
      (inputs
       (list sbcl-alexandria
             sbcl-bordeaux-threads
             sbcl-slynk
             sbcl-usocket))
      (synopsis "Client side of the Slynk debugging protocol")
      (description
       "This package provides a Common Lisp implementation of the client side
of the Slynk debugging protocol used by SLY (Sylvester the Cat's Common Lisp
IDE for Emacs).  It allows a client to evaluate expressions on a remote Lisp
that's running a Slynk server.  The protocol is useful independently of Emacs.")
      (home-page "https://github.com/Shookakko/slynk-client")
      (license license:gpl2))))

(define-public ecl-slynk-client
  (sbcl-package->ecl-package sbcl-slynk-client))

(define-public cl-slynk-client
  (sbcl-package->cl-source-package sbcl-slynk-client))

(define-public icl
  (package
    (name "icl")
    (version "1.2.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/atgreen/icl")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "11jbjvmcdsjn2rl51gx9l4is1vb1q8g6qfy8wg27v16azingjfzk"))))
    (build-system asdf-build-system/sbcl)
    (arguments
     (list #:phases
           #~(modify-phases %standard-phases
               (add-after 'create-asdf-configuration 'build-executable
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let ((out (assoc-ref outputs "out")))
                     ((@ (guix build lisp-utils) build-program)
                      (string-append out "/bin/icl")
                      outputs
                      #:entry-program '((icl:main) 0)
                      #:dependencies '("icl"))))))))
    (native-inputs
     (list sbcl))
    (inputs
     (list sbcl-alexandria
           sbcl-cffi
           sbcl-clingon
           sbcl-osicat
           sbcl-slynk-client
           sbcl-split-sequence
           sbcl-termp
           sbcl-version-string
           ;; Likely transitive dependencies
           sbcl-bordeaux-threads
           sbcl-slynk
           sbcl-usocket))
    (synopsis "Interactive Common Lisp REPL with enhanced features")
    (description
     "ICL is an enhanced REPL for Common Lisp providing syntax highlighting,
parenthesis matching, multi-line input with smart indentation, persistent
history, tab completion, and an extensible command system.  It communicates
with backend Lisp processes via the Slynk protocol.")
    (home-page "https://github.com/atgreen/icl")
    (license license:expat)))
