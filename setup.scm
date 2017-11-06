#! /run/current-system/sw/bin/guile \
-e main -s
!#

(use-modules (srfi srfi-1) (srfi srfi-98))

(load "config.scm")
(load "filesystem_support.scm")

(define (run-setup-files-aux rootname dirstream)
  (let ((currname (readdir dirstream)))
    (unless (eof-object? currname)
      ; skip parent and self
      (unless (or (string=? currname ".") (string=? currname ".."))
        (let ((filename (string-append rootname "/" currname "/setup.scm")))
          ; if we can read the setup file, run it
          (when (access? filename R_OK)
            (write "Running: ") (write filename) (newline)
            (load filename)
          )
        )
      )
      (run-setup-files-aux rootname dirstream)
    )
  )
)

(define (run-setup-files rootname)
  ; The Guile manual recommends looking at the File Tree Walk (ftw) functions
  ; before using these lower-level functions. Ftw does not make sense for this
  ; function because it walks the entire tree, while here we know that we only
  ; want to look one directory deep; in fact, executing all files named
  ; 'setup.scm' anywhere in the directory tree would be misbehavior that may
  ; lead to bugs
  (run-setup-files-aux rootname (opendir rootname))
)

(define (main args)
  ; I use the dotdir folder to test if the home is already set up; testing for
  ; the home directory itself doesn't work because the home directory may exist,
  ; but be empty (and thus a valid target to clone into), which is important for
  ; unpriveleged users
  (unless (access? dotdir F_OK)
    (system (string-append
              "git clone --recursive -j16 " (in-dir "https://github.com/"
                                                    (list github-user github-repo)
                                            )
              " " home
            )
    )
  )
  (run-setup-files dotdir)
)

