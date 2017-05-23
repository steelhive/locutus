# Runtime Environment Variables:
# ROLE
# HOST_IP
# JOIN_IPS

FROM steelhive/l5s-core-base:latest
MAINTAINER Will Palmer <will@steelhive.com>

ARG NOMAD_VER

ENV NOMAD_VER ${NOMAD_VER:-0.5.6}

ENV HASHI_URL https://releases.hashicorp.com
ENV NOMAD_URL ${HASHI_URL}/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip

ADD ./entrypoint.sh /usr/bin/entrypoint.sh
ADD ./nomad/nomad-base.tpl /tmp/nomad-base.tpl
ADD ./nomad/nomad-client.hcl /tmp/nomad-client.hcl
ADD ./nomad/nomad-server.hcl /tmp/nomad-server.hcl

RUN wget -qO nomad.zip $NOMAD_URL && \
    unzip nomad.zip && \
    rm nomad.zip && \
    mv nomad /usr/bin/nomad && \
    mkdir /etc/nomad && \
    mv /tmp/nomad-base.tpl /etc/nomad/nomad-base.tpl && \
    mv /tmp/nomad-client.hcl /etc/nomad/nomad-client.hcl && \
    mv /tmp/nomad-server.hcl /etc/nomad/nomad-server.hcl

EXPOSE 4646 4647 4648 4648/udp

VOLUME ["/var/run/docker.sock"]

ENTRYPOINT ["entrypoint.sh"]
