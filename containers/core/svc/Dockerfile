# Runtime Environment Variables:
# ROLE
# HOST_IP
# JOIN_IPS

FROM steelhive/l5s-core-base:latest
MAINTAINER Will Palmer <will@steelhive.com>

ARG CONSUL_VER

ENV CONSUL_VER ${CONSUL_VER:-0.8.3}

ENV HASHI_URL https://releases.hashicorp.com
ENV CONSUL_URL ${HASHI_URL}/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip

ADD ./entrypoint.sh /usr/bin/entrypoint.sh
ADD ./consul/consul-base.tpl /tmp/consul-base.tpl
ADD ./consul/consul-client.json /tmp/consul-client.json
ADD ./consul/consul-server.json /tmp/consul-server.json

RUN wget -qO consul.zip $CONSUL_URL && \
    unzip consul.zip && \
    rm consul.zip && \
    mv consul /usr/bin/consul && \
    mkdir /etc/consul && \
    mv /tmp/consul-base.tpl /etc/consul/consul-base.tpl && \
    mv /tmp/consul-client.json /etc/consul/consul-client.json && \
    mv /tmp/consul-server.json /etc/consul/consul-server.json

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600

ENTRYPOINT ["entrypoint.sh"]
