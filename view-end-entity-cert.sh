#!/bin/bash

echo "Available .pem files in work directory:"
cd /work ; ls -w20 *.pem | sed 's/.pem//' | grep -v ca
echo

echo -n "Enter a unique name for the prefix of the .pem and .key files":
read UNIQUE_NAME

echo "Displaying contents of ${UNIQUE_NAME}.pem:"
openssl x509 -in /work/${UNIQUE_NAME}.pem -text
