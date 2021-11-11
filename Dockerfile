FROM gcc:9.4 AS builder

WORKDIR /workdir
COPY hv_kvp_daemon.c .
RUN gcc -o hypervkvpd hv_kvp_daemon.c

FROM scratch
COPY --from=builder /workdir/hypervkvpd /sbin/hypervkvpd
COPY libexec /usr/libexec/hypervkvpd/

ENTRYPOINT ["/sbin/hypervkvpd","-n"]
