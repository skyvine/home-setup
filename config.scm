; The config file defines a number of variables that users might be interested
; in changing.

; This is the directory that all the files should end up in
(define home
  (string-append (getenv "HOME") "/projects/home-setup/test")
)

; This is the directory where all of the files will be prepared
(define stage (string-append home "/stage"))

; github-user and github-repo determine the directory to clone into home
(define github-user
  (getenv "USER")
)
(define github-repo
  "home"
)

; This is the directory where the human-editable config files (such as .zshrc)
; are kept; the programs themselves (such as zsh) access them through symlinks
; or enviornment variables
; NOTE that this MUST be in the stage
(define dotdir
  (string-append stage "/.dotdirs")
)

