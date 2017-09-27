(use-modules (oop goops) (srfi srfi-1) (srfi srfi-98))

(define* (in-dir dir paths)
  (if (null? paths)
    dir
    (if (pair? paths)
      (in-dir (string-append dir "/" (first paths)) (drop paths 1))
      (if (string? paths)
        (string-append dir "/" paths)
        (error (string-append "Unexpected type " 
                              (symbol->string (class-name (class-of paths)))
                              " passed in as the paths variable to in-dir"
               )
        )
      )
    )
  )
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

