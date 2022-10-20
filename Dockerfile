FROM alpine:latest as builder

RUN apk add --update alpine-sdk
RUN apk add readline-dev readline autoconf

COPY . /game-server
WORKDIR /game-server
RUN cd skynet && make linux

FROM alpine:latest 

RUN apk add --no-cache libgcc readline autoconf
COPY --from=builder /game-server /game-server
WORKDIR /game-server

CMD ["./skynet/skynet", "./examples/config.helloWorld.lua"]
