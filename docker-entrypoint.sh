#!/bin/bash
set -e

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for dashd"

  set -- dashd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "dashd" ]]; then
  mkdir -p "$DASHCORE_DATA"
  chmod 700 "$DASHCORE_DATA"

  echo "$0: setting data directory to $DASHCORE_DATA"

  set -- "$@" -datadir="$DASHCORE_DATA"
fi

if [[ "$1" = "dashd" ]] || [[ "$1" = "dash-cli" ]] || [[ "$1" = "dash-tx" ]]; then
  echo
  exec "$@"
fi

echo
exec "$@"
