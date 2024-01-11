# Build stage
FROM amazonlinux:2023.3.20231218.0 as builder

RUN dnf install -y \
    which \
    unzip \
    less \
    groff

RUN curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && \
    unzip awscliv2.zip && \
    ./aws/install

RUN mkdir -p /aws-build/lib
RUN for line in $(ldd $(which groff) | grep / | sed -r 's/[^\/]*(\/[^ ]+).*/\1/'); do cp $line /aws-build/lib/; done
RUN for line in $(ldd $(which less)  | grep / | sed -r 's/[^\/]*(\/[^ ]+).*/\1/'); do cp $line /aws-build/lib/; done
RUN for line in $(ldd $(which aws)   | grep / | sed -r 's/[^\/]*(\/[^ ]+).*/\1/'); do cp $line /aws-build/lib/; done

RUN mkdir -p /aws-build/bin
RUN cp $(readlink -f $(which groff)) /aws-build/bin/ && \
    cp $(readlink -f $(which less))  /aws-build/bin/


# Run stage
FROM quay.io/keycloak/keycloak:23.0

USER root

RUN mkdir -p /tmp/backup/lib && \
    mkdir -p /tmp/backup/bin

RUN cp -r /lib     /tmp/backup/lib && \
    cp -r /usr/bin /tmp/backup/bin

COPY --from=builder /aws-build/lib/* /lib/
COPY --from=builder /aws-build/bin/* /usr/bin/

RUN cp -r /tmp/backup/lib /lib && \
    cp -r /tmp/backup/bin /usr/bin

COPY --from=builder /aws /aws

RUN ln -s /aws/dist/aws /usr/bin/aws

USER 1000

