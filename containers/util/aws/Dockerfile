# Runtime Environment Variables:
# SLACK_BOT_TOKEN

FROM steelhive/l5s-core-base:latest
MAINTAINER Will Palmer <will@steelhive.com>

ADD ./aws-cli /usr/bin/aws-cli

ENTRYPOINT ["/usr/bin/aws-cli"]
