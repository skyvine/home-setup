(define* (in-dir dir paths)
  (if (null? paths)
    dir
    (in-dir (string-append dir "/" (first paths)) (drop paths 1))
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

