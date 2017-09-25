#! /usr/bin/guile \
-e main -s
!#

(use-modules (srfi srfi-1) (srfi srfi-98))

(define home (get-environment-variable "HOME"))
(define dotdir ".dotdirs")

(define* (in-home paths #:key (base home))
  (if (null? paths)
    base
    (in-home (drop paths 1) #:base (string-append base "/" (first paths)))
  )
)

(define (in-dotdir paths)
  (in-home (append (list dotdir) paths))
)

(define (safe-mkdir dir)
  (if (not (access? dir F_OK))
    (mkdir dir)
  )
)

(define (safe-symlink oldpath newpath)
  (if (access? newpath F_OK)
    (rename-file newpath (string-append newpath ".orig"))
  )
  (symlink oldpath newpath)
)

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
  ; lead to incompatibilities with existing scheme software
  (run-setup-files-aux rootname (opendir rootname))
)

(define (main args)
  ; I use the dotdir folder to test if the home is already set up; testing for
  ; the home directory itself doesn't work because the home directory may exist,
  ; but be empty (and thus a valid target to clone into), which is important for
  ; unpriveleged users
  (unless (access? (in-dotdir '()) F_OK)
    (system (string-append
              "git clone --recursive -j16 https://github.com/saffronsnail/home "
              home
            )
    )
  )
  (run-setup-files (in-dotdir '()))
)

