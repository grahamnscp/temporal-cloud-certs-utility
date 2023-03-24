#!/bin/bash

echo -n "Enter a unique name for the prefix of the .pem and .key files":
read UNIQUE_NAME
echo "Generating private key and CSR"

# Grep other conf file to grab company name.
DNS=$(grep DNS.1 /work/ca.conf)

# Find the company name e.g. from `DNS.1=client.root.<company name>.<rand values>`
IFS="." read -a strarr <<< "${DNS}"
CN="${strarr[3]}"

# Return a random stream of data, fold makes a new line every 4 characters, head will take the first line.
RANDLETTER=$(cat /dev/urandom | busybox tr -dc 'a-z0-9' | busybox fold -w 4 | busybox head -n 1)

# Enter this as the DNS.
DNS_END_ENTITY="client.endentity.${CN}.${RANDLETTER}"

GENERATED_END_ENTITY_CONF_FILE="/work/${UNIQUE_NAME}.conf"
cat << EOF > ${GENERATED_END_ENTITY_CONF_FILE}
[req]
default_bits = 4096
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
prompt = no

[req_ext]
subjectAltName = @alt_names

[dn]
O = $CN
CN = $CN client

[alt_names]
DNS.1 = $DNS_END_ENTITY
EOF

# Generate client's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout "/work/${UNIQUE_NAME}.key" -out "/work/${UNIQUE_NAME}-req.pem" -config "/work/${UNIQUE_NAME}.conf"

echo "Signing certificate"

# Use CA's private key to sign client's CSR and get back the signed certificate
openssl x509 -days 365 -req -in "/work/${UNIQUE_NAME}-req.pem" -CA "/work/ca.pem" -CAkey "/work/ca.key" -CAcreateserial -out "/work/${UNIQUE_NAME}.pem" -extfile "/work/${UNIQUE_NAME}.conf"

# Delete the certificate signing request after the certificate has been signed.
rm "/work/${UNIQUE_NAME}-req.pem"

echo "Printing signed end-entity certificate"
openssl x509 -in "/work/${UNIQUE_NAME}.pem" -noout -text

echo "---> Keep these files secure, and use ${UNIQUE_NAME}.pem and ${UNIQUE_NAME}.key in the SDK"

