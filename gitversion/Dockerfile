FROM gittools/gitversion:5.6.4-ubuntu.20.04-x64-5.0
# install necessary tooling for jq installation
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gpg gnupg-agent jq python-jinja2 && \
    rm -rf /var/lib/apt/lists/*

# copy GitVersion configuration
COPY GitVersion.yaml /tools/GitVersion.yaml

# copy cpp header generation
COPY  gen_cpp_header  /tools/gen_cpp_header
RUN chmod +x /tools/gen_cpp_header/gen_version_header.py

# copy template generation file
COPY  templates  /tools/templates

# copy script for semantic versioning generation
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]