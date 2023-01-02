#!/usr/bin/env bash
set -euo pipefail

# TODO: Probably a better way to do this \/
# Folder will be recreated per-run; don't set to /tmp!
EMACS_SOCKET_DIR="$(mktemp -d)"
export EMACS_SOCKET="$EMACS_SOCKET_DIR/server"
mkdir -p "$EMACS_SOCKET_DIR"
chmod 700 "$EMACS_SOCKET_DIR"

# Use a named pipe to interoperate with elisp (rather than futz'in about with std*)
export FIFO="$EMACS_SOCKET_DIR/fifo"
mkfifo "$FIFO"

# Use a timer to kill emacs on EXIT (allowing it to tell test--client.sh to return)
# XXX: Maybe just send a SIGKILL?
function cleanup {
  set +e
  ./test--client.sh -c '(run-with-timer 1 nil (lambda () (save-buffers-kill-emacs)))' && sleep 1.2
  [[ -S "$EMACS_SOCKET" ]] && rm "$EMACS_SOCKET"
  rm "$FIFO"
  rmdir "$EMACS_SOCKET_DIR"
}
trap cleanup EXIT

# Start the server:
emacs --quick       \
      --directory . \
      --load buttercup \
      --eval "(progn (setq server-socket-dir \"$EMACS_SOCKET_DIR\")
                     (server-start))" &
until [[ -S "$EMACS_SOCKET" ]]; do sleep 0.1; done; sleep 0.5

# Output can be printed to "/dev/tty"
./test--client.sh -c \
  '(progn (fset '"'"'buttercup--print (lambda (fmt &rest args)
                                        (with-temp-file "/dev/tty"
                                          (insert (apply #'"'"'format fmt args)))))
          (set  '"'"'buttercup-reporter #'"'"'buttercup-reporter-batch)
          (describe "an example test"
            (it "work in trivial cases" (expect 1 :to-equal 1))
            (it "can rely on non-interactive features, frames, etc"
              (expect (- (string-to-number (format-mode-line "%C"))
                         (car (posn-col-row (posn-at-point))))
                      :to-be-close-to 1 1))
            (it "gives kinda funny backtraces tho"
              (expect (- (string-to-number (format-mode-line "%C"))
                         (car (posn-col-row (posn-at-point))))
                      :to-be-close-to 2 1)))
          (buttercup-run))' \
  > /dev/null

printf '\n'
