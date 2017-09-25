; The config file defines a number of variables that users might be interested
; in changing.

; This is the directory that all the files will be set up in
(define home
  (get-environment-variable "HOME")
)

; github-user and github-repo determine the directory to clone into home
(define github-user
  (get-environment-variable "USER")
)
(define github-repo
  "home"
)

; This is the directory where the human-editable config files (such as .zshrc)
; are kept; the programs themselves (such as zsh) access them through symlinks
; or enviornment variables
(define dotdir
  (string-append home "/.dotdirs")
)

