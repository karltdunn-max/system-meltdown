#!/bin/bash

CONFIG="test_game.yml"

echo "Running System Meltdown tests..."
echo "--------------------------------"

# Parse YAML manually (simple parser)
parse_yaml() {
  sed -ne "s/^[ ]*name:[ ]*\"\(.*\)\"/\1/p" \
      -e "s/^[ ]*type:[ ]*\(.*\)/\1/p" \
      -e "s/^[ ]*path:[ ]*\"\(.*\)\"/\1/p" \
      -e "s/^[ ]*file:[ ]*\"\(.*\)\"/\1/p" \
      -e "s/^[ ]*pattern:[ ]*\"\(.*\)\"/\1/p" $CONFIG
}

# Load YAML into an array
mapfile -t LINES < <(parse_yaml)

i=0
while [ $i -lt ${#LINES[@]} ]; do
  NAME="${LINES[$i]}"
  TYPE="${LINES[$((i+1))]}"
  TARGET="${LINES[$((i+2))]}"
  EXTRA="${LINES[$((i+3))]}"

  echo -n "[TEST] $NAME: "

  case $TYPE in
    file_exists)
      if [ -f "$TARGET" ]; then
        echo "PASS"
      else
        echo "FAIL (missing file: $TARGET)"
      fi
      i=$((i+3))
      ;;

    search)
      if grep -q "$EXTRA" "$TARGET"; then
        echo "PASS"
      else
        echo "FAIL (pattern '$EXTRA' not found in $TARGET)"
      fi
      i=$((i+4))
      ;;

    *)
      echo "UNKNOWN TEST TYPE: $TYPE"
      i=$((i+1))
      ;;
  esac
done

echo "--------------------------------"
echo "Testing complete."
