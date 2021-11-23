#FROM gcc:11.2 AS builder
FROM alpine:3.15 AS builder
RUN apk add --no-cache gcc musl-dev curl-dev linux-headers

WORKDIR /workdir
COPY hv_kvp_daemon.c .
RUN gcc -Os -o hypervkvpd hv_kvp_daemon.c -lcurl

FROM alpine:3.15
RUN apk add --no-cache libcurl bash
COPY --from=builder /workdir/hypervkvpd /sbin/hypervkvpd
COPY libexec /usr/libexec/hypervkvpd/
ENV PATH=/usr/libexec/hypervkvpd:$PATH

ENTRYPOINT ["/sbin/hypervkvpd","-n"]
