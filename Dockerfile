FROM alpine

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY ca.sh /bin/ 
COPY end-entity.sh /bin/
COPY view-ca-cert.sh /bin/
COPY view-end-entity-cert.sh /bin/

RUN chmod +x /bin/*.sh

RUN apk add bash ; apk add openssl

ENTRYPOINT ["/entrypoint.sh"]
