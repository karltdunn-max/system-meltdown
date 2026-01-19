#!/bin/bash

CONFIG="ansible-tests.yml"

echo "Running Ansible test suite..."
echo "----------------------------------------"

# Parse YAML into key-value pairs
parse_yaml() {
  awk '
    /^[ ]*name:/      { name=$2; gsub(/"/, "", name) }
    /^[ ]*inventory:/ { inventory=$2; gsub(/"/, "", inventory) }
    /^[ ]*playbook:/  { playbook=$2; gsub(/"/, "", playbook) }
    /^[ ]*$/ {
      if (name != "" && inventory != "" && playbook != "") {
        print "TEST|" name "|" inventory "|" playbook
      }
      name=""; inventory=""; playbook=""
    }
  ' "$CONFIG"
echo "DEBUG: name=$name, inventory=$inventory, playbook=$playbook"
}

# Execute tests
while IFS="|" read -r marker name inventory playbook; do
  if [ "$marker" != "TEST" ]; then continue; fi

  echo "[TEST] $name"
  echo "Running: ansible-playbook -i $inventory $playbook"

  ansible-playbook -i "$inventory" "$playbook"
  RESULT=$?

  if [ $RESULT -eq 0 ]; then
    echo "PASS"
  else
    echo "FAIL (exit code $RESULT)"
  fi

  echo "----------------------------------------"

done < <(parse_yaml)

echo "Testing complete."
