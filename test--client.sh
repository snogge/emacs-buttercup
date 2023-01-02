#!/usr/bin/env bash
set -euo pipefail

# We expect an Emacs #'server socket and a named pipe for inter-op:
[[ -S "$EMACS_SOCKET" ]]
[[ -p "$FIFO" ]]

# This script imitates the calling conventions of a shell. Here we drop the
# '-c' token that a shell would be invoked with and save the command (which
# *may* be nil).
shift; CMD="$1"

EXIT_INDICATOR="$(($RANDOM))"
emacsclient --socket="$EMACS_SOCKET" \
            --reuse-frame \
            --eval "(unwind-protect
                       (condition-case err
                         $CMD
                         (error (with-temp-file \"/dev/tty\"
                                  (insert (format \"\n%s\n\" (error-message-string err))))))
                     (with-temp-file \"$FIFO\"
                       (insert \"$EXIT_INDICATOR\")))" \
            > /dev/null 2>&1 &

# Wait for the indicator
grep --fixed-strings --quiet "$EXIT_INDICATOR" "$FIFO"
