FROM gittools/gitversion:5.1.4-linux-ubuntu-18.04-netcoreapp3.1

# install necessary tooling for jq installation
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gpg gnupg-agent python-jinja2 && \
    rm -rf /var/lib/apt/lists/*

ENV JQ_VERSION='1.5'

# install jq
RUN wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key -O /tmp/jq-release.key && \
    wget --no-check-certificate https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc -O /tmp/jq-linux64.asc && \
    wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 && \
    gpg --import /tmp/jq-release.key && \
    gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 && \
    cp /tmp/jq-linux64 /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    rm -f /tmp/jq-release.key && \
    rm -f /tmp/jq-linux64.asc && \
    rm -f /tmp/jq-linux64


# copy GitVersion configuration
COPY GitVersion.yaml /tools/GitVersion.yaml

# copy cpp header generation
COPY  /gen_cpp_header  /tools/gen_cpp_header
RUN chmod +x /tools/gen_cpp_header/gen_version_header.py

# copy script for semantic versioning generation
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]