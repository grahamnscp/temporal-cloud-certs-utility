# Docker image build scripts for dev certificated for Temporal Cloud

## setup builder first time
```
docker buildx create --use
```

## build multi-arch image (problem with metadata fetching when I ran this so just built arm64 image below..)
```
#docker buildx build --platform linux/amd64,linux/arm64 --push -t grahamh/client-certificate-generation:latest .

docker build -t grahamh/client-certificate-generation:arm64 --platform=linux/arm64 .
docker push grahamh/client-certificate-generation:arm64
```

## create directory to write the cert files to
```
mkdir mycerts
```

## quick list of utility scripts
```
docker run -it --rm -v $PWD/mycerts:/work --entrypoint=bash grahamh/client-certificate-generation:arm64 -c "ls -w30 /bin/*.sh|sed 's/\/bin\///'"
ca.sh
view-ca-cert.sh
end-entity.sh
view-end-entity-cert.sh
```

## create a ca to be loaded into the temporal cloud UI
```
docker run -it --rm -v $PWD/mycerts:/work grahamh/client-certificate-generation:arm64
1) ca.sh		    4) view-end-entity-cert.sh
2) end-entity.sh	    5) Quit
3) view-ca-cert.sh
Select a script number to run: 1

Running script: ca.sh
Creating the CSR (certificate signing request)
What is your company name?:
example.com
...
---> Please share ca.pem with Temporal cloud
---> Keep ca.key and ca.pem secure, but available for generating end entities in the future
```

## examine details of ca certificate file
```
docker run -it --rm -v $PWD/mycerts:/work grahamh/client-certificate-generation:arm64
1) ca.sh                    4) view-end-entity-cert.sh
2) end-entity.sh            5) Quit
3) view-ca-cert.sh
Select a script number to run: 3
...

```

## create client certs (signed by above ca) to be used by client to connect to temporal cloud
```
docker run -it --rm -v $PWD/mycerts:/work grahamh/client-certificate-generation:arm64
1) ca.sh                    4) view-end-entity-cert.sh
2) end-entity.sh            5) Quit
3) view-ca-cert.sh
Select a script number to run: 2
Enter a unique name for the prefix of the .pem and .key files:tclient-example
...
---> Keep these files secure, and use tclient-example.pem and tclient-example.key in the SDK

```

## examine details of client certificate file
```
docker run -it --rm -v $PWD/mycerts:/work grahamh/client-certificate-generation:arm64
1) ca.sh                    4) view-end-entity-cert.sh
2) end-entity.sh            5) Quit
3) view-ca-cert.sh
Select a script number to run: 4

Running script: view-end-entity-cert.sh
Available .pem files in work directory:
tclient-example

Enter a unique name for the prefix of the .pem and .key files:tclient-example
...
```

