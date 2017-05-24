FROM golang:1.8-alpine

# Install ca-certificates, required for the "release message" feature:
RUN apk --no-cache add \
    ca-certificates

RUN apk --no-cache add --virtual build-dependencies \
    git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go get github.com/jmartin82/mmock \
  && mv /root/gocode/bin/mmock /usr/local/bin \
  && rm -rf /root/gocode \
  && apk del --purge build-dependencies

RUN mkdir /config

VOLUME /config

ADD server.crt / 
ADD server.key / 

EXPOSE 8082 8083 8084

ENTRYPOINT ["mmock","-config-path","/config"]