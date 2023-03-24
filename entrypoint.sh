#!/bin/bash

unset options i
cd /bin
while IFS= read -r -d $'\0' f; do
  options[i++]="$f"
done < <( find . -maxdepth 1 -type f -name "*.sh" -print0 |sed 's/\.\///g' )

unset SCRIPT_NAME
COLUMNS=0
PS3="Select a script number to run: "
select opt in "${options[@]}" Quit; do
  case $opt in
    (*.sh)
      SCRIPT_NAME=$opt
      break
      ;;
    Quit)
      echo "Exiting.."
      exit 0
      ;;
  esac
done

echo
echo Running script: $SCRIPT_NAME
/bin/$SCRIPT_NAME
