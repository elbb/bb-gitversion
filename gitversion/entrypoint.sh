#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o pipefail  # don't hide errors within pipes

if [ ! -z "$GIT_PATH" ]; then
  GIT=$(realpath ${GIT_PATH})
else
  GIT="/git"
fi

if [ ! -z "$GEN_PATH" ]; then
  GEN=$(realpath ${GEN_PATH})
else
  GEN="/gen"
fi

# check if /git is a git repository
if [ ! -d "${GIT}" ]; then
  echo "No git repository supplied. use docker -v PATH_TO_YOUR_REPO:${GIT}"
  exit 1
fi

if [ -z "${USERID}" ]; then
  echo "No user id supplied. Using default id '9001'"
  USERID=9001
fi

useradd --shell /bin/bash -u ${USERID} -o -c "" -m user

###### generate json ######

# generate json file with git version infos
JSON_DIR=${GEN}/json
mkdir -p ${JSON_DIR}
/tools/dotnet-gitversion ${GIT} /config /tools/GitVersion.yaml > ${JSON_DIR}/gitversion.json

# replace '+' with '-' in version strings due to incompabilities for e.g. docker
sed -i 's/+/-/g' ${JSON_DIR}/gitversion.json

###### generate env file ######

# create or clear file
ENV_DIR=${GEN}/env
mkdir -p ${ENV_DIR}
> ${ENV_DIR}/gitversion.env

# parse json and create sourceable file with git version infos
for s in $(cat ${JSON_DIR}/gitversion.json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
  echo "export GitVersion_$s" >> $ENV_DIR/gitversion.env
done

###### generate plain files ######

# create folder
PLAIN_DIR=${GEN}/plain
mkdir -p ${PLAIN_DIR}

for s in $(cat ${JSON_DIR}/gitversion.json | jq -r keys[] ); do
  > ${PLAIN_DIR}/${s}
  echo $(cat ${JSON_DIR}/gitversion.json | jq -r .${s} ) >> ${PLAIN_DIR}/${s}
done

###### generate cpp header file ######

# create folder
CPP_DIR=${GEN}/cpp
mkdir -p ${CPP_DIR}

# control paramaters to generate the cpp header file
TEMPLATE_FILE=/tools/templates/cpp/version.h.j2
INPUT_FILE=${JSON_DIR}/gitversion.json
OUTPUT_DIR=${CPP_DIR}/elbb
mkdir -p ${OUTPUT_DIR}
OUTPUT_FILE=${OUTPUT_DIR}/version.h

# generate cpp header file
/tools/gen_cpp_header/gen_version_header.py ${TEMPLATE_FILE} ${INPUT_FILE} ${OUTPUT_FILE}


###### generate docker version files ######
TAG_DIR=${GEN}/branch
mkdir -p ${TAG_DIR}
mkdir -p ${TAG_DIR}/env
mkdir -p ${TAG_DIR}/plain
if [ "$(cat ${JSON_DIR}/gitversion.json | jq -r .BranchName)" == "master" ]; then
    targetVersion="FullSemVer"
else
    targetVersion="InformationalVersion"
fi
echo "export GitVersionBranch=$(cat ${JSON_DIR}/gitversion.json | jq -r .${targetVersion})" > ${TAG_DIR}/env/gitversion.env
echo $(cat ${JSON_DIR}/gitversion.json | jq -r .${targetVersion} ) > ${TAG_DIR}/plain/version

# change ownership to local user
chown -R user:user ${GEN}

echo "Generation complete."