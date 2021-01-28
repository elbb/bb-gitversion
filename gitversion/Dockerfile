FROM gittools/gitversion:5.6.4-alpine.3.12-x64-3.1

# install necessary tooling for jq installation
RUN apk add bash jq py3-jinja2 --no-cache
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